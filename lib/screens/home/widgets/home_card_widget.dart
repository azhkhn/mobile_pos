// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

import '../../../core/constant/colors.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({
    Key? key,
  }) : super(key: key);

  //========== Value Notifiers ==========
  static final ValueNotifier<num> todaySaleNotifier = ValueNotifier(0),
      todayCashNotifier = ValueNotifier(0),
      totalAmountNotifier = ValueNotifier(0);

  static bool detailsCardLoaded = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (!detailsCardLoaded) {
        try {
          final _date = DateTime.now();
          final _today = Converter.dateFormatReverse.format(_date);

          final List<SalesModel> todaySales =
              await SalesDatabase.instance.getTodaySales(_today);
          todaySaleNotifier.value = todaySales.length;

          for (var i = 0; i < todaySales.length; i++) {
            todayCashNotifier.value += num.parse(todaySales[i].grantTotal);
          }
        } catch (e) {
          log(e.toString());
        }

        try {
          final List<SalesModel> salesModel =
              await SalesDatabase.instance.getAllSales();

          for (var i = 0; i < salesModel.length; i++) {
            totalAmountNotifier.value += num.parse(salesModel[i].grantTotal);
          }
        } catch (e) {
          log(e.toString());
        }
      }

      detailsCardLoaded = true;
    });
    final Size _screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _screenSize.width * 0.07,
        vertical: _screenSize.height * 0.01,
      ),
      child: Row(
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
                      style: TextStyle(
                          color: kButtonTextWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ),
                  // kHeight5,
                  ValueListenableBuilder(
                      valueListenable: todaySaleNotifier,
                      builder: (context, num totalSale, _) {
                        return FittedBox(
                          child: Text(
                            '$totalSale',
                            textAlign: TextAlign.center,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: kButtonTextWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }),
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
                  ValueListenableBuilder(
                      valueListenable: todayCashNotifier,
                      builder: (context, num todayCash, _) {
                        return FittedBox(
                          child: Text(
                            Converter.currency.format(todayCash),
                            textAlign: TextAlign.center,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: kButtonTextWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }),
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
                      style: TextStyle(
                          color: kButtonTextWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ),
                  // kHeight5,
                  ValueListenableBuilder(
                      valueListenable: totalAmountNotifier,
                      builder: (context, num totalAmount, _) {
                        return FittedBox(
                          child: Text(
                            Converter.currency.format(totalAmount),
                            textAlign: TextAlign.center,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: kButtonTextWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
