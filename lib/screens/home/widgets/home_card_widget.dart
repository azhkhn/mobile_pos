import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';

import '../../../core/constant/colors.dart';

class HomeCardWidget extends ConsumerWidget {
  const HomeCardWidget({
    Key? key,
  }) : super(key: key);

  static final homeCardProvider = FutureProvider<List<num>>((ref) async {
    log('Updating Sales Card..');
    final List<TransactionsModel> salesTransactions = await TransactionDatabase.instance.getAllSalesTransactions();
    num _todaySale = 0;
    num _todaysCash = 0;
    num _totalCash = 0;

    final List<SalesModel> _todaySales = await SalesDatabase.instance.getSalesByDay(DateTime.now());

    final List<TransactionsModel> _todaysTransactions = salesTransactions.where((transaction) {
      final DateTime soldDate = DateTime.parse(transaction.dateTime);
      return Converter.isSameDate(DateTime.now(), soldDate);
    }).toList();

    _todaySale = _todaySales.length;

    for (TransactionsModel sale in _todaysTransactions) {
      if (sale.paymentMethod == 'Cash') _todaysCash += num.parse(sale.amount);
    }

    for (TransactionsModel sale in salesTransactions) {
      if (sale.paymentMethod == 'Cash') _totalCash += num.parse(sale.amount);
    }

    return [_todaySale, _todaysCash, _totalCash];
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _future = ref.watch(homeCardProvider);

    return FractionallySizedBox(
        widthFactor: .93,
        alignment: Alignment.center,
        child: _future.when(
          data: (_salesDetails) {
            log('${'Todays Sale == ${_salesDetails[0]}'} | ${'Todays Cash == ${_salesDetails[1]}'} | ${'Total Cash == ${_salesDetails[2]}'}');

            final num _todaySale = _salesDetails[0];
            final num _todayCash = _salesDetails[1];
            final num _totalCash = _salesDetails[2];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Card(
                    elevation: 5,
                    color: kRed300,
                    child: Padding(
                      padding: kPadding2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FittedBox(
                            child: Text(
                              "Today's Sale",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: kButtonTextWhite, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                          // kHeight5,
                          FittedBox(
                            child: Text(
                              '$_todaySale',
                              textAlign: TextAlign.center,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: kButtonTextWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 5,
                    color: Colors.blue[300],
                    child: Padding(
                      padding: kPadding2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FittedBox(
                            child: Text(
                              "Today's Cash",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kButtonTextWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              Converter.currency.format(_todayCash),
                              textAlign: TextAlign.center,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: kButtonTextWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 5,
                    color: kGreen300,
                    child: Padding(
                      padding: kPadding2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FittedBox(
                            child: Text(
                              'Total Cash',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: kButtonTextWhite, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                          // kHeight5,
                          FittedBox(
                            child: Text(
                              Converter.currency.format(_totalCash),
                              textAlign: TextAlign.center,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: kButtonTextWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (_, __) => null,
          loading: () => null,
        ));
  }
}
