import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/alertdialog/custom_alert.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sales_return/sales_return_database.dart';
import 'package:shop_ez/db/db_functions/sales_return/sales_return_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/sales_return/sales_return_items_model.dart';
import 'package:shop_ez/model/sales_return/sales_return_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_product_side.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_side_widget.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        log('==============================');
        await SalesReturnDatabase.instance.getAllSalesReturns();
        log('==============================');
        await SalesReturnItemsDatabase.instance.getAllSalesReuturnItems();
        log('==============================');
        await TransactionDatabase.instance.getAllTransactions();
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
                  valueListenable: SalesReturnSideWidget.totalPayableNotifier,
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
                height: isVertical
                    ? _screenSize.height / 22
                    : isVertical
                        ? _screenSize.height / 22
                        : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    final items = SalesReturnSideWidget.selectedProductsNotifier.value;
                    if (items.isEmpty) {
                      SalesReturnSideWidget.selectedProductsNotifier.value.clear();
                      SalesReturnSideWidget.subTotalNotifier.value.clear();
                      SalesReturnSideWidget.itemTotalVatNotifier.value.clear();
                      SalesReturnSideWidget.customerController.clear();
                      SalesReturnSideWidget.saleInvoiceController.clear();
                      SalesReturnSideWidget.quantityNotifier.value.clear();
                      SalesReturnSideWidget.totalItemsNotifier.value = 0;
                      SalesReturnSideWidget.totalQuantityNotifier.value = 0;
                      SalesReturnSideWidget.totalAmountNotifier.value = 0;
                      SalesReturnSideWidget.totalVatNotifier.value = 0;
                      SalesReturnSideWidget.totalPayableNotifier.value = 0;
                      SalesReturnSideWidget.customerIdNotifier.value = null;
                      SalesReturnSideWidget.customerNameNotifier.value = null;
                      SalesReturnSideWidget.originalInvoiceNumberNotifier.value = null;
                      SalesReturnSideWidget.originalSaleIdNotifier.value = null;
                      SalesReturnProductSideWidget.itemsNotifier.value.clear();
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return KAlertDialog(
                              content: const Text('Are you sure want to cancel the sales return?'),
                              submitAction: () {
                                Navigator.pop(context);
                                SalesReturnSideWidget.selectedProductsNotifier.value.clear();
                                SalesReturnSideWidget.subTotalNotifier.value.clear();
                                SalesReturnSideWidget.itemTotalVatNotifier.value.clear();
                                SalesReturnSideWidget.customerController.clear();
                                SalesReturnSideWidget.saleInvoiceController.clear();
                                SalesReturnSideWidget.quantityNotifier.value.clear();
                                SalesReturnSideWidget.totalItemsNotifier.value = 0;
                                SalesReturnSideWidget.totalQuantityNotifier.value = 0;
                                SalesReturnSideWidget.totalAmountNotifier.value = 0;
                                SalesReturnSideWidget.totalVatNotifier.value = 0;
                                SalesReturnSideWidget.totalPayableNotifier.value = 0;
                                SalesReturnSideWidget.customerIdNotifier.value = null;
                                SalesReturnSideWidget.customerNameNotifier.value = null;
                                SalesReturnSideWidget.originalInvoiceNumberNotifier.value = null;
                                SalesReturnSideWidget.originalSaleIdNotifier.value = null;
                                SalesReturnProductSideWidget.itemsNotifier.value.clear();
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
                height: isVertical ? _screenSize.height / 22 : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () async {
                    final int? customerId = SalesReturnSideWidget.customerIdNotifier.value;
                    final num items = SalesReturnSideWidget.totalItemsNotifier.value;

                    final String? originalInvoiceNumber = SalesReturnSideWidget.originalInvoiceNumberNotifier.value;

                    if (originalInvoiceNumber == null) {
                      return kSnackBar(context: context, content: 'Please select Invoice number to return sale');
                    }
                    if (customerId == null) {
                      return kSnackBar(context: context, content: 'Please select any Customer to return sale');
                    }
                    if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to return sale');
                    }
                    //========== Add Sales Return =========
                    await addSalesReturn(context);
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
    BuildContext context, {
    String? argBalance,
    String? argPaymentStatus,
    String? argPaymentType,
    String? argPaid,
    String? argSalesNote,
  }) async {
    int? originalSaleId;
    int salesReturnId, customerId;
    final String? originalInvoiceNumber;
    final String dateTime,
        customerName,
        billerName,
        salesNote,
        totalItems,
        vatAmount,
        subTotal,
        discount,
        grantTotal,
        paid,
        balance,
        paymentType,
        salesStatus,
        paymentStatus,
        createdBy;

    //==================== Database Instances ====================
    // final SalesDatabase salesDatabase = SalesDatabase.instance;
    final SalesReturnDatabase salesReturnDB = SalesReturnDatabase.instance;
    final SalesReturnItemsDatabase salesReturnItemsDB = SalesReturnItemsDatabase.instance;
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
      paid = SalesReturnSideWidget.totalPayableNotifier.value.toString();
    }

    // Save sale in a old date in Database
    // dateTime = DateTime(2022, 4, 22, 17, 45).toIso8601String();
    dateTime = DateTime.now().toIso8601String();
    originalInvoiceNumber = SalesReturnSideWidget.originalInvoiceNumberNotifier.value!;
    originalSaleId = SalesReturnSideWidget.originalSaleIdNotifier.value;
    customerId = SalesReturnSideWidget.customerIdNotifier.value!;
    customerName = SalesReturnSideWidget.customerNameNotifier.value!;
    billerName = _biller;
    salesNote = argSalesNote ?? '';
    totalItems = SalesReturnSideWidget.totalItemsNotifier.value.toString();
    vatAmount = SalesReturnSideWidget.totalVatNotifier.value.toString();
    subTotal = SalesReturnSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    grantTotal = SalesReturnSideWidget.totalPayableNotifier.value.toString();
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
      grantTotal: grantTotal,
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

      // salesReturnInvoiceNumber = idList.last;

      // //==================== Update Sales with Sales Return Id ====================
      // if (originalSaleId != null) {
      //   log('========== Updating Sales with Sales Return! ==========');
      //   await salesDatabase.updateReturnedSale(
      //       saleId: originalSaleId,
      //       salesReturnId: salesReturnId,
      //       salesReturnInvoice: salesReturnInvoiceNumber);
      // }

      final num items = SalesReturnSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod = SalesReturnSideWidget.selectedProductsNotifier.value[i].vatMethod;
        final int categoryId = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemCategoryId,
            vatId = SalesReturnSideWidget.selectedProductsNotifier.value[i].vatId,
            productId = SalesReturnSideWidget.selectedProductsNotifier.value[i].id!;

        final String productType = SalesReturnSideWidget.selectedProductsNotifier.value[i].productType,
            productCode = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName = SalesReturnSideWidget.selectedProductsNotifier.value[i].itemName,
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

        log(' Sales Return Id == $salesReturnId');
        log(' Sales Id == $originalSaleId');
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

        final SalesReturnItemsModel _salesReturnItemsModel = SalesReturnItemsModel(
          originalInvoiceNumber: originalInvoiceNumber,
          saleId: originalSaleId,
          saleReturnId: salesReturnId,
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
          vatMethod: vatMethod,
          vatId: vatId,
          vatRate: vatRate,
          vatPercentage: vatPercentage,
          vatTotal: vatTotal,
        );

        //==================== Create Sales Return Items ====================
        await salesReturnItemsDB.createSalesReturnItems(_salesReturnItemsModel);

        //==================== Increasing Item Quantity ====================
        itemMasterDB.additionItemQty(itemId: SalesReturnSideWidget.selectedProductsNotifier.value[i].id!, purchasedQty: num.parse(quantity));
      }

      final TransactionsModel _transaction = TransactionsModel(
        category: 'Sales Return',
        transactionType: 'Expense',
        dateTime: dateTime,
        amount: grantTotal,
        status: paymentStatus,
        description: 'Transaction $salesReturnId',
        salesId: originalSaleId,
        salesReturnId: salesReturnId,
      );

      //==================== Create Transactions ====================
      await transactionDB.createTransaction(_transaction);

      // HomeCardWidget.detailsCardLoaded = false;

      SalesReturnProductSideWidget.itemsNotifier.value = await ItemMasterDatabase.instance.getAllItems();

      const SalesReturnSideWidget().resetSalesReturn();

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
}
