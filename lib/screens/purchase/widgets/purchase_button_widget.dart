import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_side_widget.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/text/converters.dart';

class PurchaseButtonsWidget extends StatelessWidget {
  const PurchaseButtonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = DeviceUtil.isTablet;
    Size _screenSize = MediaQuery.of(context).size;

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
        await SalesDatabase.instance.getAllSales();
        await SalesItemsDatabase.instance.getAllSalesItems();
        await TransactionDatabase.instance.getAllTransactions();
      } catch (e) {
        log(e.toString());
      }
    });

    return Column(
      children: [
        Container(
          height: _screenSize.width / 25,
          padding: const EdgeInsets.all(8),
          color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                'Total Payable',
                style: TextStyle(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 12 : 11),
                minFontSize: 8,
              ),
              kWidth5,
              Flexible(
                child: ValueListenableBuilder(
                  valueListenable: PurchaseSideWidget.totalPayableNotifier,
                  builder: (context, totalPayable, child) {
                    return AutoSizeText(
                      totalPayable == 0
                          ? '0'
                          : Converter.currency.format(totalPayable),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 12 : 11,
                      ),
                      minFontSize: 8,
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
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.all(5),
                  color: Colors.red[400],
                  child: Center(
                    child: AutoSizeText(
                      'Cancel',
                      style: TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 12 : 11),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    final int? cusomerId =
                        PurchaseSideWidget.supplierIdNotifier.value;
                    final num items =
                        PurchaseSideWidget.totalItemsNotifier.value;

                    if (cusomerId == null) {
                      kSnackBar(
                          context: context,
                          content:
                              'Please select any Supplier to add Purchase!');
                    } else if (items == 0) {
                      return kSnackBar(
                          context: context,
                          content:
                              'Please select any Products to add Purchase!');
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Purchase',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            content:
                                const Text('Do you want to add this purchase?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    // addSale(context);
                                  },
                                  child: const Text('Accept')),
                            ],
                          );
                        },
                      );
                    }
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.green[700],
                  child: Center(
                    child: AutoSizeText(
                      'Purchase',
                      style: TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 12 : 11),
                      minFontSize: 8,
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
//======================================== Add Sale ========================================
//========================================          ========================================
  addSale(
    BuildContext context, {
    String? argBalance,
    String? argPaymentStatus,
    String? argPaymentType,
    String? argPaid,
  }) async {
    int? salesId;
    int cusomerId;
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

    final SalesDatabase salesDB = SalesDatabase.instance;
    final SalesItemsDatabase salesItemDB = SalesItemsDatabase.instance;
    final TransactionDatabase transactionDB = TransactionDatabase.instance;

    final _loggedUser = await UserUtils.instance.loggedUser;
    final String _user = _loggedUser!.shopName;
    log('Logged User ==== $_user');

    final _businessProfile = await UserUtils.instance.businessProfile;
    final String _biller = _businessProfile!.billerName;
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
      paid = PurchaseSideWidget.totalPayableNotifier.value.toString();
    }

    dateTime = DateTime.now().toIso8601String();
    cusomerId = PurchaseSideWidget.supplierIdNotifier.value!;
    customerName = PurchaseSideWidget.supplierNameNotifier.value!;
    billerName = _biller;
    salesNote = 'New Sale';
    totalItems = PurchaseSideWidget.totalItemsNotifier.value.toString();
    vatAmount = PurchaseSideWidget.totalVatNotifier.value.toString();
    subTotal = PurchaseSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    grantTotal = PurchaseSideWidget.totalPayableNotifier.value.toString();
    salesStatus = 'Completed';
    createdBy = _user;

    final SalesModel _salesModel = SalesModel(
        dateTime: dateTime,
        cusomerId: cusomerId,
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
        createdBy: createdBy);

    try {
      //==================== Create Sales ====================
      salesId = await salesDB.createSales(_salesModel);

      final num items = PurchaseSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod =
            PurchaseSideWidget.selectedProductsNotifier.value[i].vatMethod;

        final String productId =
                '${PurchaseSideWidget.selectedProductsNotifier.value[i].id}',
            productType = PurchaseSideWidget
                .selectedProductsNotifier.value[i].productType,
            productCode =
                PurchaseSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName =
                PurchaseSideWidget.selectedProductsNotifier.value[i].itemName,
            category = PurchaseSideWidget
                .selectedProductsNotifier.value[i].itemCategory,
            productCost =
                PurchaseSideWidget.selectedProductsNotifier.value[i].itemCost,
            unitPrice = PurchaseSideWidget
                .selectedProductsNotifier.value[i].sellingPrice,
            netUnitPrice = vatMethod == 'Inclusive'
                ? '${const PurchaseSideWidget().getExclusiveAmount(unitPrice)}'
                : unitPrice,
            quantity = PurchaseSideWidget.quantityNotifier.value[i].text,
            subTotal = PurchaseSideWidget.subTotalNotifier.value[i],
            vatId = PurchaseSideWidget.selectedProductsNotifier.value[i].vatId,
            vatPercentage =
                PurchaseSideWidget.selectedProductsNotifier.value[i].productVAT,
            vatTotal = PurchaseSideWidget.itemTotalVatNotifier.value[i],
            unitCode =
                PurchaseSideWidget.selectedProductsNotifier.value[i].unit;

        log(' Sales Id == $salesId');
        log(' Product id == $productId');
        log(' Product Type == $productType');
        log(' Product Code == $productCode');
        log(' Product Name == $productName');
        log(' Product Category == $category');
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

        final SalesItemsModel _salesItemsModel = SalesItemsModel(
            salesId: salesId,
            productId: productId,
            productType: productType,
            productCode: productCode,
            productName: productName,
            category: category,
            productCost: productCost,
            netUnitPrice: netUnitPrice,
            unitPrice: unitPrice,
            quantity: quantity,
            unitCode: unitCode,
            subTotal: subTotal,
            vatId: vatId,
            vatPercentage: vatPercentage,
            vatTotal: vatTotal);

        //==================== Create Sales Items ====================
        await salesItemDB.createSalesItems(_salesItemsModel);
      }

      final TransactionsModel _transaction = TransactionsModel(
        category: 'Sales',
        transactionType: 'Income',
        dateTime: dateTime,
        amount: grantTotal,
        status: paymentStatus,
        description: 'Transaction $salesId',
        salesId: salesId,
      );

      //==================== Create Transactions ====================
      await transactionDB.createTransaction(_transaction);

      kSnackBar(
        context: context,
        color: kSnackBarSuccessColor,
        icon: const Icon(
          Icons.done,
          color: kSnackBarIconColor,
        ),
        content: "Sale Added Successfully!",
      );
    } catch (e) {
      log('$e');
      kSnackBar(
          context: context,
          content: 'Something went wrong! Please try again later.',
          color: kSnackBarErrorColor,
          icon: const Icon(
            Icons.new_releases_outlined,
            color: kSnackBarIconColor,
          ));
    }
  }
}
