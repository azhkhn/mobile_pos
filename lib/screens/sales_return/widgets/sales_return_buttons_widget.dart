import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_alert.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/db/db_functions/item_master/item_master_database.dart';
import 'package:mobile_pos/db/db_functions/sales/sales_database.dart';
import 'package:mobile_pos/db/db_functions/sales_return/sales_return_database.dart';
import 'package:mobile_pos/db/db_functions/sales_return/sales_return_items_database.dart';
import 'package:mobile_pos/db/db_functions/transactions/transactions_database.dart';
import 'package:mobile_pos/db/db_functions/vat/vat_database.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import 'package:mobile_pos/model/sales_return/sales_return_items_model.dart';
import 'package:mobile_pos/model/sales_return/sales_return_model.dart';
import 'package:mobile_pos/model/transactions/transactions_model.dart';
import 'package:mobile_pos/screens/sales_return/widgets/sales_return_side_widget.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/converters/converters.dart';

class SalesReturnButtonsWidget extends StatelessWidget {
  const SalesReturnButtonsWidget({
    this.isVertical = false,
    Key? key,
  }) : super(key: key);
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    final bool isSmall = DeviceUtil.isSmall;

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   try {
    //     log('==========================================================================================');
    //     await SalesReturnDatabase.instance.getAllSalesReturns();
    //     log('==========================================================================================');
    //     await SalesReturnItemsDatabase.instance.getAllSalesReuturnItems();
    //     log('==========================================================================================');
    //     await TransactionDatabase.instance.getAllTransactions();
    //   } catch (e) {
    //     log(e.toString());
    //   }
    // });

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
                    valueListenable: SalesReturnSideWidget.totalPayableNotifier,
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
                    final items = SalesReturnSideWidget.selectedProductsNotifier.value;
                    if (items.isEmpty) {
                      const SalesReturnSideWidget().resetSalesReturn();

                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return KAlertDialog(
                              content: const Text('Are you sure want to cancel the sales return?'),
                              submitAction: () {
                                Navigator.pop(context);
                                const SalesReturnSideWidget().resetSalesReturn();

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
                    final int? customerId = SalesReturnSideWidget.customerNotifier.value?.id;
                    final num items = SalesReturnSideWidget.totalItemsNotifier.value;

                    final String? originalInvoiceNumber = SalesReturnSideWidget.originalSaleNotifier.value?.invoiceNumber;

                    if (originalInvoiceNumber == null) {
                      return kSnackBar(context: context, content: 'Please select Invoice number to return sale');
                    }
                    if (customerId == null) {
                      return kSnackBar(context: context, content: 'Please select any Customer to return sale');
                    }
                    if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to return sale');
                    }

                    final _quantities = SalesReturnSideWidget.quantityNotifier.value;
                    final _selectedItems = SalesReturnSideWidget.selectedProductsNotifier.value;
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
                                    //========== Add Sales Return =========
                                    final sale = SalesReturnSideWidget.originalSaleNotifier.value!;
                                    await addSalesReturn(context, sale, argPaymentStatus: sale.paymentStatus);
                                  },
                                  child: const Text('Accept')),
                            ],
                          );
                        },
                      );
                    } else {
                      kSnackBar(context: context, content: 'Please enter valid item quantity', error: true);
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
//======================================== Add Sale Return ========================================
//========================================                 ========================================
  addSalesReturn(
    BuildContext context,
    SalesModel sale, {
    String? argBalance,
    String? argPaymentStatus,
    String? argPaymentType,
    String? argPaid,
    String? argSalesNote,
  }) async {
    int? originalSaleId;
    int salesReturnId, customerId;
    final String originalInvoiceNumber;
    final String dateTime,
        customerName,
        billerName,
        salesNote,
        totalItems,
        vatAmount,
        subTotal,
        discount,
        returnAmount,
        paid,
        balance,
        paymentType,
        salesStatus,
        paymentStatus,
        createdBy;

    //==================== Database Instances ====================
    final SalesReturnDatabase salesReturnDB = SalesReturnDatabase.instance;
    final SalesReturnItemsDatabase salesReturnItemsDB = SalesReturnItemsDatabase.instance;
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
      paid = SalesReturnSideWidget.totalPayableNotifier.value.toString();
    }

    // Save sale in a old date in Database
    // dateTime = DateTime(2022, 4, 22, 17, 45).toIso8601String();
    dateTime = DateTime.now().toIso8601String();
    originalInvoiceNumber = SalesReturnSideWidget.originalSaleNotifier.value!.invoiceNumber!;
    originalSaleId = SalesReturnSideWidget.originalSaleNotifier.value!.id;
    customerId = SalesReturnSideWidget.customerNotifier.value!.id!;
    customerName = SalesReturnSideWidget.customerNotifier.value!.customer;
    billerName = _biller;
    salesNote = argSalesNote ?? '';
    totalItems = SalesReturnSideWidget.totalItemsNotifier.value.toString();
    vatAmount = SalesReturnSideWidget.totalVatNotifier.value.toString();
    subTotal = SalesReturnSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    returnAmount = SalesReturnSideWidget.totalPayableNotifier.value.toString();
    salesStatus = 'Returned';
    createdBy = _user;

    final SalesReturnModal _salesReturnModel = SalesReturnModal(
      dateTime: dateTime,
      originalInvoiceNumber: originalInvoiceNumber,
      saleId: originalSaleId,
      customerId: customerId,
      customerName: customerName,
      billerName: billerName,
      salesNote: salesNote,
      totalItems: totalItems,
      vatAmount: vatAmount,
      subTotal: subTotal,
      discount: discount,
      grantTotal: returnAmount,
      paid: paid,
      balance: balance,
      paymentType: paymentType,
      salesStatus: salesStatus,
      paymentStatus: paymentStatus,
      createdBy: createdBy,
    );

    try {
      //==================== Create Sales Return ====================
      final idList = await salesReturnDB.createSalesReturn(_salesReturnModel);
      salesReturnId = idList.first;

      final num items = SalesReturnSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod = SalesReturnSideWidget.selectedProductsNotifier.value[i].vatMethod;
        final int categoryId = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemCategoryId,
            vatId = SalesReturnSideWidget.selectedProductsNotifier.value[i].vatId,
            productId = SalesReturnSideWidget.selectedProductsNotifier.value[i].id!;

        final String productType = SalesReturnSideWidget.selectedProductsNotifier.value[i].productType,
            productCode = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemName,
            productNameArabic = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemNameArabic,
            productCost = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemCost,
            unitPrice = SalesReturnSideWidget.selectedProductsNotifier.value[i].sellingPrice,
            netUnitPrice = vatMethod == 'Inclusive'
                ? '${const SalesReturnSideWidget().getExclusiveAmount(sellingPrice: unitPrice, vatRate: SalesReturnSideWidget.selectedProductsNotifier.value[i].vatRate)}'
                : unitPrice,
            quantity = SalesReturnSideWidget.quantityNotifier.value[i].text,
            subTotal = SalesReturnSideWidget.subTotalNotifier.value[i],
            vatPercentage = SalesReturnSideWidget.selectedProductsNotifier.value[i].productVAT,
            vatTotal = SalesReturnSideWidget.itemTotalVatNotifier.value[i],
            unitCode = SalesReturnSideWidget.selectedProductsNotifier.value[i].unit;

        final vat = await VatDatabase.instance.getVatById(vatId);
        final vatRate = vat.rate;

        // log(' Sales Return Id == $salesReturnId');
        // log(' Sales Id == $originalSaleId');
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

        final SalesReturnItemsModel _salesReturnItemsModel = SalesReturnItemsModel(
          originalInvoiceNumber: originalInvoiceNumber,
          saleId: originalSaleId,
          saleReturnId: salesReturnId,
          productId: productId,
          productType: productType,
          productCode: productCode,
          productName: productName,
          productNameArabic: productNameArabic,
          categoryId: categoryId,
          productCost: productCost,
          netUnitPrice: netUnitPrice,
          unitPrice: unitPrice,
          quantity: quantity,
          unitCode: unitCode,
          subTotal: subTotal,
          vatMethod: vatMethod,
          vatId: vatId,
          vatRate: vatRate,
          vatPercentage: vatPercentage,
          vatTotal: vatTotal,
        );

        //==================== Create Sales Return Items ====================
        await salesReturnItemsDB.createSalesReturnItems(_salesReturnItemsModel);

        //==================== Increasing Item Quantity ====================
        await itemMasterDB.additionItemQty(itemId: SalesReturnSideWidget.selectedProductsNotifier.value[i].id!, purchasedQty: num.parse(quantity));
      }

      //==================== Create Transaction based on Payment Status ====================
      await createTransaction(dateTime: dateTime, returnAmount: returnAmount, sale: sale, salesReturnId: salesReturnId);

      // HomeCardWidget.detailsCardLoaded = false;

      const SalesReturnSideWidget().resetSalesReturn(notify: true);

      // SalesReturnProductSideWidget.itemsNotifier.value = await ItemMasterDatabase.instance.getAllItems();

      kSnackBar(
        context: context,
        success: true,
        content: "Sale has been returned successfully!",
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

  //==================== On Sales Return Transaction ====================
  Future<void> createTransaction({
    required String dateTime,
    required String returnAmount,
    required SalesModel sale,
    required int salesReturnId,
  }) async {
    final SalesDatabase salesDatabase = SalesDatabase.instance;
    final TransactionDatabase transactionDatabase = TransactionDatabase.instance;

    final num _totalAmount = num.parse(sale.grantTotal);
    final num _paidAmount = num.parse(sale.paid);
    final num _alreadyReturnedAmount = num.parse(sale.returnAmount ?? '0');
    final num _returningAmount = num.parse(returnAmount);
    final num _updatedReturnAmount = _alreadyReturnedAmount + _returningAmount;

    log('Total Amount == $_totalAmount');
    log('Paid Amount == $_paidAmount');
    log('Already Returned Amount == $_alreadyReturnedAmount');
    log('Returning Amount == $_returningAmount');
    log('Updated Return Amount == $_updatedReturnAmount');

    //____________________ Payment Status == Paid ____________________
    if (sale.paymentStatus == 'Paid') {
      final num _updatedPaidAmount = _totalAmount - _updatedReturnAmount;
      final num _updatedBalance = _totalAmount - _updatedReturnAmount;

      log('Updated Paid Amount == $_updatedPaidAmount');
      log('Updated Balance == $_updatedBalance');

      final TransactionsModel _transactionSR = TransactionsModel(
        category: 'Sales Return',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction ',
        salesId: sale.id,
        salesReturnId: salesReturnId,
        customerId: sale.customerId,
      );
      //-------------------- Create Transaction --------------------
      await transactionDatabase.createTransaction(_transactionSR);

      final updatedSale = sale.copyWith(
        returnAmount: _updatedReturnAmount.toString(),
        paymentStatus: _updatedPaidAmount == 0 ? 'Returned' : 'Paid',
        paid: _updatedPaidAmount.toString(),
      );

      //-------------------- Update Sale with Sales Return --------------------
      await salesDatabase.updateSaleBySalesId(sale: updatedSale);
    }

    //____________________ Payment Status == Partial ____________________
    else if (sale.paymentStatus == 'Partial') {
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

      final TransactionsModel _transactionForSale = TransactionsModel(
        category: 'Sales',
        transactionType: 'Income',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $salesReturnId',
        salesId: sale.id,
        salesReturnId: salesReturnId,
        customerId: sale.customerId,
      );

      final TransactionsModel _transactionForSalesReturn = TransactionsModel(
        category: 'Sales Return',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $salesReturnId',
        salesId: sale.id,
        salesReturnId: salesReturnId,
        customerId: sale.customerId,
      );

      if (_paidAmount > _updatedPaidAmount) {
        final String _refundAmount = Converter.amountRounderString(_paidAmount - _updatedPaidAmount);
        log('Refund Amount == $_refundAmount');
        final TransactionsModel _transactionForPR = TransactionsModel(
          category: 'Sale Return',
          transactionType: 'Expense',
          dateTime: dateTime,
          amount: _refundAmount,
          description: 'Transaction $salesReturnId',
          purchaseId: sale.id,
          purchaseReturnId: salesReturnId,
          customerId: sale.customerId,
        );

        await transactionDatabase.createTransaction(_transactionForPR);
      }

      //-------------------- Create Transactions --------------------
      await transactionDatabase.createTransaction(_transactionForSale);
      await transactionDatabase.createTransaction(_transactionForSalesReturn);

      // ---------- When Sale is fully returned ----------
      if (_updatedReturnAmount == _totalAmount) {
        final TransactionsModel _transactionSR = TransactionsModel(
          category: 'Sales Return',
          transactionType: 'Expense',
          dateTime: dateTime,
          amount: _paidAmount.toString(),
          description: 'Transaction $salesReturnId',
          salesId: sale.id,
          salesReturnId: salesReturnId,
          customerId: sale.customerId,
        );

        //-------------------- Create Transactions --------------------
        await transactionDatabase.createTransaction(_transactionSR);

        final updatedSale = sale.copyWith(
          returnAmount: _updatedReturnAmount.toString(),
          balance: '0',
          paymentStatus: 'Returned',
          paid: '0',
        );
        //-------------------- Update Sale with Sales Return --------------------
        await salesDatabase.updateSaleBySalesId(sale: updatedSale);
      } else {
        final updatedSale = sale.copyWith(
          returnAmount: _updatedReturnAmount.toString(),
          balance: _updatedBalance.toString(),
          paid: paidAmount.toString(),
          paymentStatus: _updatedBalance <= 0 ? 'Paid' : 'Partial',
        );

        //-------------------- Update Sale with Sales Return --------------------
        await salesDatabase.updateSaleBySalesId(sale: updatedSale);
      }
    }
    //____________________ Payment Status == Credit ____________________
    else {
      final num _updatedBalance = _totalAmount - _updatedReturnAmount;
      log('Updated Balance == $_updatedBalance');

      final TransactionsModel _transactionS = TransactionsModel(
        category: 'Sales',
        transactionType: 'Income',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $salesReturnId',
        salesId: sale.id,
        salesReturnId: salesReturnId,
        customerId: sale.customerId,
      );

      final TransactionsModel _transactionSR = TransactionsModel(
        category: 'Sales Return',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: returnAmount,
        description: 'Transaction $salesReturnId',
        salesId: sale.id,
        salesReturnId: salesReturnId,
        customerId: sale.customerId,
      );

      //-------------------- Create Transactions --------------------
      await transactionDatabase.createTransaction(_transactionSR);
      await transactionDatabase.createTransaction(_transactionS);

      final updatedSale = sale.copyWith(
        returnAmount: _updatedReturnAmount.toString(),
        balance: _updatedBalance.toString(),
        paymentStatus: _totalAmount == _updatedReturnAmount ? 'Returned' : 'Credit',
      );

      //-------------------- Update Sale with Sales Return --------------------
      await salesDatabase.updateSaleBySalesId(sale: updatedSale);
    }
  }
}
