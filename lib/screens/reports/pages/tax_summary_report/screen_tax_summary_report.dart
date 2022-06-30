// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/date_time.dart';
import 'package:shop_ez/db/db_functions/expense/expense_database.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/reports/pages/tax_summary_report/widgets/tax_summary_card.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenTaxSummaryReport extends StatelessWidget {
  ScreenTaxSummaryReport({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<num> totalPayabaleTaxNotifier = ValueNotifier(0);
  final ValueNotifier<Map?> salesNotifier = ValueNotifier({
    'totalAmount': 0,
    'excludeAmount': 0,
    'vatAmount': 0,
  });
  final ValueNotifier<Map?> purchasesNotifier = ValueNotifier({
    'totalAmount': 0,
    'excludeAmount': 0,
    'vatAmount': 0,
  });
  final ValueNotifier<Map?> expensesNotifer = ValueNotifier({
    'totalAmount': 0,
    'vatAmount': 0,
  });

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
                      final _selectedDate = await DateTimeUtils.instance.datePicker(context);
                      if (_selectedDate != null) {
                        final parseDate = Converter.dateFormat.format(_selectedDate);
                        fromDateController.text = parseDate.toString();
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
                      final _selectedDate = await DateTimeUtils.instance.datePicker(context);
                      if (_selectedDate != null) {
                        final parseDate = Converter.dateFormat.format(_selectedDate);
                        toDateController.text = parseDate.toString();
                        await getTaxSummary();
                      }
                    },
                  ),
                )
              ],
            ),

            kHeight10,

            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  //== == == == == Sales Summary == == == == ==
                  ValueListenableBuilder(
                      valueListenable: salesNotifier,
                      builder: (context, Map? sale, _) {
                        return TaxSummaryCard(
                          title: 'Sale Summary',
                          color: kGreen,
                          totalAmount: sale?['totalAmount'],
                          excludeAmount: sale?['excludeAmount'],
                          vatAmount: sale?['vatAmount'],
                        );
                      }),
                  kHeight10,

                  //== == == == == Purchase Summary == == == == ==
                  ValueListenableBuilder(
                      valueListenable: purchasesNotifier,
                      builder: (context, Map? purchase, _) {
                        return TaxSummaryCard(
                          title: 'Purchase Summary',
                          color: kBlue,
                          totalAmount: purchase?['totalAmount'],
                          excludeAmount: purchase?['excludeAmount'],
                          vatAmount: purchase?['vatAmount'],
                        );
                      }),
                  kHeight10,

                  //== == == == == Expenses Summary == == == == ==
                  ValueListenableBuilder(
                      valueListenable: expensesNotifer,
                      builder: (context, Map? expense, _) {
                        return TaxSummaryCard(
                          title: 'Expense Summary',
                          color: kOrange,
                          totalAmount: expense?['totalAmount'],
                          vatAmount: expense?['vatAmount'],
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

    final List<num> grandTotals = [];
    final List<num> excludeAmounts = [];
    final List<num> vatAmounts = [];

    //== == == == == Sales Summary == == == == ==
    for (SalesModel sale in salesList) {
      grandTotals.add(num.parse(sale.grantTotal));
      excludeAmounts.add(num.parse(sale.subTotal));
      vatAmounts.add(num.parse(sale.vatAmount));
    }

    final num totalSaleAmount = grandTotals.sum;
    final num totalSaleExcludeAmount = excludeAmounts.sum;
    final num totalSaleVatAmount = vatAmounts.sum;

    log('Total Sales Amounts == $totalSaleAmount');
    log('Total Sales Exclude Amounts == $totalSaleExcludeAmount');
    log('Total Sales VAT Amounts == $totalSaleVatAmount');
    salesNotifier.value = {'totalAmount': totalSaleAmount, 'excludeAmount': totalSaleExcludeAmount, 'vatAmount': totalSaleVatAmount};

    grandTotals.clear();
    excludeAmounts.clear();
    vatAmounts.clear();

    //== == == == == Purchases Summary == == == == ==
    for (PurchaseModel purchase in purchasesList) {
      grandTotals.add(num.parse(purchase.grantTotal));
      excludeAmounts.add(num.parse(purchase.subTotal));
      vatAmounts.add(num.parse(purchase.vatAmount));
    }

    final num totalPurchaseAmount = grandTotals.sum;
    final num totalPurchaseExcludeAmount = excludeAmounts.sum;
    final num totalPurchaseVatAmount = vatAmounts.sum;

    log('Total Purchase Amounts == $totalPurchaseAmount');
    log('Total Purchase Exclude Amounts == $totalPurchaseExcludeAmount');
    log('Total Purchase VAT Amounts == $totalPurchaseVatAmount');
    purchasesNotifier.value = {'totalAmount': totalPurchaseAmount, 'excludeAmount': totalPurchaseExcludeAmount, 'vatAmount': totalPurchaseVatAmount};

    grandTotals.clear();
    excludeAmounts.clear();
    vatAmounts.clear();

    //== == == == == Expenses Summary == == == == ==
    for (ExpenseModel expense in expensesList) {
      grandTotals.add(num.parse(expense.amount));
      if (expense.vatAmount != null) vatAmounts.add(num.parse(expense.vatAmount!));
    }

    final num totalExpenseAmount = grandTotals.sum;
    final num totalExpenseVatAmount = vatAmounts.sum;

    log('Total Expense Amounts == $totalExpenseAmount');
    log('Total Expense VAT Amounts == $totalExpenseVatAmount');
    expensesNotifer.value = {'totalAmount': totalExpenseAmount, 'excludeAmount': totalPurchaseExcludeAmount, 'vatAmount': totalExpenseVatAmount};

    final num totalPayableVat = totalSaleVatAmount - totalPurchaseVatAmount - totalExpenseVatAmount;
    log('Total Payable VAT == $totalPayableVat');

    //Notify Total Payable Tax
    totalPayabaleTaxNotifier.value = totalPayableVat;
  }
}
