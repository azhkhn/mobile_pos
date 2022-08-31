import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/db/db_functions/item_master/item_master_database.dart';
import 'package:mobile_pos/db/db_functions/purchase/purchase_database.dart';
import 'package:mobile_pos/db/db_functions/purchase/purchase_items_database.dart';
import 'package:mobile_pos/db/db_functions/transactions/transactions_database.dart';
import 'package:mobile_pos/db/db_functions/vat/vat_database.dart';
import 'package:mobile_pos/model/item_master/item_master_model.dart';
import 'package:mobile_pos/model/purchase/purchase_items_model.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';
import 'package:mobile_pos/model/transactions/transactions_model.dart';
import 'package:mobile_pos/screens/payments/partial_payment/widgets/payment_type_widget.dart';
import 'package:mobile_pos/screens/purchase/widgets/purchase_side_widget.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_alert.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/converters/converters.dart';

class PurchaseButtonsWidget extends ConsumerWidget {
  const PurchaseButtonsWidget({
    this.isVertical = false,
    Key? key,
  }) : super(key: key);

  final bool isVertical;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size _screenSize = MediaQuery.of(context).size;
    final bool isSmall = DeviceUtil.isSmall;

    return Column(
      children: [
        Container(
          height: isVertical
              ? isSmall
                  ? 22
                  : 32
              : _screenSize.width / 25,
          width: double.infinity,
          color: Colors.blueGrey,
          child: FractionallySizedBox(
            widthFactor: .95,
            heightFactor: .90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Text(
                    'Total Payable',
                    style: kItemsButtontyle,
                  ),
                ),
                kWidth5,
                Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: PurchaseSideWidget.totalPayableNotifier,
                    builder: (context, totalPayable, child) {
                      return FittedBox(
                        child: Text(
                          totalPayable == 0 ? '0' : Converter.currency.format(totalPayable),
                          overflow: TextOverflow.ellipsis,
                          style: kItemsButtontyle,
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: isVertical
                    ? isSmall
                        ? 33
                        : 40
                    : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    final List<ItemMasterModel> _selectedProducts = ref.read(PurchaseSideWidget.selectedProductProvider);

                    if (_selectedProducts.isEmpty) {
                      const PurchaseSideWidget().resetPurchase(ref);
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => KAlertDialog(
                                content: const Text('Are you sure want to cancel the purchase?'),
                                submitAction: () {
                                  Navigator.of(context).pop();
                                  const PurchaseSideWidget().resetPurchase(ref);
                                  Navigator.of(context).pop();
                                },
                              ));
                    }
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
                height: isVertical
                    ? isSmall
                        ? 33
                        : 40
                    : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () async {
                    final int? customerId = PurchaseSideWidget.supplierNotifier.value?.id;
                    final num items = PurchaseSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Supplier to add Purchase!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add Purchase!');
                    } else {
                      final _quantities = PurchaseSideWidget.quantityNotifier.value;
                      bool isValid = false;

                      for (var quantity in _quantities) {
                        final num? qty = num.tryParse(quantity.text);

                        if (qty != null && qty > 0) {
                          isValid = true;
                          log('valid = $qty');
                          continue;
                        } else {
                          isValid = false;
                          log('not valid = $qty');
                          break;
                        }
                      }

                      if (isValid) {
                        Navigator.pushNamed(context, routePartialPayment, arguments: {
                          'totalPayable': PurchaseSideWidget.totalPayableNotifier.value,
                          'totalItems': PurchaseSideWidget.totalItemsNotifier.value,
                          'purchase': true,
                          'isVertical': isVertical,
                        });
                      } else {
                        kSnackBar(context: context, content: 'Please enter valid item quantity', error: true);
                      }
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
    BuildContext context,
    WidgetRef ref, {
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
    supplierId = PurchaseSideWidget.supplierNotifier.value!.id!;
    supplierName = PurchaseSideWidget.supplierNotifier.value!.supplierName;
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
      final List<ItemMasterModel> _selectedProducts = ref.read(PurchaseSideWidget.selectedProductProvider);

      for (var i = 0; i < items; i++) {
        final vatMethod = _selectedProducts[i].vatMethod;
        final int categoryId = _selectedProducts[i].itemCategoryId, vatId = _selectedProducts[i].vatId, productId = _selectedProducts[i].id!;

        final String productType = _selectedProducts[i].productType,
            productCode = _selectedProducts[i].itemCode,
            productName = _selectedProducts[i].itemName,
            productCost = _selectedProducts[i].itemCost,
            unitPrice = _selectedProducts[i].itemCost,
            netUnitPrice = vatMethod == 'Inclusive'
                ? '${const PurchaseSideWidget().getExclusiveAmount(itemCost: unitPrice, vatRate: _selectedProducts[i].vatRate)}'
                : unitPrice,
            quantity = PurchaseSideWidget.quantityNotifier.value[i].text,
            subTotal = PurchaseSideWidget.subTotalNotifier.value[i],
            vatPercentage = _selectedProducts[i].productVAT,
            vatTotal = PurchaseSideWidget.itemTotalVatNotifier.value[i],
            unitCode = _selectedProducts[i].unit;

        final vat = await VatDatabase.instance.getVatById(vatId);
        final vatRate = vat.rate;

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
            vatMethod: vatMethod,
            vatRate: vatRate,
            vatPercentage: vatPercentage,
            vatTotal: vatTotal);

        //==================== Create Purchase Items ====================
        await _purchaseItemsDB.createPurchaseItems(_purchaseItemsModel);

        //==================== Update Item Cost and Quantity ====================
        await _itemMasterDB.updateItemCostAndQty(itemMaster: _selectedProducts[i], purchasedQty: num.parse(quantity));
      }

      if (paymentStatus != 'Credit') {
        final TransactionsModel _transaction = TransactionsModel(
          category: 'Purchase',
          transactionType: 'Expense',
          dateTime: dateTime,
          amount: paid,
          paymentMethod: paymentType,
          description: 'Transaction Completed Successfully!',
          purchaseId: purchaseId,
          supplierId: supplierId,
        );

        //==================== Create Transactions ====================
        await _transactionDB.createTransaction(_transaction);
      }

      kSnackBar(
        context: context,
        success: true,
        content: "Purchase Added Successfully!",
      );

      ref.refresh(PaymentTypeWidget.amountProvider);

      await const PurchaseSideWidget().resetPurchase(ref, notify: true);

      PaymentTypeWidget.formKey.currentState!.reset();

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
