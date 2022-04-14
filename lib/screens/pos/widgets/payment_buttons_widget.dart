import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
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
        await SalesDatabase.instance.getAllSales();
      } catch (e) {
        log('$e');
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
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text(
                            'Credit Payment!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          content: const Text('Do you want to add this sale?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(ctx),
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
                                    argPaymentStatus: 'Credit',
                                    argPaymentType: '',
                                  );
                                },
                                child: const Text('Accept')),
                          ],
                        );
                      },
                    );
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
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text(
                            'Full Payment!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          content: const Text('Do you want to add this sale?'),
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
                    Navigator.pushNamed(context, routePartialPayment,
                        arguments: {
                          'totalPayable':
                              SaleSideWidget.totalPayableNotifier.value,
                          'totalItems': SaleSideWidget.totalItemsNotifier.value,
                        });
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
  }) async {
    final String dateTime,
        cusomerId,
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

    dateTime = DateTime.now().toIso8601String();
    cusomerId = SaleSideWidget.customerIdNotifier.value.toString();
    customerName = SaleSideWidget.customerNameNotifier.value!;
    billerName = _biller;
    salesNote = 'New Sale';
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
      final SalesDatabase salesDB = SalesDatabase.instance;
      final SalesItemsDatabase salesItemDB = SalesItemsDatabase.instance;

      // await salesDB.createSales(_salesModel);

      final num items = SaleSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        log(' Product id == ${SaleSideWidget.selectedProductsNotifier.value[i].id}');
        log(' Product Type == ${SaleSideWidget.selectedProductsNotifier.value[i].productType}');
        log(' Product Code == ${SaleSideWidget.selectedProductsNotifier.value[i].itemCode}');
        log(' Product Name == ${SaleSideWidget.selectedProductsNotifier.value[i].itemName}');
        log(' Product Category == ${SaleSideWidget.selectedProductsNotifier.value[i].itemCategory}');
        log(' Product Cost == ${SaleSideWidget.selectedProductsNotifier.value[i].itemCost}');
        log(' Unit Price == ${SaleSideWidget.selectedProductsNotifier.value[i].sellingPrice}');
        log(' Product quantity == ${SaleSideWidget.quantityNotifier.value[i].text}');
        log(' Product subTotal == ${SaleSideWidget.subTotalNotifier.value[i]}');
        log(' VAT id == ${SaleSideWidget.selectedProductsNotifier.value[i].vatId}');
        log(' Product Percentage == ${SaleSideWidget.selectedProductsNotifier.value[i].productVAT}');
        log(' VAT Total == ${SaleSideWidget.itemTotalVatNotifier.value[i]}');
        log(' Unit Code == ${SaleSideWidget.selectedProductsNotifier.value[i].unit}');
        if (SaleSideWidget.selectedProductsNotifier.value[i].vatMethod ==
            'Inclusive') {
          final sellingPrice =
              SaleSideWidget.selectedProductsNotifier.value[i].sellingPrice;
          final netUnitPrice =
              const SaleSideWidget().getExclusiveAmount(sellingPrice);

          log(' Net Unit Price == $netUnitPrice');
        } else {
          final netUnitPrice =
              SaleSideWidget.selectedProductsNotifier.value[i].sellingPrice;
          log(' Net Unit Price == $netUnitPrice');
        }

        log('==============================================');
      }

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
    }
  }
}
