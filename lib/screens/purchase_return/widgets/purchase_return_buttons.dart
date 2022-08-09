import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/purchase_return/purchase_return_database.dart';
import 'package:shop_ez/db/db_functions/purchase_return/purchase_return_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_items_modal.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_modal.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/purchase_return/widgets/purchase_return_product_side.dart';
import 'package:shop_ez/screens/purchase_return/widgets/purchase_return_side.dart';

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
    final bool isSmall = DeviceUtil.isSmall;

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
                    valueListenable: PurchaseReturnSideWidget.totalPayableNotifier,
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
                    final items = PurchaseReturnSideWidget.selectedProductsNotifier.value;
                    if (items.isEmpty) {
                      const PurchaseReturnSideWidget().resetPurchaseReturn();
                      PurchaseReturnProductSideWidget.itemsNotifier.value.clear();
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return KAlertDialog(
                              content: const Text('Are you sure want to cancel the purchase return?'),
                              submitAction: () {
                                Navigator.pop(context);
                                const PurchaseReturnSideWidget().resetPurchaseReturn();
                                PurchaseReturnProductSideWidget.itemsNotifier.value.clear();
                                Navigator.pop(context);
                              },
                            );
                          });
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
                    final int? customerId = PurchaseReturnSideWidget.supplierNotifier.value?.id;
                    final num items = PurchaseReturnSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Supplier to return purchase!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to return purchase!');
                    } else {
                      final _quantities = PurchaseReturnSideWidget.quantityNotifier.value;
                      final _selectedItems = PurchaseReturnSideWidget.selectedProductsNotifier.value;
                      bool isValid = false;

                      for (var i = 0; i < _quantities.length; i++) {
                        final quantity = _quantities[i].text;
                        final num soldQty = num.parse(_selectedItems[i].openingStock);
                        final num? qty = num.tryParse(quantity);

                        if (qty != null && qty > 0 && qty <= soldQty) {
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
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                  title: const Text(
                                    'Sales Return',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  content: const Text('Do you want to return this sale?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(ctx);
                                          final purchase = PurchaseReturnSideWidget.originalPurchaseNotifier.value!;
                                          //========== Add Purchase Return =========
                                          await addPurchaseReturn(context, purchase);
                                        },
                                        child: const Text('Accept')),
                                  ]);
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
    BuildContext context,
    PurchaseModel purchase, {
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
        returnAmount,
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
    originalInvoiceNumber = PurchaseReturnSideWidget.originalPurchaseNotifier.value!.invoiceNumber;
    originalPurchaseId = PurchaseReturnSideWidget.originalPurchaseNotifier.value!.id;
    supplierId = PurchaseReturnSideWidget.supplierNotifier.value!.id!;
    supplierName = PurchaseReturnSideWidget.supplierNotifier.value!.supplierName;
    billerName = _biller;
    purchaseNote = argPurchaseNote ?? '';
    totalItems = PurchaseReturnSideWidget.totalItemsNotifier.value.toString();
    vatAmount = PurchaseReturnSideWidget.totalVatNotifier.value.toString();
    subTotal = PurchaseReturnSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    returnAmount = PurchaseReturnSideWidget.totalPayableNotifier.value.toString();
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
      grantTotal: returnAmount,
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

        // log(' Purchase Return Id == $purchaseReturnId');
        // log(' Purchase Id == $originalPurchaseId');
        // log(' Original Invoice Number == $originalInvoiceNumber');
        // log(' Product id == $productId');
        // log(' Product Type == $productType');
        // log(' Product Code == $productCode');
        // log(' Product Name == $productName');
        // log(' Product Category == $categoryId');
        // log(' Product Cost == $productCost');
        // log(' Net Unit Price == $netUnitPrice');
        // log(' Unit Price == $unitPrice');
        // log(' Product quantity == $quantity');
        // log(' Unit Code == $unitCode');
        // log(' Product subTotal == $subTotal');
        // log(' VAT id == $vatId');
        // log(' VAT Percentage == $vatPercentage');
        // log(' VAT Total == $vatTotal');
        // log('\n==============================================\n');

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
        await itemMasterDB.subtractItemQty(itemId: PurchaseReturnSideWidget.selectedProductsNotifier.value[i].id!, soldQty: num.parse(quantity));
      }

      //==================== Create Transaction based on Payment Status ====================
      await createTransaction(dateTime: dateTime, returnAmount: returnAmount, purchase: purchase, purchaseReturnId: purchaseReturnId);

      // HomeCardWidget.detailsCardLoaded = false;

      const PurchaseReturnSideWidget().resetPurchaseReturn(notify: true);
      PurchaseReturnProductSideWidget.itemsNotifier.value.clear();

      PurchaseReturnProductSideWidget.itemsNotifier.value = await ItemMasterDatabase.instance.getAllItems();

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

  //==================== On Purchase Return Transaction ====================
  Future<void> createTransaction({
    required String dateTime,
    required String returnAmount,
    required PurchaseModel purchase,
    required int purchaseReturnId,
  }) async {
    final PurchaseDatabase purchaseDatabase = PurchaseDatabase.instance;
    final TransactionDatabase transactionDatabase = TransactionDatabase.instance;

    final num _totalAmount = num.parse(purchase.grantTotal);
    final num _paidAmount = num.parse(purchase.paid);
    final num _alreadyReturnedAmount = num.parse(purchase.returnAmount ?? '0');
    final num _returningAmount = num.parse(returnAmount);
    final num _updatedReturnAmount = Converter.amountRounder(_alreadyReturnedAmount + _returningAmount);

    log('Total Amount == $_totalAmount');
    log('Paid Amount == $_paidAmount');
    log('Already Returned Amount == $_alreadyReturnedAmount');
    log('Returning Amount == $_returningAmount');
    log('Updated Return Amount == $_updatedReturnAmount');

    //____________________ Payment Status == Paid ____________________
    if (purchase.paymentStatus == 'Paid') {
      final num _updatedPaidAmount = Converter.amountRounder(_totalAmount - _updatedReturnAmount);
      final num _updatedBalance = Converter.amountRounder(_totalAmount - _updatedReturnAmount);

      log('Updated Paid Amount == $_updatedPaidAmount');
      log('Updated Balance == $_updatedBalance');

      final TransactionsModel _transactionSR = TransactionsModel(
        category: 'Purchase Return',
        transactionType: 'Income',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction ',
        purchaseId: purchase.id,
        purchaseReturnId: purchaseReturnId,
        supplierId: purchase.supplierId,
      );
      //-------------------- Create Transaction --------------------
      await transactionDatabase.createTransaction(_transactionSR);

      final updatedPurchase = purchase.copyWith(
        returnAmount: _updatedReturnAmount.toString(),
        paymentStatus: _updatedPaidAmount == 0 ? 'Returned' : 'Paid',
        paid: _updatedPaidAmount.toString(),
      );

      //-------------------- Update Purchase with Purchase Return --------------------
      await purchaseDatabase.updatePurchaseByPurchaseId(purchase: updatedPurchase);
    }

    //____________________ Payment Status == Partial ____________________
    else if (purchase.paymentStatus == 'Partial') {
      final num _updatedPaidAmount = Converter.amountRounder(_totalAmount - _updatedReturnAmount);
      num paidAmount = 0;
      if (_paidAmount > _updatedPaidAmount) {
        paidAmount = _updatedPaidAmount;
        log('Updated Paid Amount == $_updatedPaidAmount');
      } else {
        paidAmount = _paidAmount;
      }
      final num _updatedBalance = Converter.amountRounder(_totalAmount - _updatedReturnAmount - paidAmount);
      log('Updated Balance == $_updatedBalance');

      final TransactionsModel _transactionForPurchase = TransactionsModel(
        category: 'Purchase',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $purchaseReturnId',
        purchaseId: purchase.id,
        purchaseReturnId: purchaseReturnId,
        supplierId: purchase.supplierId,
      );

      final TransactionsModel _transactionForPurchasesReturn = TransactionsModel(
        category: 'Purchase Return',
        transactionType: 'Income',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $purchaseReturnId',
        purchaseId: purchase.id,
        purchaseReturnId: purchaseReturnId,
        supplierId: purchase.supplierId,
      );

      if (_paidAmount > _updatedPaidAmount) {
        final String _refundAmount = Converter.amountRounderString(_paidAmount - _updatedPaidAmount);
        log('Refund Amount == $_refundAmount');
        final TransactionsModel _transactionForPR = TransactionsModel(
          category: 'Purchase Return',
          transactionType: 'Income',
          dateTime: dateTime,
          amount: _refundAmount,
          description: 'Transaction $purchaseReturnId',
          purchaseId: purchase.id,
          purchaseReturnId: purchaseReturnId,
          supplierId: purchase.supplierId,
        );

        await transactionDatabase.createTransaction(_transactionForPR);
      }

      //-------------------- Create Transactions --------------------
      await transactionDatabase.createTransaction(_transactionForPurchase);
      await transactionDatabase.createTransaction(_transactionForPurchasesReturn);

      // ---------- When purchase is fully returned ----------
      if (_updatedReturnAmount == _totalAmount) {
        final TransactionsModel _transactionSR = TransactionsModel(
          category: 'Purchase Return',
          transactionType: 'Income',
          dateTime: dateTime,
          amount: _paidAmount.toString(),
          description: 'Transaction $purchaseReturnId',
          purchaseId: purchase.id,
          supplierId: purchase.supplierId,
          purchaseReturnId: purchaseReturnId,
        );

        //-------------------- Create Transactions --------------------
        await transactionDatabase.createTransaction(_transactionSR);

        final updatedPurchase = purchase.copyWith(
          returnAmount: _updatedReturnAmount.toString(),
          balance: '0',
          paymentStatus: 'Returned',
          paid: '0',
        );
        //-------------------- Update Purchase with Purchase Return --------------------
        await purchaseDatabase.updatePurchaseByPurchaseId(purchase: updatedPurchase);
      } else {
        final updatedPurchase = purchase.copyWith(
          returnAmount: _updatedReturnAmount.toString(),
          balance: _updatedBalance.toString(),
          paid: paidAmount.toString(),
          paymentStatus: _updatedBalance <= 0 ? 'Paid' : 'Partial',
        );

        //-------------------- Update Purchase with Purchase Return --------------------
        await purchaseDatabase.updatePurchaseByPurchaseId(purchase: updatedPurchase);
      }
    }
    //____________________ Payment Status == Credit ____________________
    else {
      final num _updatedBalance = Converter.amountRounder(_totalAmount - _updatedReturnAmount);
      log('Updated Balance == $_updatedBalance');

      final TransactionsModel _transactionS = TransactionsModel(
        category: 'Purchase',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $purchaseReturnId',
        purchaseId: purchase.id,
        purchaseReturnId: purchaseReturnId,
        supplierId: purchase.supplierId,
      );

      final TransactionsModel _transactionSR = TransactionsModel(
        category: 'Purchase Return',
        transactionType: 'Income',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $purchaseReturnId',
        purchaseId: purchase.id,
        purchaseReturnId: purchaseReturnId,
        supplierId: purchase.supplierId,
      );

      //-------------------- Create Transactions --------------------
      await transactionDatabase.createTransaction(_transactionSR);
      await transactionDatabase.createTransaction(_transactionS);

      final updatedPurchase = purchase.copyWith(
        returnAmount: _updatedReturnAmount.toString(),
        balance: _updatedBalance.toString(),
        paymentStatus: _totalAmount == _updatedReturnAmount ? 'Returned' : 'Credit',
      );

      //-------------------- Update Purchase with Purchase Return --------------------
      await purchaseDatabase.updatePurchaseByPurchaseId(purchase: updatedPurchase);
    }
  }
}
