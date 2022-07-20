import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/route_generator.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/cash_register/cash_register_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

import '../../../core/constant/sizes.dart';
import '../widgets/sales_options_card.dart';

class ScreenSales extends StatelessWidget {
  ScreenSales({
    Key? key,
  }) : super(key: key);

  //========== Value Notifiers ==========
  final ValueNotifier<num> totalSalesNotifier = ValueNotifier(0),
      totalAmountNotifier = ValueNotifier(0),
      paidAmountNotifier = ValueNotifier(0),
      balanceAmountNotifier = ValueNotifier(0),
      taxAmountNotifier = ValueNotifier(0),
      overDueAmountNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getSalesDetails(sale: true);
      final List<TransactionsModel> _transaction = await TransactionDatabase.instance.getAllTransactions();
      num totalExpense = 0;
      num totalIncome = 0;
      for (var transaction in _transaction) {
        if (transaction.transactionType == 'Income') {
          totalIncome += num.parse(transaction.amount);
        } else {
          totalExpense += num.parse(transaction.amount);
        }
      }
      log('Total Income == $totalIncome');
      log('Total Expense == $totalExpense');
      log('In the Money == ${totalIncome - totalExpense}');
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Sales',
        actions: [
          IconButton(
            onPressed: () {
              final CashRegisterModel? _cashModel = UserUtils.instance.cashRegisterModel;
              if (_cashModel == null || _cashModel.action == 'close') {
                log('message');

                Navigator.push(context, RouteGenerator.cashRegister());
              } else {
                Navigator.pushNamed(context, routeCashRegister);
              }
            },
            icon: const Icon(Icons.point_of_sale),
          )
        ],
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: totalSalesNotifier,
                            builder: (context, num totalSales, _) {
                              return SalesOptionsCard(
                                title: 'Total Sales',
                                value: totalSales,
                                currency: false,
                              );
                            }),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: totalAmountNotifier,
                            builder: (context, num totalAmount, _) {
                              return SalesOptionsCard(
                                title: 'Total Amount',
                                value: totalAmount,
                              );
                            }),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: paidAmountNotifier,
                            builder: (context, num paidAmount, _) {
                              return SalesOptionsCard(
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
                              return SalesOptionsCard(
                                title: 'Balance Amount',
                                value: balanceAmount,
                              );
                            }),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: taxAmountNotifier,
                            builder: (context, num taxAmount, _) {
                              return SalesOptionsCard(
                                title: 'Tax Amount',
                                value: taxAmount,
                              );
                            }),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: overDueAmountNotifier,
                            builder: (context, num overDueAmount, _) {
                              return SalesOptionsCard(
                                title: 'Over Due Amount',
                                value: overDueAmount,
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              kHeight20,
              Expanded(
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
                              await Navigator.pushNamed(context, routePos);
                              await OrientationMode.toPortrait();
                              await getSalesDetails(sale: true);
                            },
                            color: Colors.green,
                            textColor: kWhite,
                            child: const Text(
                              'Add Sale',
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
                              await Navigator.pushNamed(context, routeSalesReturn);
                              await OrientationMode.toPortrait();
                              await getSalesDetails();
                            },
                            color: Colors.indigo[400],
                            textColor: kWhite,
                            child: const Text(
                              'Credit Note',
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
                            onPressed: () async {
                              await Navigator.pushNamed(context, routeSalesList);
                              await getSalesDetails();
                            },
                            color: Colors.deepOrange,
                            textColor: kWhite,
                            child: const Text(
                              'Sales List',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () {
                              Navigator.pushNamed(context, routeSalesReturnList);
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

  Future<void> getSalesDetails({bool sale = false}) async {
    try {
      final List<SalesModel> salesModel = await SalesDatabase.instance.getAllSales();

      // Checking if new Sale added!
      if (sale) {
        if (totalSalesNotifier.value == salesModel.length) return;
      }

      totalSalesNotifier.value = salesModel.length;
      totalAmountNotifier.value = 0;
      paidAmountNotifier.value = 0;
      balanceAmountNotifier.value = 0;
      taxAmountNotifier.value = 0;
      overDueAmountNotifier.value = 0;

      for (var i = 0; i < salesModel.length; i++) {
        totalAmountNotifier.value += num.parse(salesModel[i].grantTotal);
        paidAmountNotifier.value += num.parse(salesModel[i].paid);
        balanceAmountNotifier.value += num.parse(salesModel[i].balance);
        taxAmountNotifier.value += num.parse(salesModel[i].vatAmount);
        overDueAmountNotifier.value += num.parse(salesModel[i].balance);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
