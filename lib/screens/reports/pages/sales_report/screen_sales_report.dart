// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/reports/pages/sales_report/widgets/sales_report_filter.dart';
import 'package:shop_ez/screens/sales/widgets/sales_card_widget.dart';
import 'package:shop_ez/widgets/alertdialog/custom_popup_options.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenSalesReport extends StatelessWidget {
  const ScreenSalesReport({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<SalesModel>> salesNotifier = ValueNotifier([]);

  //========== Lists ==========
  static List<SalesModel> salesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales Report',
        ),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Sales Filter Options ==========
              SalesReportFilter(),

              kHeight5,

              //========== List Sales ==========
              Expanded(
                child: FutureBuilder(
                    future: futureSales(),
                    builder: (context, AsyncSnapshot<List<SalesModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No recent Sales!'));
                          }
                          salesNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: salesNotifier,
                              builder: (context, List<SalesModel> sales, _) {
                                return sales.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: sales.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: SalesCardWidget(
                                              index: index,
                                              sales: sales[index],
                                            ),
                                            onTap: () async {
                                              // final bool payable = sales[index].paymentStatus == 'Partial' || sales[index].paymentStatus == 'Credit';

                                              showDialog(
                                                context: context,
                                                builder: (ctx) => CustomPopupOptions(
                                                  options: [
                                                    //========== View Invoice ==========
                                                    {
                                                      'title': 'View Invoice',
                                                      'color': kBlueGrey400,
                                                      'icon': Icons.receipt_outlined,
                                                      'action': () async {
                                                        await Navigator.pushNamed(
                                                          context,
                                                          routeSalesInvoice,
                                                          arguments: [sales[index], false],
                                                        );
                                                      },
                                                    },
                                                    // //========== Make Payment ==========
                                                    // if (payable)
                                                    //   {
                                                    //     'title': 'Make Payment',
                                                    //     'color': kTeal400,
                                                    //     'icon': Icons.payment_outlined,
                                                    //     'action': () async {
                                                    //       final dynamic updatedSale =
                                                    //           await Navigator.pushNamed(context, routeTransactionSale, arguments: sales[index]);
                                                    //       if (updatedSale != null) {
                                                    //         salesNotifier.value[index] = updatedSale as SalesModel;
                                                    //         salesNotifier.notifyListeners();
                                                    //       }
                                                    //     }
                                                    //   },
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent Sales!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  //== == == == == FutureBuilder Transactions == == == == ==
  Future<List<SalesModel>> futureSales() async {
    log('FutureBuiler()=> called!');
    if (salesList.isEmpty) {
      log('Fetching sales from the Database..');
      salesList = await SalesDatabase.instance.getAllSales();
      return salesList = salesList.reversed.toList();
    } else {
      log('Fetching sales from the List..');
      return salesList;
    }
  }
}
