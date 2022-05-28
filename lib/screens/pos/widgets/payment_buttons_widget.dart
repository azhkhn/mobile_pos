import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/alertdialog/custom_alert.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/home/widgets/home_card_widget.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/payment_type_widget.dart';
import 'package:shop_ez/screens/pos/widgets/product_side_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/converters/converters.dart';

class PaymentButtonsWidget extends StatelessWidget {
  const PaymentButtonsWidget({
    Key? key,
    this.isVertical = false,
  }) : super(key: key);

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
          height: isVertical ? _screenSize.height / 26 : _screenSize.width / 25,
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
                  valueListenable: SaleSideWidget.totalPayableNotifier,
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
                    final int? customerId = SaleSideWidget.customerIdNotifier.value;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Customer to add sale!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add sale!');
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Credit Payment',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            content: const Text('Do you want to add this sale?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    final String _balance = SaleSideWidget.totalPayableNotifier.value.toString();
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
                    child: Text(
                      'Credit Payment',
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
                    final int? customerId = SaleSideWidget.customerIdNotifier.value;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Customer to add sale!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add sale!');
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Full Payment',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            content: const Text('Do you want to add this sale?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
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
                    child: Text(
                      'Full Payment',
                      style: kItemsButtontyle,
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
                height: isVertical ? _screenSize.height / 22 : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    final items = SaleSideWidget.selectedProductsNotifier.value;
                    if (items.isEmpty) {
                      SaleSideWidget.selectedProductsNotifier.value.clear();
                      SaleSideWidget.subTotalNotifier.value.clear();
                      SaleSideWidget.itemTotalVatNotifier.value.clear();
                      SaleSideWidget.customerController.clear();
                      SaleSideWidget.quantityNotifier.value.clear();
                      SaleSideWidget.unitPriceNotifier.value.clear();
                      SaleSideWidget.totalItemsNotifier.value = 0;
                      SaleSideWidget.totalQuantityNotifier.value = 0;
                      SaleSideWidget.totalAmountNotifier.value = 0;
                      SaleSideWidget.totalVatNotifier.value = 0;
                      SaleSideWidget.totalPayableNotifier.value = 0;
                      SaleSideWidget.customerIdNotifier.value = null;
                      SaleSideWidget.customerNameNotifier.value = null;
                      ProductSideWidget.itemsNotifier.value.clear();
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return KAlertDialog(
                              content: const Text('Are you sure want to cancel the sale?'),
                              submitAction: () {
                                Navigator.pop(context);
                                SaleSideWidget.selectedProductsNotifier.value.clear();
                                SaleSideWidget.subTotalNotifier.value.clear();
                                SaleSideWidget.itemTotalVatNotifier.value.clear();
                                SaleSideWidget.customerController.clear();
                                SaleSideWidget.quantityNotifier.value.clear();
                                SaleSideWidget.unitPriceNotifier.value.clear();
                                SaleSideWidget.totalItemsNotifier.value = 0;
                                SaleSideWidget.totalQuantityNotifier.value = 0;
                                SaleSideWidget.totalAmountNotifier.value = 0;
                                SaleSideWidget.totalVatNotifier.value = 0;
                                SaleSideWidget.totalPayableNotifier.value = 0;
                                SaleSideWidget.customerIdNotifier.value = null;
                                SaleSideWidget.customerNameNotifier.value = null;
                                ProductSideWidget.itemsNotifier.value.clear();
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
                  onPressed: () {
                    final int? customerId = SaleSideWidget.customerIdNotifier.value;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Customer to add Sale!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add Sale!');
                    } else {
                      Navigator.pushNamed(context, routePartialPayment, arguments: {
                        'totalPayable': SaleSideWidget.totalPayableNotifier.value,
                        'totalItems': SaleSideWidget.totalItemsNotifier.value,
                        'isVertical': isVertical
                      });
                    }
                  },
                  padding: const EdgeInsets.all(5),
                  color: Colors.lightGreen[700],
                  child: Center(
                    child: Text(
                      'Partial Payment',
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
    int customerId;
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
    final UserModel _loggedUser;
    late final String _user;
    final BusinessProfileModel _businessProfile;
    late final String _biller;
    try {
      _loggedUser = await UserUtils.instance.loggedUser;
      _user = _loggedUser.shopName;
      log('Logged User ==== $_user');

      _businessProfile = await UserUtils.instance.businessProfile;
      _biller = _businessProfile.billerName;
      log('Biller Name ==== $_biller');
    } catch (e) {
      kSnackBar(context: context, content: 'Business Profile is empty! Please fill your profile', error: true);
      return log(e.toString());
    }

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
    customerId = SaleSideWidget.customerIdNotifier.value!;
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
        createdBy: createdBy);

    try {
      //==================== Create Sales ====================
      salesId = await salesDB.createSales(_salesModel);

      final num items = SaleSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod = SaleSideWidget.selectedProductsNotifier.value[i].vatMethod;

        final int categoryId = SaleSideWidget.selectedProductsNotifier.value[i].itemCategoryId,
            productId = SaleSideWidget.selectedProductsNotifier.value[i].id!,
            vatId = SaleSideWidget.selectedProductsNotifier.value[i].vatId;

        final String productType = SaleSideWidget.selectedProductsNotifier.value[i].productType,
            productCode = SaleSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName = SaleSideWidget.selectedProductsNotifier.value[i].itemName,
            productCost = SaleSideWidget.selectedProductsNotifier.value[i].itemCost,
            unitPrice = SaleSideWidget.selectedProductsNotifier.value[i].sellingPrice,
            netUnitPrice = vatMethod == 'Inclusive'
                ? '${const SaleSideWidget().getExclusiveAmount(sellingPrice: unitPrice, vatRate: SaleSideWidget.selectedProductsNotifier.value[i].vatRate)}'
                : unitPrice,
            quantity = SaleSideWidget.quantityNotifier.value[i].text,
            subTotal = SaleSideWidget.subTotalNotifier.value[i],
            vatPercentage = SaleSideWidget.selectedProductsNotifier.value[i].productVAT,
            vatTotal = SaleSideWidget.itemTotalVatNotifier.value[i],
            unitCode = SaleSideWidget.selectedProductsNotifier.value[i].unit;

        final vat = await VatDatabase.instance.getVatById(vatId);
        final vatRate = vat.rate;

        log(' Sales Id == $salesId');
        log(' Product id == $productId');
        log(' Product Type == $productType');
        log(' Product Code == $productCode');
        log(' Product Name == $productName');
        log(' Product Category id == $categoryId');
        log(' Product Cost == $productCost');
        log(' Net Unit Price == $netUnitPrice');
        log(' Unit Price == $unitPrice');
        log(' Product quantity == $quantity');
        log(' Unit Code == $unitCode');
        log(' Product subTotal == $subTotal');
        log(' VAT id == $vatId');
        log(' VAT Percentage == $vatPercentage');
        log(' VAT Total == $vatTotal');
        log('==============================================');

        final SalesItemsModel _salesItemsModel = SalesItemsModel(
          saleId: salesId,
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
          vatPercentage: vatPercentage,
          vatRate: vatRate,
          vatTotal: vatTotal,
        );

        //==================== Create Sales Items ====================
        await salesItemDB.createSalesItems(_salesItemsModel);

        //==================== Decreasing Item Quantity ====================
        itemMasterDB.subtractItemQty(itemId: SaleSideWidget.selectedProductsNotifier.value[i].id!, soldQty: num.parse(quantity));
        log('==============================================');
      }

      if (paymentStatus != 'Due') {
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
      }

      PaymentTypeWidget.amountController.clear();

      HomeCardWidget.detailsCardLoaded = false;

      ProductSideWidget.itemsNotifier.value = await ItemMasterDatabase.instance.getAllItems();

      const SaleSideWidget().resetPos();

      kSnackBar(
        context: context,
        success: true,
        content: "Sale has been added successfully!",
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
