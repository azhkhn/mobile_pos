import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/purchase/purchase_items_model.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/payment_type_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_product_side_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_side_widget.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/converters/converters.dart';

class PurchaseButtonsWidget extends StatelessWidget {
  const PurchaseButtonsWidget({
    this.isVertical = false,
    Key? key,
  }) : super(key: key);

  final bool isVertical;
  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // await PurchaseDatabase.instance.getAllPurchases();
        // await PurchaseItemsDatabase.instance.getAllPurchaseItems();
        // await TransactionDatabase.instance.getAllTransactions();
      } catch (e) {
        log(e.toString());
      }
    });

    return Column(
      children: [
        Container(
          height: isVertical
              ? _screenSize.height / 26
              : isVertical
                  ? _screenSize.height / 22
                  : _screenSize.width / 25,
          padding: const EdgeInsets.all(8),
          color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: kItemsButtontyle,
              ),
              kWidth5,
              Flexible(
                child: ValueListenableBuilder(
                  valueListenable: PurchaseSideWidget.totalPayableNotifier,
                  builder: (context, totalPayable, child) {
                    return Text(
                      totalPayable == 0 ? '0' : Converter.currency.format(totalPayable),
                      overflow: TextOverflow.ellipsis,
                      style: kItemsButtontyle,
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: isVertical ? _screenSize.height / 22 : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    PurchaseSideWidget.selectedProductsNotifier.value.clear();
                    PurchaseSideWidget.subTotalNotifier.value.clear();
                    PurchaseSideWidget.itemTotalVatNotifier.value.clear();
                    PurchaseSideWidget.supplierController.clear();
                    PurchaseSideWidget.quantityNotifier.value.clear();
                    PurchaseSideWidget.totalItemsNotifier.value = 0;
                    PurchaseSideWidget.totalQuantityNotifier.value = 0;
                    PurchaseSideWidget.totalAmountNotifier.value = 0;
                    PurchaseSideWidget.totalVatNotifier.value = 0;
                    PurchaseSideWidget.totalPayableNotifier.value = 0;
                    PurchaseSideWidget.supplierIdNotifier.value = null;
                    PurchaseSideWidget.supplierNameNotifier.value = null;
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.red[400],
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: kItemsButtontyle,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: isVertical ? _screenSize.height / 22 : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    final int? customerId = PurchaseSideWidget.supplierIdNotifier.value;
                    final num items = PurchaseSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Supplier to add Purchase!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add Purchase!');
                    } else {
                      Navigator.pushNamed(context, routePartialPayment, arguments: {
                        'totalPayable': PurchaseSideWidget.totalPayableNotifier.value,
                        'totalItems': PurchaseSideWidget.totalItemsNotifier.value,
                        'purchase': true,
                      });
                    }
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.green[700],
                  child: Center(
                    child: Text(
                      'Purchase',
                      style: kItemsButtontyle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

//========================================          ========================================
//======================================== Add Purchase ========================================
//========================================          ========================================
  addPurchase(
    BuildContext context, {
    required String argBalance,
    required String argPaymentStatus,
    required String argPaymentType,
    required String argPaid,
    required String? argPurchaseNote,
  }) async {
    final int? purchaseId;
    final int supplierId;
    final String referenceNumber,
        dateTime,
        supplierName,
        billerName,
        purchaseNote,
        totalItems,
        vatAmount,
        subTotal,
        discount,
        grantTotal,
        paid,
        balance,
        paymentType,
        purchaseStatus,
        paymentStatus,
        createdBy;

    final PurchaseDatabase _purchaseDB = PurchaseDatabase.instance;
    final PurchaseItemsDatabase _purchaseItemsDB = PurchaseItemsDatabase.instance;
    final TransactionDatabase _transactionDB = TransactionDatabase.instance;
    final ItemMasterDatabase _itemMasterDB = ItemMasterDatabase.instance;

    final _loggedUser = await UserUtils.instance.loggedUser;
    final String _user = _loggedUser.shopName;
    log('Logged User ==== $_user');

    final _businessProfile = await UserUtils.instance.businessProfile;
    final String _biller = _businessProfile.billerName;
    log('Biller Name ==== $_biller');

    referenceNumber = PurchaseSideWidget.referenceNumberController.text;
    dateTime = DateTime.now().toIso8601String();
    supplierId = PurchaseSideWidget.supplierIdNotifier.value!;
    supplierName = PurchaseSideWidget.supplierNameNotifier.value!;
    billerName = _biller;
    purchaseNote = argPurchaseNote ?? '';
    totalItems = PurchaseSideWidget.totalItemsNotifier.value.toString();
    vatAmount = PurchaseSideWidget.totalVatNotifier.value.toString();
    subTotal = PurchaseSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    grantTotal = PurchaseSideWidget.totalPayableNotifier.value.toString();
    paid = argPaid;
    balance = argBalance;
    paymentType = argPaymentType;
    purchaseStatus = 'Completed';
    paymentStatus = argPaymentStatus;
    createdBy = _user;

    final PurchaseModel _purchaseModel = PurchaseModel(
        referenceNumber: referenceNumber,
        dateTime: dateTime,
        supplierId: supplierId,
        supplierName: supplierName,
        billerName: billerName,
        purchaseNote: purchaseNote,
        totalItems: totalItems,
        vatAmount: vatAmount,
        subTotal: subTotal,
        discount: discount,
        grantTotal: grantTotal,
        paid: paid,
        balance: balance,
        paymentType: paymentType,
        purchaseStatus: purchaseStatus,
        paymentStatus: paymentStatus,
        createdBy: createdBy);

    try {
      //==================== Create Purchase ====================
      purchaseId = await _purchaseDB.createPurchase(_purchaseModel);

      final num items = PurchaseSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod = PurchaseSideWidget.selectedProductsNotifier.value[i].vatMethod;
        final int categoryId = PurchaseSideWidget.selectedProductsNotifier.value[i].itemCategoryId,
            vatId = PurchaseSideWidget.selectedProductsNotifier.value[i].vatId,
            productId = PurchaseSideWidget.selectedProductsNotifier.value[i].id!;

        final String productType = PurchaseSideWidget.selectedProductsNotifier.value[i].productType,
            productCode = PurchaseSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName = PurchaseSideWidget.selectedProductsNotifier.value[i].itemName,
            productCost = PurchaseSideWidget.selectedProductsNotifier.value[i].itemCost,
            unitPrice = PurchaseSideWidget.selectedProductsNotifier.value[i].itemCost,
            netUnitPrice = vatMethod == 'Inclusive'
                ? '${const PurchaseSideWidget().getExclusiveAmount(itemCost: unitPrice, vatRate: PurchaseSideWidget.selectedProductsNotifier.value[i].vatRate)}'
                : unitPrice,
            quantity = PurchaseSideWidget.quantityNotifier.value[i].text,
            subTotal = PurchaseSideWidget.subTotalNotifier.value[i],
            vatPercentage = PurchaseSideWidget.selectedProductsNotifier.value[i].productVAT,
            vatTotal = PurchaseSideWidget.itemTotalVatNotifier.value[i],
            unitCode = PurchaseSideWidget.selectedProductsNotifier.value[i].unit;

        log(' Purchase Id == $purchaseId');
        log(' Product id == $productId');
        log(' Product Type == $productType');
        log(' Product Code == $productCode');
        log(' Product Name == $productName');
        log(' Product Category Id == $categoryId');
        log(' Product Cost == $productCost');
        log(' Net Unit Price == $netUnitPrice');
        log(' Unit Price == $unitPrice');
        log(' Product quantity == $quantity');
        log(' Unit Code == $unitCode');
        log(' Product subTotal == $subTotal');
        log(' VAT id == $vatId');
        log(' VAT Percentage == $vatPercentage');
        log(' VAT Total == $vatTotal');
        log('\n==============================================\n');

        final PurchaseItemsModel _purchaseItemsModel = PurchaseItemsModel(
            purchaseId: purchaseId,
            productId: productId,
            productType: productType,
            productCode: productCode,
            productName: productName,
            categoryId: categoryId,
            productCost: productCost,
            netUnitPrice: netUnitPrice,
            unitPrice: unitPrice,
            quantity: quantity,
            unitCode: unitCode,
            subTotal: subTotal,
            vatId: vatId,
            vatPercentage: vatPercentage,
            vatTotal: vatTotal);

        //==================== Create Purchase Items ====================
        await _purchaseItemsDB.createPurchaseItems(_purchaseItemsModel);

        //==================== Update Item Cost and Quantity ====================
        _itemMasterDB.updateItemCostAndQty(itemMaster: PurchaseSideWidget.selectedProductsNotifier.value[i], purchasedQty: num.parse(quantity));
      }

      final TransactionsModel _transaction = TransactionsModel(
        category: 'Purchase',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: grantTotal,
        status: paymentStatus,
        description: 'Transaction Completed Successfully!',
        purchaseId: purchaseId,
      );

      //==================== Create Transactions ====================
      await _transactionDB.createTransaction(_transaction);

      kSnackBar(
        context: context,
        success: true,
        content: "Purchase Added Successfully!",
      );

      PaymentTypeWidget.amountController.clear();

      PurchaseProductSideWidget.itemsNotifier.value = await ItemMasterDatabase.instance.getAllItems();

      const PurchaseSideWidget().resetPurchase();

      Navigator.pop(context);
    } catch (e) {
      log('$e');
      kSnackBar(
        context: context,
        content: 'Something went wrong! Please try again later.',
        error: true,
      );
    }
  }
}
