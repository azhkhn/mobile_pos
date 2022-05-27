import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/purchase_return/purchase_return_database.dart';
import 'package:shop_ez/db/db_functions/purchase_return/purchase_return_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_items_modal.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_modal.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/purchase_return/widgets/purchase_return_product_side.dart';
import 'package:shop_ez/screens/purchase_return/widgets/purchase_return_side_widget.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/converters/converters.dart';

class PurchaseReturnButtonsWidget extends StatelessWidget {
  const PurchaseReturnButtonsWidget({
    this.isVertical = false,
    Key? key,
  }) : super(key: key);

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // log('==============================');
        // await PurchaseReturnDatabase.instance.getAllPurchasesReturns();
        // log('==============================');
        // await PurchaseReturnItemsDatabase.instance.getAllPurchaseReuturnItems();
        // log('==============================');
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
                  valueListenable: PurchaseReturnSideWidget.totalPayableNotifier,
                  builder: (context, totalPayable, child) {
                    return Text(totalPayable == 0 ? '0' : Converter.currency.format(totalPayable),
                        overflow: TextOverflow.ellipsis, style: kItemsButtontyle);
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
                    PurchaseReturnSideWidget.selectedProductsNotifier.value.clear();
                    PurchaseReturnSideWidget.subTotalNotifier.value.clear();
                    PurchaseReturnSideWidget.itemTotalVatNotifier.value.clear();
                    PurchaseReturnSideWidget.supplierController.clear();
                    PurchaseReturnSideWidget.quantityNotifier.value.clear();
                    PurchaseReturnSideWidget.totalItemsNotifier.value = 0;
                    PurchaseReturnSideWidget.totalQuantityNotifier.value = 0;
                    PurchaseReturnSideWidget.totalAmountNotifier.value = 0;
                    PurchaseReturnSideWidget.totalVatNotifier.value = 0;
                    PurchaseReturnSideWidget.totalPayableNotifier.value = 0;
                    PurchaseReturnSideWidget.supplierIdNotifier.value = null;
                    PurchaseReturnSideWidget.supplierNameNotifier.value = null;
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
                  onPressed: () async {
                    final int? customerId = PurchaseReturnSideWidget.supplierIdNotifier.value;
                    final num items = PurchaseReturnSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Supplier to return purchase!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to return purchase!');
                    } else {
                      await addPurchaseReturn(context);
                    }
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.green[700],
                  child: Center(
                    child: Text(
                      'Submit',
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

//========================================                 ========================================
//======================================== Add Purchase Return ========================================
//========================================                 ========================================
  addPurchaseReturn(
    BuildContext context, {
    String? argBalance,
    String? argPaymentStatus,
    String? argPaymentType,
    String? argPaid,
    String? argPurchaseNote,
  }) async {
    int? originalPurchaseId;
    int purchaseReturnId, supplierId;
    final String? originalInvoiceNumber;
    final String dateTime,
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

    //==================== Database Instances ====================
    // final PurchaseDatabase purchaseDatabase = PurchaseDatabase.instance;
    final PurchaseReturnDatabase purchaseReturnDB = PurchaseReturnDatabase.instance;
    final PurchaseReturnItemsDatabase purchaseReturnItemsDB = PurchaseReturnItemsDatabase.instance;
    final TransactionDatabase transactionDB = TransactionDatabase.instance;

    final ItemMasterDatabase itemMasterDB = ItemMasterDatabase.instance;

    final _loggedUser = await UserUtils.instance.loggedUser;
    final String _user = _loggedUser.shopName;
    log('Logged User ==== $_user');

    final _businessProfile = await UserUtils.instance.businessProfile;
    final String _biller = _businessProfile.billerName;
    log('Biller Name ==== $_biller');

//Checking if it's Partial Payment then Including Balance Amount
    if (argPaymentStatus != null) {
      paymentStatus = argPaymentStatus;
    } else {
      paymentStatus = 'Paid';
    }

    if (argBalance != null) {
      balance = argBalance;
    } else {
      balance = '0';
    }

    if (argPaymentType != null) {
      paymentType = argPaymentType;
    } else {
      paymentType = 'Cash';
    }

    if (argPaid != null) {
      paid = argPaid;
    } else {
      paid = PurchaseReturnSideWidget.totalPayableNotifier.value.toString();
    }

    // Save purchase in a old date in Database
    // dateTime = DateTime(2022, 4, 22, 17, 45).toIso8601String();
    dateTime = DateTime.now().toIso8601String();
    originalInvoiceNumber = PurchaseReturnSideWidget.originalInvoiceNumberNotifier.value;
    originalPurchaseId = PurchaseReturnSideWidget.originalPurchaseIdNotifier.value;
    supplierId = PurchaseReturnSideWidget.supplierIdNotifier.value!;
    supplierName = PurchaseReturnSideWidget.supplierNameNotifier.value!;
    billerName = _biller;
    purchaseNote = argPurchaseNote ?? '';
    totalItems = PurchaseReturnSideWidget.totalItemsNotifier.value.toString();
    vatAmount = PurchaseReturnSideWidget.totalVatNotifier.value.toString();
    subTotal = PurchaseReturnSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    grantTotal = PurchaseReturnSideWidget.totalPayableNotifier.value.toString();
    purchaseStatus = 'Returned';
    createdBy = _user;

    final PurchaseReturnModel _purchaseReturnModel = PurchaseReturnModel(
      dateTime: dateTime,
      originalInvoiceNumber: originalInvoiceNumber,
      purchaseid: originalPurchaseId,
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
      createdBy: createdBy,
      referenceNumber: '',
    );

    try {
      //==================== Create Purchase Return ====================
      final idList = await purchaseReturnDB.createPurchaseReturn(_purchaseReturnModel);
      purchaseReturnId = idList.first;

      // purchaseReturnInvoiceNumber = idList.last;

      // //==================== Update Purchase with Purchase Return Id ====================
      // if (originalPurchaseId != null) {
      //   log('========== Updating Purchase with Purchase Return! ==========');
      //   await PurchaseDatabase.updateReturnedPurchase(
      //       purchaseId: originalPurchaseId,
      //       purchaseReturnId: PurchaseReturnId,
      //       purchaseReturnInvoice: PurchaseReturnInvoiceNumber);
      // }

      final num items = PurchaseReturnSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].vatMethod;
        final int categoryId = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].itemCategoryId,
            vatId = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].vatId,
            productId = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].id!;

        final String productType = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].productType,
            productCode = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].itemName,
            productCost = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].itemCost,
            unitPrice = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].sellingPrice,
            netUnitPrice = vatMethod == 'Inclusive'
                ? '${const PurchaseReturnSideWidget().getExclusiveAmount(itemCost: unitPrice, vatRate: PurchaseReturnSideWidget.selectedProductsNotifier.value[i].vatRate)}'
                : unitPrice,
            quantity = PurchaseReturnSideWidget.quantityNotifier.value[i].text,
            subTotal = PurchaseReturnSideWidget.subTotalNotifier.value[i],
            vatPercentage = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].productVAT,
            vatTotal = PurchaseReturnSideWidget.itemTotalVatNotifier.value[i],
            unitCode = PurchaseReturnSideWidget.selectedProductsNotifier.value[i].unit;

        log(' Purchase Return Id == $purchaseReturnId');
        log(' Purchase Id == $originalPurchaseId');
        log(' Original Invoice Number == $originalInvoiceNumber');
        log(' Product id == $productId');
        log(' Product Type == $productType');
        log(' Product Code == $productCode');
        log(' Product Name == $productName');
        log(' Product Category == $categoryId');
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

        final PurchaseItemsReturnModel _purchaseReturnItemsModel = PurchaseItemsReturnModel(
          originalInvoiceNumber: originalInvoiceNumber,
          purchaseId: originalPurchaseId,
          purchaseReturnId: purchaseReturnId,
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
          vatTotal: vatTotal,
        );

        //==================== Create Purchase Return Items ====================
        await purchaseReturnItemsDB.createPurchaseReturnItems(_purchaseReturnItemsModel);

        //==================== Decreasing Item Quantity ====================
        itemMasterDB.additionItemQty(itemId: PurchaseReturnSideWidget.selectedProductsNotifier.value[i].id!, purchasedQty: num.parse(quantity));
      }

      final TransactionsModel _transaction = TransactionsModel(
        category: 'Purchase Return',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: grantTotal,
        status: paymentStatus,
        description: 'Transaction $purchaseReturnId',
        purchaseId: originalPurchaseId,
        purchaseReturnId: purchaseReturnId,
      );

      //==================== Create Transactions ====================
      await transactionDB.createTransaction(_transaction);

      // HomeCardWidget.detailsCardLoaded = false;

      PurchaseReturnProductSideWidget.itemsNotifier.value = await ItemMasterDatabase.instance.getAllItems();

      const PurchaseReturnSideWidget().resetPurchaseReturn();

      kSnackBar(
        context: context,
        success: true,
        content: "Purchase has been returned successfully!",
      );
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
