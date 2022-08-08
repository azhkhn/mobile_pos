import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/home/widgets/home_card_widget.dart';
import 'package:shop_ez/screens/pos/widgets/product_side_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/utils/converters/converters.dart';

class PaymentButtonsWidget extends ConsumerWidget {
  const PaymentButtonsWidget({
    Key? key,
    this.isVertical = false,
  }) : super(key: key);

  final bool isVertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size _screenSize = MediaQuery.of(context).size;
    final bool isSmall = DeviceUtil.isSmall;

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
                    valueListenable: SaleSideWidget.totalPayableNotifier,
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
                    final int? customerId = SaleSideWidget.customerNotifier.value?.id;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Customer to add sale!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add sale!');
                    } else {
                      final _quantities = SaleSideWidget.quantityNotifier.value;
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
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      final String _balance = SaleSideWidget.totalPayableNotifier.value.toString();

                                      //========== Adding Sale ==========
                                      final SalesModel? salesModel = await addSale(
                                        context,
                                        ref,
                                        argPaid: '0',
                                        argBalance: _balance,
                                        argPaymentStatus: 'Credit',
                                        argPaymentType: '',
                                      );

                                      if (salesModel != null) {
                                        await OrientationMode.toPortrait();
                                        await Navigator.pushNamed(
                                          context,
                                          routeSalesInvoice,
                                          arguments: [salesModel, false],
                                        );
                                        await OrientationMode.toLandscape();
                                      }
                                    },
                                    child: const Text('Accept')),
                              ],
                            );
                          },
                        );
                      } else {
                        kSnackBar(context: context, content: 'Please enter valid item quantity', error: true);
                      }
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
                height: isVertical
                    ? isSmall
                        ? 33
                        : 40
                    : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    final int? customerId = SaleSideWidget.customerNotifier.value?.id;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Customer to add sale!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add sale!');
                    } else {
                      final _quantities = SaleSideWidget.quantityNotifier.value;
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
                                    onPressed: () async {
                                      Navigator.pop(ctx);
                                      final SalesModel? salesModel = await addSale(context, ref);
                                      if (salesModel != null) {
                                        await OrientationMode.toPortrait();
                                        await Navigator.pushNamed(
                                          context,
                                          routeSalesInvoice,
                                          arguments: [salesModel, false],
                                        );
                                        await OrientationMode.toLandscape();
                                      }
                                    },
                                    child: const Text('Accept')),
                              ],
                            );
                          },
                        );
                      } else {
                        kSnackBar(context: context, content: 'Please enter valid item quantity', error: true);
                      }
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
                height: isVertical
                    ? isSmall
                        ? 33
                        : 40
                    : _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {
                    final items = SaleSideWidget.selectedProductsNotifier.value;
                    if (items.isEmpty) {
                      const SaleSideWidget().resetPos();
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return KAlertDialog(
                              content: const Text('Are you sure want to cancel the sale?'),
                              submitAction: () {
                                Navigator.pop(context);
                                const SaleSideWidget().resetPos();
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
                    final int? customerId = SaleSideWidget.customerNotifier.value?.id;
                    final num items = SaleSideWidget.totalItemsNotifier.value;

                    if (customerId == null) {
                      kSnackBar(context: context, content: 'Please select any Customer to add Sale!');
                    } else if (items == 0) {
                      return kSnackBar(context: context, content: 'Please select any Products to add Sale!');
                    } else {
                      final _quantities = SaleSideWidget.quantityNotifier.value;
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
                        final salesModel = await Navigator.pushNamed(context, routePartialPayment, arguments: {
                          'totalPayable': SaleSideWidget.totalPayableNotifier.value,
                          'totalItems': SaleSideWidget.totalItemsNotifier.value,
                          'isVertical': isVertical
                        });

                        if (salesModel is SalesModel) {
                          await OrientationMode.toPortrait();
                          await Navigator.pushNamed(
                            context,
                            routeSalesInvoice,
                            arguments: [salesModel, false],
                          );
                          await OrientationMode.toLandscape();
                        }
                      } else {
                        kSnackBar(context: context, content: 'Please enter valid item quantity', error: true);
                      }
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
  Future<SalesModel?> addSale(
    BuildContext context,
    WidgetRef ref, {
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
      log(e.toString());
      return null;
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
    customerId = SaleSideWidget.customerNotifier.value!.id!;
    customerName = SaleSideWidget.customerNotifier.value!.customer;
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
      final _newSale = await salesDB.createSales(_salesModel);
      salesId = _newSale.id!;

      final num items = SaleSideWidget.totalItemsNotifier.value;
      for (var i = 0; i < items; i++) {
        final vatMethod = SaleSideWidget.selectedProductsNotifier.value[i].vatMethod;

        final int categoryId = SaleSideWidget.selectedProductsNotifier.value[i].itemCategoryId,
            productId = SaleSideWidget.selectedProductsNotifier.value[i].id!,
            vatId = SaleSideWidget.selectedProductsNotifier.value[i].vatId;

        final String productType = SaleSideWidget.selectedProductsNotifier.value[i].productType,
            productCode = SaleSideWidget.selectedProductsNotifier.value[i].itemCode,
            productName = SaleSideWidget.selectedProductsNotifier.value[i].itemName,
            productNameArabic = SaleSideWidget.selectedProductsNotifier.value[i].itemNameArabic,
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
        log(' Product Name Arabic == $productNameArabic');
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
          vatPercentage: vatPercentage,
          vatRate: vatRate,
          vatTotal: vatTotal,
        );

        //==================== Create Sales Items ====================
        await salesItemDB.createSalesItems(_salesItemsModel);

        //==================== Decreasing Item Quantity ====================
        await itemMasterDB.subtractItemQty(itemId: SaleSideWidget.selectedProductsNotifier.value[i].id!, soldQty: num.parse(quantity));
        log('==============================================');
      }

      if (paymentStatus != 'Credit') {
        final TransactionsModel _transaction = TransactionsModel(
          category: 'Sales',
          transactionType: 'Income',
          dateTime: dateTime,
          amount: paid,
          status: paymentStatus,
          description: 'Transaction $salesId',
          salesId: salesId,
          customerId: customerId,
        );

        //==================== Create Transactions ====================
        await transactionDB.createTransaction(_transaction);
      }

      ref.refresh(HomeCardWidget.homeCardProvider);

      const SaleSideWidget().resetPos(notify: true);

      ProductSideWidget.itemsNotifier.value = await ItemMasterDatabase.instance.getAllItems();
      ProductSideWidget.stableItemsNotifier.value = ProductSideWidget.itemsNotifier.value as List<ItemMasterModel>;

      kSnackBar(
        context: context,
        success: true,
        content: "Sale has been added successfully!",
      );

      return _newSale;
    } catch (e) {
      log('$e');
      kSnackBar(
        context: context,
        content: 'Something went wrong! Please try again later.',
        error: true,
      );

      return null;
    }
  }
}
