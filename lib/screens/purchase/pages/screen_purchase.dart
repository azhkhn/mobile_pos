import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';
import '../../../widgets/container/background_container_widget.dart';
import '../../../widgets/padding_widget/item_screen_padding_widget.dart';
import '../widgets/purchase_options_card.dart';

class ScreenPurchase extends StatelessWidget {
  ScreenPurchase({
    Key? key,
  }) : super(key: key);

  //========== Value Notifiers ==========
  final ValueNotifier<num> totalPurchasesNotifier = ValueNotifier(0),
      totalAmountNotifier = ValueNotifier(0),
      paidAmountNotifier = ValueNotifier(0),
      balanceAmountNotifier = ValueNotifier(0),
      taxAmountNotifier = ValueNotifier(0),
      overDueAmountNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPurchasesDetails();
    });
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Purchase',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: totalPurchasesNotifier,
                                builder: (context, num totalPurchases, _) {
                                  return PurchaseOptionsCard(
                                    title: 'Total Purchases',
                                    value: totalPurchases,
                                    currency: false,
                                  );
                                }),
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: totalAmountNotifier,
                                builder: (context, num totalAmount, _) {
                                  return PurchaseOptionsCard(
                                    title: 'Total Amount',
                                    value: totalAmount,
                                  );
                                }),
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: paidAmountNotifier,
                                builder: (context, num paidAmount, _) {
                                  return PurchaseOptionsCard(
                                    title: 'Paid Amount',
                                    value: paidAmount,
                                  );
                                }),
                          ),
                        ],
                      ),
                      kHeight10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: balanceAmountNotifier,
                                builder: (context, num balanceAmount, _) {
                                  return PurchaseOptionsCard(
                                    title: 'Balance Amount',
                                    value: balanceAmount,
                                  );
                                }),
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: taxAmountNotifier,
                                builder: (context, num taxAmount, _) {
                                  return PurchaseOptionsCard(
                                    title: 'Tax Amount',
                                    value: taxAmount,
                                  );
                                }),
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: overDueAmountNotifier,
                                builder: (context, num overDueAmount, _) {
                                  return PurchaseOptionsCard(
                                    title: 'Over Due Amount',
                                    value: overDueAmount,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              kHeight20,
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () async {
                              await OrientationMode.toLandscape();
                              await Navigator.pushNamed(context, routeAddPurchase);
                              await OrientationMode.toPortrait();
                              await getPurchasesDetails();
                            },
                            color: Colors.green,
                            textColor: kWhite,
                            child: const Text(
                              'Add Purchase',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () async {
                              await OrientationMode.toLandscape();
                              await Navigator.pushNamed(context, routePurchaseReturn);
                              await OrientationMode.toPortrait();
                              await getPurchaseDetails();
                            },
                            color: Colors.indigo[400],
                            textColor: kWhite,
                            child: const Text(
                              'Purchase Return',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    kHeight10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () => Navigator.pushNamed(context, routeListPurchase),
                            color: Colors.deepOrange,
                            textColor: kWhite,
                            child: const Text(
                              'Purchase List',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () {
                              Navigator.pushNamed(context, routePurchaseReturnList);
                            },
                            color: Colors.blueGrey,
                            textColor: kWhite,
                            child: const Text(
                              'Return List',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getPurchasesDetails() async {
    try {
      final List<PurchaseModel> purchaseModel = await PurchaseDatabase.instance.getAllPurchases();

      // Checking if new Purchase added!
      if (totalPurchasesNotifier.value == purchaseModel.length) return;

      totalPurchasesNotifier.value = purchaseModel.length;
      totalAmountNotifier.value = 0;
      paidAmountNotifier.value = 0;
      balanceAmountNotifier.value = 0;
      taxAmountNotifier.value = 0;
      overDueAmountNotifier.value = 0;

      for (var i = 0; i < purchaseModel.length; i++) {
        totalAmountNotifier.value += num.parse(purchaseModel[i].grantTotal);
        paidAmountNotifier.value += num.parse(purchaseModel[i].paid);
        balanceAmountNotifier.value += num.parse(purchaseModel[i].balance);
        taxAmountNotifier.value += num.parse(purchaseModel[i].vatAmount);
        overDueAmountNotifier.value += num.parse(purchaseModel[i].balance);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getPurchaseDetails() async {
    try {
      final List<PurchaseModel> purchaseModel = await PurchaseDatabase.instance.getAllPurchases();

      // Checking if new Purchase added!
      if (totalPurchasesNotifier.value == purchaseModel.length) return;

      totalPurchasesNotifier.value = purchaseModel.length;
      totalAmountNotifier.value = 0;
      paidAmountNotifier.value = 0;
      balanceAmountNotifier.value = 0;
      taxAmountNotifier.value = 0;
      overDueAmountNotifier.value = 0;

      for (var i = 0; i < purchaseModel.length; i++) {
        totalAmountNotifier.value += num.parse(purchaseModel[i].grantTotal);
        paidAmountNotifier.value += num.parse(purchaseModel[i].paid);
        balanceAmountNotifier.value += num.parse(purchaseModel[i].balance);
        taxAmountNotifier.value += num.parse(purchaseModel[i].vatAmount);
        overDueAmountNotifier.value += num.parse(purchaseModel[i].balance);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
