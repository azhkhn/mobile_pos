import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/home/widgets/home_card_widget.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/payment_type_widget.dart';
import 'package:shop_ez/screens/pos/widgets/product_side_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/text/converters.dart';

class PaymentButtonsWidget extends StatelessWidget {
  const PaymentButtonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = DeviceUtil.isTablet;
    Size _screenSize = MediaQuery.of(context).size;

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      try {
        // await SalesDatabase.instance.getAllSales();
        // await SalesItemsDatabase.instance.getAllSalesItems();
        // await TransactionDatabase.instance.getAllTransactions();
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
                  valueListenable: SaleSideWidget.totalPayableNotifier,
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
                  onPressed: () {
                    final int? cusomerId =
                        SaleSideWidget.customerIdNotifier.value;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (cusomerId == null) {
                      kSnackBar(
                          context: context,
                          content: 'Please select any Customer to add Sale!');
                    } else if (items == 0) {
                      return kSnackBar(
                          context: context,
                          content: 'Please select any Products to add Sale!');
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Credit Payment!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            content:
                                const Text('Do you want to add this sale?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    final String _balance = SaleSideWidget
                                        .totalPayableNotifier.value
                                        .toString();
                                    addSale(
                                      context,
                                      argPaid: '0',
                                      argBalance: _balance,
                                      argPaymentStatus: 'Due',
                                      argPaymentType: '',
                                    );
                                  },
                                  child: const Text('Accept')),
                            ],
                          );
                        },
                      );
                    }
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.yellow[800],
                  child: Center(
                    child: AutoSizeText(
                      'Credit Payment',
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
                        SaleSideWidget.customerIdNotifier.value;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (cusomerId == null) {
                      kSnackBar(
                          context: context,
                          content: 'Please select any Customer to add Sale!');
                    } else if (items == 0) {
                      return kSnackBar(
                          context: context,
                          content: 'Please select any Products to add Sale!');
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Full Payment!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            content:
                                const Text('Do you want to add this sale?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    addSale(context);
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
                      'Full Payment',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    SaleSideWidget.selectedProductsNotifier.value.clear();
                    SaleSideWidget.subTotalNotifier.value.clear();
                    SaleSideWidget.itemTotalVatNotifier.value.clear();
                    SaleSideWidget.customerController.clear();
                    SaleSideWidget.quantityNotifier.value.clear();
                    SaleSideWidget.totalItemsNotifier.value = 0;
                    SaleSideWidget.totalQuantityNotifier.value = 0;
                    SaleSideWidget.totalAmountNotifier.value = 0;
                    SaleSideWidget.totalVatNotifier.value = 0;
                    SaleSideWidget.totalPayableNotifier.value = 0;
                    SaleSideWidget.customerIdNotifier.value = null;
                    SaleSideWidget.customerNameNotifier.value = null;
                    Navigator.pop(context);
                  },
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
                        SaleSideWidget.customerIdNotifier.value;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (cusomerId == null) {
                      kSnackBar(
                          context: context,
                          content: 'Please select any Customer to add Sale!');
                    } else if (items == 0) {
                      return kSnackBar(
                          context: context,
                          content: 'Please select any Products to add Sale!');
                    } else {
                      Navigator.pushNamed(context, routePartialPayment,
                          arguments: {
                            'totalPayable':
                                SaleSideWidget.totalPayableNotifier.value,
                            'totalItems':
                                SaleSideWidget.totalItemsNotifier.value,
                          });
                    }
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.lightGreen[700],
                  child: Center(
                    child: AutoSizeText(
                      'Partial Payment',
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
    String? argSalesNote,
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

    //==================== Database Instances ====================
    final SalesDatabase salesDB = SalesDatabase.instance;
    final SalesItemsDatabase salesItemDB = SalesItemsDatabase.instance;
    final TransactionDatabase transactionDB = TransactionDatabase.instance;
    final ItemMasterDatabase itemMasterDB = ItemMasterDatabase.instance;

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
      paid = SaleSideWidget.totalPayableNotifier.value.toString();
    }

    // Save sale in a old date in Database
    // dateTime = DateTime(2022, 4, 22, 17, 45).toIso8601String();
    dateTime = DateTime.now().toIso8601String();
    cusomerId = SaleSideWidget.customerIdNotifier.value!;
    customerName = SaleSideWidget.customerNameNotifier.value!;
    billerName = _biller;
    salesNote = argSalesNote ?? '';
    totalItems = SaleSideWidget.totalItemsNotifier.value.toString();
    vatAmount = SaleSideWidget.totalVatNotifier.value.toString();
    subTotal = SaleSideWidget.totalAmountNotifier.value.toString();
    discount = '';
    grantTotal = SaleSideWidget.totalPayableNotifier.value.toString();
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

      final num items = SaleSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod =
            SaleSideWidget.selectedProductsNotifier.value[i].vatMethod;

        final String productId =
                '${SaleSideWidget.selectedProductsNotifier.value[i].id}',
            productType =
                SaleSideWidget.selectedProductsNotifier.value[i].productType,
            productCode =
                SaleSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName =
                SaleSideWidget.selectedProductsNotifier.value[i].itemName,
            category =
                SaleSideWidget.selectedProductsNotifier.value[i].itemCategory,
            productCost =
                SaleSideWidget.selectedProductsNotifier.value[i].itemCost,
            unitPrice =
                SaleSideWidget.selectedProductsNotifier.value[i].sellingPrice,
            netUnitPrice = vatMethod == 'Inclusive'
                ? '${const SaleSideWidget().getExclusiveAmount(unitPrice)}'
                : unitPrice,
            quantity = SaleSideWidget.quantityNotifier.value[i].text,
            subTotal = SaleSideWidget.subTotalNotifier.value[i],
            vatId = SaleSideWidget.selectedProductsNotifier.value[i].vatId,
            vatPercentage =
                SaleSideWidget.selectedProductsNotifier.value[i].productVAT,
            vatTotal = SaleSideWidget.itemTotalVatNotifier.value[i],
            unitCode = SaleSideWidget.selectedProductsNotifier.value[i].unit;

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

        //==================== Decreasing Item Quantity ====================
        itemMasterDB.subtractItemQty(
            SaleSideWidget.selectedProductsNotifier.value[i],
            num.parse(quantity));
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

      PaymentTypeWidget.amountController.clear();

      HomeCardWidget.detailsCardLoaded = false;

      ProductSideWidget.itemsNotifier.value =
          await ItemMasterDatabase.instance.getAllItems();

      kSnackBar(
        context: context,
        success: true,
        content: "Sale Added Successfully!",
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
