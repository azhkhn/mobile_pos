import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

import '../../../core/constant/colors.dart';

class HomeCardWidget extends ConsumerWidget {
  const HomeCardWidget({
    Key? key,
  }) : super(key: key);

  static final homeCardProvider = FutureProvider<List<num>>((ref) async {
    log('Updating Sales Card..');
    // final List<SalesModel> _todaySales = await SalesDatabase.instance.getSalesByDay(DateTime.now());
    final List<SalesModel> sales = await SalesDatabase.instance.getAllSales();

    final List<SalesModel> _todaySales = sales.where((sale) {
      final DateTime soldDate = DateTime.parse(sale.dateTime);
      return Converter.isSameDate(DateTime.now(), soldDate);
    }).toList();

    num _todaysCash = 0;
    for (var i = 0; i < _todaySales.length; i++) {
      _todaysCash += num.parse(_todaySales[i].grantTotal);
    }

    num _totalCash = 0;
    for (var i = 0; i < sales.length; i++) {
      _totalCash += num.parse(sales[i].grantTotal);
    }

    return [_todaySales.length, _todaysCash, _totalCash];
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _future = ref.watch(homeCardProvider);

    final Size _screenSize = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _screenSize.width * 0.07,
          vertical: _screenSize.height * 0.01,
        ),
        child: _future.when(
          data: (_salesDetails) {
            final num _todaySale = _salesDetails[0];
            final num _todayCash = _salesDetails[1];
            final num _totalCash = _salesDetails[2];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 5,
                  color: Colors.red[300],
                  child: SizedBox(
                    width: _screenSize.width / 4,
                    height: _screenSize.width / 12,
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
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  color: Colors.blue[300],
                  child: SizedBox(
                    width: _screenSize.width / 4,
                    height: _screenSize.width / 12,
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
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  color: Colors.green[300],
                  child: SizedBox(
                    width: _screenSize.width / 4,
                    height: _screenSize.width / 12,
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
                              fontSize: 11,
                            ),
                          ),
                        )
                      ],
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
