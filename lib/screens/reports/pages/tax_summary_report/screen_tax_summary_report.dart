// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/device/date_time.dart';
import 'package:mobile_pos/db/db_functions/expense/expense_database.dart';
import 'package:mobile_pos/db/db_functions/purchase/purchase_database.dart';
import 'package:mobile_pos/db/db_functions/sales/sales_database.dart';
import 'package:mobile_pos/model/expense/expense_model.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import 'package:mobile_pos/screens/reports/pages/tax_summary_report/widgets/tax_summary_card.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenTaxSummaryReport extends StatelessWidget {
  ScreenTaxSummaryReport({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<num> totalPayabaleTaxNotifier = ValueNotifier(0);
  final ValueNotifier<Map?> salesNotifier = ValueNotifier({'totalAmount': 0, 'excludeAmount': 0, 'vatAmount': 0});
  final ValueNotifier<Map?> purchasesNotifier = ValueNotifier({'totalAmount': 0, 'excludeAmount': 0, 'vatAmount': 0});
  final ValueNotifier<Map?> expensesNotifer = ValueNotifier({'totalAmount': 0, 'vatAmount': 0});

  //==================== DateTime ====================
  DateTime? fromDate;
  DateTime? toDate;

  //==================== Lists ====================
  List<SalesModel> salesList = [];
  List<PurchaseModel> purchasesList = [];
  List<ExpenseModel> expensesList = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Load Taxt Summary
      await getTaxSummary();
    });

    return Scaffold(
      appBar: AppBarWidget(title: 'Tax Summary Report'),
      backgroundColor: kGrey200,
      body: SafeArea(
          child: ItemScreenPaddingWidget(
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
                          getTaxSummary();
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
                        getTaxSummary();
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
                          getTaxSummary();
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
                        getTaxSummary();
                      }
                    },
                  ),
                )
              ],
            ),

            kHeight5,

            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  //== == == == == Sales Summary == == == == ==
                  ValueListenableBuilder(
                      valueListenable: salesNotifier,
                      builder: (context, Map? sale, _) {
                        return InkWell(
                          child: TaxSummaryCard(
                            title: 'Sale Summary',
                            color: kGreen,
                            totalAmount: sale?['totalAmount'],
                            excludeAmount: sale?['excludeAmount'],
                            vatAmount: sale?['vatAmount'],
                          ),
                          onTap: () async {
                            await Navigator.pushNamed(context, routeSalesTaxReport, arguments: {
                              'fromDate': fromDate,
                              'toDate': toDate,
                            });
                          },
                        );
                      }),
                  kHeight10,

                  //== == == == == Purchase Summary == == == == ==
                  ValueListenableBuilder(
                      valueListenable: purchasesNotifier,
                      builder: (context, Map? purchase, _) {
                        return InkWell(
                          child: TaxSummaryCard(
                            title: 'Purchase Summary',
                            color: kBlue,
                            totalAmount: purchase?['totalAmount'],
                            excludeAmount: purchase?['excludeAmount'],
                            vatAmount: purchase?['vatAmount'],
                          ),
                          onTap: () async {
                            await Navigator.pushNamed(context, routePurchasesTaxReport, arguments: {
                              'fromDate': fromDate,
                              'toDate': toDate,
                            });
                          },
                        );
                      }),
                  kHeight10,

                  //== == == == == Expenses Summary == == == == ==
                  ValueListenableBuilder(
                      valueListenable: expensesNotifer,
                      builder: (context, Map? expense, _) {
                        return InkWell(
                          child: TaxSummaryCard(
                            title: 'Expense Summary',
                            color: kOrange,
                            totalAmount: expense?['totalAmount'],
                            vatAmount: expense?['vatAmount'],
                          ),
                        );
                      }),

                  kHeight20,
                  Card(
                    elevation: 10,
                    shadowColor: kRed,
                    child: ListTile(
                      contentPadding: kPadding5,
                      title: Column(
                        children: [
                          const Text(
                            'Total Payable Tax',
                            style: TextStyle(
                              color: kRed,
                              fontWeight: FontWeight.w500,
                              decorationStyle: TextDecorationStyle.double,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          kHeight5,
                          ValueListenableBuilder(
                              valueListenable: totalPayabaleTaxNotifier,
                              builder: (context, num tax, _) {
                                return Text(
                                  Converter.currency.format(tax),
                                  style: const TextStyle(
                                    color: kRed,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
          ],
        ),
      )),
    );
  }

  //== == == == == Get Tax Summary Details == == == == ==
  Future<void> getTaxSummary() async {
    if (salesList.isEmpty) salesList = await SalesDatabase.instance.getAllSales();
    if (purchasesList.isEmpty) purchasesList = await PurchaseDatabase.instance.getAllPurchases();
    if (expensesList.isEmpty) expensesList = await ExpenseDatabase.instance.getAllExpense();

    List<SalesModel> sales = [];
    List<PurchaseModel> purchases = [];
    List<ExpenseModel> expenses = [];

    if (fromDate != null || toDate != null) {
      final DateTime? _fromDate = fromDate;
      final DateTime? _toDate = toDate;

      //Sales Tax Summary ~ Filter
      for (SalesModel sale in salesList) {
        final DateTime _soldDate = DateTime.parse(sale.dateTime);

        // if fromDate and toDate is selected
        if (_fromDate != null && _toDate != null) {
          if (Converter.isSameDate(_fromDate, _toDate) && Converter.isSameDate(_fromDate, _soldDate)) {
            sales.add(sale);
          } else if (_soldDate.isAfter(_fromDate) && _soldDate.isBefore(_toDate)) {
            sales.add(sale);
          }
        }

        // if only fromDate is selected
        else if (_fromDate != null) {
          if (_soldDate.isAfter(_fromDate)) sales.add(sale);
        }

        // if only toDate is selected
        else if (_toDate != null) {
          if (_soldDate.isBefore(_toDate)) sales.add(sale);
        }
      }

      //Purchase Tax Summary ~ Filter
      for (PurchaseModel purchase in purchasesList) {
        final DateTime _date = DateTime.parse(purchase.dateTime);

        // if fromDate and toDate is selected
        if (_fromDate != null && _toDate != null) {
          if (_date.isAfter(_fromDate) && _date.isBefore(_toDate)) purchases.add(purchase);
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

      //Expense Tax Summary ~ Filter
      for (ExpenseModel expense in expensesList) {
        final DateTime _date = DateTime.parse(expense.date);

        // if fromDate and toDate is selected
        if (_fromDate != null && _toDate != null) {
          if (_date.isAfter(_fromDate) && _date.isBefore(_toDate)) expenses.add(expense);
        }

        // if only fromDate is selected
        else if (_fromDate != null) {
          if (_date.isAfter(_fromDate)) expenses.add(expense);
        }

        // if only toDate is selected
        else if (_toDate != null) {
          if (_date.isBefore(_toDate)) expenses.add(expense);
        }
      }
    } else {
      sales = salesList;
      purchases = purchasesList;
      expenses = expensesList;
    }

    final List<num> grandTotals = [];
    final List<num> excludeAmounts = [];
    final List<num> vatAmounts = [];

    //== == == == == Sales Summary == == == == ==
    for (SalesModel sale in sales) {
      grandTotals.add(num.parse(sale.grantTotal));
      excludeAmounts.add(num.parse(sale.subTotal));
      vatAmounts.add(num.parse(sale.vatAmount));
    }

    final num totalSaleAmount = grandTotals.sum;
    final num totalSaleExcludeAmount = excludeAmounts.sum;
    final num totalSaleVatAmount = vatAmounts.sum;

    // log('Total Sales Amounts == $totalSaleAmount');
    // log('Total Sales Exclude Amounts == $totalSaleExcludeAmount');
    // log('Total Sales VAT Amounts == $totalSaleVatAmount');
    salesNotifier.value = {'totalAmount': totalSaleAmount, 'excludeAmount': totalSaleExcludeAmount, 'vatAmount': totalSaleVatAmount};

    grandTotals.clear();
    excludeAmounts.clear();
    vatAmounts.clear();

    //== == == == == Purchases Summary == == == == ==
    for (PurchaseModel purchase in purchases) {
      grandTotals.add(num.parse(purchase.grantTotal));
      excludeAmounts.add(num.parse(purchase.subTotal));
      vatAmounts.add(num.parse(purchase.vatAmount));
    }

    final num totalPurchaseAmount = grandTotals.sum;
    final num totalPurchaseExcludeAmount = excludeAmounts.sum;
    final num totalPurchaseVatAmount = vatAmounts.sum;

    // log('Total Purchase Amounts == $totalPurchaseAmount');
    // log('Total Purchase Exclude Amounts == $totalPurchaseExcludeAmount');
    // log('Total Purchase VAT Amounts == $totalPurchaseVatAmount');
    purchasesNotifier.value = {'totalAmount': totalPurchaseAmount, 'excludeAmount': totalPurchaseExcludeAmount, 'vatAmount': totalPurchaseVatAmount};

    grandTotals.clear();
    excludeAmounts.clear();
    vatAmounts.clear();

    //== == == == == Expenses Summary == == == == ==
    for (ExpenseModel expense in expenses) {
      grandTotals.add(num.parse(expense.amount));
      if (expense.vatAmount != null) vatAmounts.add(num.parse(expense.vatAmount!));
    }

    final num totalExpenseAmount = grandTotals.sum;
    final num totalExpenseVatAmount = vatAmounts.sum;

    // log('Total Expense Amounts == $totalExpenseAmount');
    // log('Total Expense VAT Amounts == $totalExpenseVatAmount');
    expensesNotifer.value = {'totalAmount': totalExpenseAmount, 'excludeAmount': totalPurchaseExcludeAmount, 'vatAmount': totalExpenseVatAmount};

    final num totalPayableVat = totalSaleVatAmount - totalPurchaseVatAmount - totalExpenseVatAmount;
    log('Total Payable VAT == $totalPayableVat');

    //Notify Total Payable Tax
    totalPayabaleTaxNotifier.value = totalPayableVat;
  }
}
