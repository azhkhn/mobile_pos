// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/device/date_time.dart';
import 'package:mobile_pos/db/db_functions/purchase/purchase_database.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';
import 'package:mobile_pos/screens/reports/pages/purchases_tax_report/widgets/purchase_tax_report_card.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenPurchasesTaxReport extends StatelessWidget {
  ScreenPurchasesTaxReport({
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
  final ValueNotifier<List<PurchaseModel>> purchasesNotifier = ValueNotifier([]);

  //========== Lists ==========
  List<PurchaseModel> purchasesList = [];

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
          title: 'Purchases Tax Report',
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
                            purchasesNotifier.value = await futurePurchases();
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
                          purchasesNotifier.value = await futurePurchases();
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
                            purchasesNotifier.value = await futurePurchases();
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
                          purchasesNotifier.value = await futurePurchases();
                        }
                      },
                    ),
                  )
                ],
              ),

              kHeight5,

              //========== List Purchases Tax Report ==========
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
                            return const Center(child: Text('No recent purchases'));
                          }
                          purchasesNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: purchasesNotifier,
                              builder: (context, List<PurchaseModel> purchases, _) {
                                return purchases.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: purchases.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return PurchaseTaxCardWidget(
                                            index: index,
                                            purchase: purchases[index],
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent purchases'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  //== == == == == FutureBuilder Purchases Tax Report == == == == ==
  Future<List<PurchaseModel>> futurePurchases() async {
    log('FutureBuiler()=> called!');
    if (purchasesList.isEmpty) purchasesList = await PurchaseDatabase.instance.getAllPurchases();

    final List<PurchaseModel> purchases = [];

    if (fromDate != null || toDate != null) {
      final _fromDate = fromDate;
      final _toDate = toDate;
      if (_fromDate != null && _toDate != null) {
        log('From Date = ' + Converter.dateTimeFormatAmPm.format(_fromDate));
        log('To Date = ' + Converter.dateTimeFormatAmPm.format(_toDate));
      }

      //Purchase Tax Summary ~ Filter
      for (PurchaseModel purchase in purchasesList) {
        final DateTime _date = DateTime.parse(purchase.dateTime);

        // if fromDate and toDate is selected
        if (_fromDate != null && _toDate != null) {
          log('Sold Date = ' + Converter.dateTimeFormatAmPm.format(_date));

          if (_fromDate.isAtSameMomentAs(_toDate)) {
            if (Converter.isSameDate(_fromDate, _date)) {
              purchases.add(purchase);
            }
          } else if (_date.isAfter(_fromDate) && _date.isBefore(_toDate)) {
            purchases.add(purchase);
          }
        }

        // if only fromDate is selected
        else if (_fromDate != null) {
          if (_date.isAfter(_fromDate)) purchases.add(purchase);
        }

        // if only toDate is selected
        else if (_toDate != null) {
          if (_date.isBefore(_toDate)) purchases.add(purchase);
        }
      }

      return purchases.reversed.toList();
    } else {
      return purchasesList.reversed.toList();
    }
  }
}
