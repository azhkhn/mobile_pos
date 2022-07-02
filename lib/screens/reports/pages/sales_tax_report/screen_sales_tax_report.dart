// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/date_time.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/reports/pages/sales_tax_report/widgets/sales_tax_report_card.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenSalesTaxReport extends StatelessWidget {
  ScreenSalesTaxReport({
    Key? key,
    this.fromDate,
    this.toDate,
    this.from = false,
  }) : super(key: key);

  //==================== DateTime ====================
  DateTime? fromDate, toDate;

  //==================== Bool ====================
  final bool from;

  //========== Value Notifier ==========
  final ValueNotifier<List<SalesModel>> salesNotifier = ValueNotifier([]);

  //========== Lists ==========
  List<SalesModel> salesList = [];

  //==================== TextEditing Controllers ====================
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (fromDate != null || toDate != null) {
        fromDateController.text = Converter.dateFormat.format(fromDate!);
        toDateController.text = Converter.dateFormat.format(toDate!);
      }
    });

    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales Tax Report',
        ),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //======================================================================
              //==================== From Date and To Date Filter Fields =============
              //======================================================================
              Row(
                children: [
                  //==================== From Date Field ====================
                  Flexible(
                    flex: 1,
                    child: TextFeildWidget(
                      hintText: 'From Date ',
                      controller: fromDateController,
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      suffixIcon: Padding(
                        padding: kClearTextIconPadding,
                        child: InkWell(
                          child: const Icon(Icons.clear, size: 15),
                          onTap: () async {
                            fromDateController.clear();
                            fromDate = null;
                            salesNotifier.value = await futureSales();
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: kText12,
                      readOnly: true,
                      isDense: true,
                      textStyle: kText12,
                      inputBorder: const OutlineInputBorder(),
                      onTap: () async {
                        final _selectedDate = await DateTimeUtils.instance.datePicker(context, initDate: fromDate);
                        if (_selectedDate != null) {
                          final parseDate = Converter.dateFormat.format(_selectedDate);
                          fromDateController.text = parseDate.toString();
                          fromDate = _selectedDate;
                          salesNotifier.value = await futureSales();
                        }
                      },
                    ),
                  ),

                  kWidth5,
                  //==================== To Date Field ====================
                  Flexible(
                    flex: 1,
                    child: TextFeildWidget(
                      hintText: 'To Date ',
                      controller: toDateController,
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      suffixIcon: Padding(
                        padding: kClearTextIconPadding,
                        child: InkWell(
                          child: const Icon(Icons.clear, size: 15),
                          onTap: () async {
                            toDateController.clear();
                            toDate = null;
                            salesNotifier.value = await futureSales();
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: kText12,
                      readOnly: true,
                      isDense: true,
                      textStyle: kText12,
                      inputBorder: const OutlineInputBorder(),
                      onTap: () async {
                        final _selectedDate = await DateTimeUtils.instance.datePicker(context, initDate: toDate, endDate: true);
                        if (_selectedDate != null) {
                          final parseDate = Converter.dateFormat.format(_selectedDate);
                          toDateController.text = parseDate.toString();
                          toDate = _selectedDate;
                          salesNotifier.value = await futureSales();
                        }
                      },
                    ),
                  )
                ],
              ),

              kHeight5,

              //========== List Sales Tax Report ==========
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
                                            child: SalesTaxCardWidget(
                                              index: index,
                                              sales: sales[index],
                                            ),
                                            onTap: () async {
                                              await Navigator.pushNamed(context, routeSalesInvoice, arguments: [sales[index], false]);
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

  //== == == == == FutureBuilder Sales Tax Report == == == == ==
  Future<List<SalesModel>> futureSales() async {
    log('FutureBuiler()=> called!');
    if (salesList.isEmpty) salesList = await SalesDatabase.instance.getAllSales();

    final List<SalesModel> sales = [];

    if (fromDate != null || toDate != null) {
      final _fromDate = fromDate;
      final _toDate = toDate;
      if (_fromDate != null && _toDate != null) {
        log('From Date = ' + Converter.dateTimeFormatAmPm.format(_fromDate));
        log('To Date = ' + Converter.dateTimeFormatAmPm.format(_toDate));
      }

      //Sales Tax Summary ~ Filter
      for (SalesModel sale in salesList) {
        final DateTime _date = DateTime.parse(sale.dateTime);

        // if fromDate and toDate is selected
        if (_fromDate != null && _toDate != null) {
          log('Sold Date = ' + Converter.dateTimeFormatAmPm.format(_date));

          if (_fromDate.isAtSameMomentAs(_toDate)) {
            if (Converter.isSameDate(_fromDate, _date)) {
              sales.add(sale);
            }
          } else if (_date.isAfter(_fromDate) && _date.isBefore(_toDate)) {
            sales.add(sale);
          }
        }

        // if only fromDate is selected
        else if (_fromDate != null) {
          if (_date.isAfter(_fromDate)) sales.add(sale);
        }

        // if only toDate is selected
        else if (_toDate != null) {
          if (_date.isBefore(_toDate)) sales.add(sale);
        }
      }

      return sales.reversed.toList();
    } else {
      return salesList.reversed.toList();
    }
  }
}
