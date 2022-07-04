// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_card_widget.dart';
import 'package:shop_ez/screens/reports/pages/purchases_report/widgets/purchases_report_filter.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenPurchasesReport extends StatelessWidget {
  const ScreenPurchasesReport({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<PurchaseModel>> purchasesNotifier = ValueNotifier([]);

  //========== Lists ==========
  static List<PurchaseModel> purchasesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Purchases Report',
        ),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Purchases Filter Options ==========
              PurchasesReportFilter(),

              kHeight5,

              //========== List Purchases ==========
              Expanded(
                child: FutureBuilder(
                    future: futurePurchases(),
                    builder: (context, AsyncSnapshot<List<PurchaseModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No recent Purchases!'));
                          }
                          purchasesNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: purchasesNotifier,
                              builder: (context, List<PurchaseModel> purchases, _) {
                                return purchases.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: purchases.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return PurchaseCardWidget(
                                            index: index,
                                            purchases: purchases[index],
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent Purchases!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  //== == == == == FutureBuilder Transactions == == == == ==
  Future<List<PurchaseModel>> futurePurchases() async {
    log('FutureBuiler()=> called!');
    if (purchasesList.isEmpty) {
      log('Fetching purchases from the Database..');
      purchasesList = await PurchaseDatabase.instance.getAllPurchases();
      return purchasesList = purchasesList.reversed.toList();
    } else {
      log('Fetching purchases from the List..');
      return purchasesList;
    }
  }
}
