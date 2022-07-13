import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

//=-=-=-=-=-=-=-=-=-= Providers =-=-=-=-=-=-=-=-=-=
final _fromDateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _toDateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

final _fromDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final _toDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

final isLoadedProvider = StateProvider<bool>((ref) => false);

final summaryProvider = FutureProvider.autoDispose<List<Map<String, num>>>((ref) async {
  final _date = DateTime.now();
  final _today = Converter.dateFormatReverse.format(_date);

  final List<SalesModel> sales = await SalesDatabase.instance.getTodaySales(_today);
  final List<PurchaseModel> purchases = await PurchaseDatabase.instance.getTodayPurchase(_today);
  final List<ExpenseModel> expenses = await ExpenseDatabase.instance.getTodayExpense(_today);

  return await _getSummaries(sales: sales, purchases: purchases, expenses: expenses);
});

class ScreenOperationSummary extends ConsumerWidget {
  const ScreenOperationSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('Build()=> called!');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(_fromDateController);
      ref.watch(_toDateController);
    });
    return Scaffold(
      appBar: AppBarWidget(title: 'Operation Summary'),
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
                      controller: ref.read(_fromDateController),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      suffixIcon: Padding(
                        padding: kClearTextIconPadding,
                        child: InkWell(
                          child: const Icon(Icons.clear, size: 15),
                          onTap: () async {
                            ref.refresh(_fromDateController);
                            ref.read(_fromDateProvider.notifier).state = null;
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
                        final DateTime? _fromDate = await DateTimeUtils.instance.datePicker(context, initDate: ref.read(_fromDateProvider));
                        if (_fromDate != null) {
                          final String parseDate = Converter.dateFormat.format(_fromDate);
                          ref.read(_fromDateController).text = parseDate.toString();
                          ref.read(_fromDateProvider.notifier).state = _fromDate;

                          // final _date = Converter.dateForDatabase.format(_fromDate);

                          // log('Date iso = ${_fromDate.toIso8601String()}');

                          // log('formatted date = $_date');

                          // final newDate = DateTime.parse(_fromDate.toIso8601String());

                          // log('reversed date = $newDate');

                          final _date = DateTime.now();
                          final _today = Converter.dateFormatReverse.format(_date);

                          final convertedFromDate = Converter.dateForDatabase.format(_fromDate.subtract(const Duration(seconds: 1)));
                          log('_fromDate == $convertedFromDate');

                          final List<SalesModel> sales = await SalesDatabase.instance.getSalesByDate(fromDate: _fromDate);
                          final List<PurchaseModel> purchases = await PurchaseDatabase.instance.getTodayPurchase(_today);
                          final List<ExpenseModel> expenses = await ExpenseDatabase.instance.getTodayExpense(_today);

                          return await _getSummaries(sales: sales, purchases: purchases, expenses: expenses);
                        }
                      },
                    ),
                  ),

                  kWidth5,

                  //=== === === === === To Date Field === === === === ===
                  Flexible(
                    flex: 1,
                    child: TextFeildWidget(
                      hintText: 'To Date ',
                      controller: ref.read(_toDateController),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      suffixIcon: Padding(
                        padding: kClearTextIconPadding,
                        child: InkWell(
                          child: const Icon(Icons.clear, size: 15),
                          onTap: () async {
                            ref.refresh(_toDateController);
                            ref.read(_toDateProvider.notifier).state = null;
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
                        final _selectedDate = await DateTimeUtils.instance.datePicker(context, initDate: ref.read(_toDateProvider), endDate: true);
                        if (_selectedDate != null) {
                          final parseDate = Converter.dateFormat.format(_selectedDate);
                          ref.read(_toDateController).text = parseDate.toString();
                          ref.read(_toDateProvider.notifier).state = _selectedDate;
                        }
                      },
                    ),
                  )
                ],
              ),

              kHeight10,
              Consumer(
                builder: (context, ref, _) {
                  final futureSummary = ref.watch(summaryProvider);

                  return futureSummary.when(
                    data: (value) {
                      final Map<String, num> sale = value.first;
                      final Map<String, num> purchase = value[1];
                      final Map<String, num> expense = value[2];

                      return Column(
                        children: [
                          //== == == == == Sales Summary Card == == == == ==
                          Card(
                            elevation: 5,
                            child: ListTile(
                              title: const Text('Sales', style: TextStyle(decoration: TextDecoration.underline), textAlign: TextAlign.center),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kHeight5,
                                  summaryRow(name: 'Total Sales', amount: sale['totalAmount']!),
                                  summaryRow(name: 'Cash Sales', amount: sale['cashAmount']!),
                                  summaryRow(name: 'Bank Sales', amount: sale['bankAmount']!),
                                  summaryRow(name: 'Sales VAT', amount: sale['vatAmount']!),
                                  summaryRow(name: 'Receivable Amount', amount: sale['receivable']!),
                                ],
                              ),
                            ),
                          ),

                          kHeight10,
                          //== == == == == Purchases Summary Card == == == == ==
                          Card(
                            elevation: 5,
                            child: ListTile(
                              title: const Text('Purchases', style: TextStyle(decoration: TextDecoration.underline), textAlign: TextAlign.center),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kHeight5,
                                  summaryRow(name: 'Total Purchases', amount: purchase['totalAmount']!),
                                  summaryRow(name: 'Cash Purchases', amount: purchase['cashAmount']!),
                                  summaryRow(name: 'Bank Purchases', amount: purchase['bankAmount']!),
                                  summaryRow(name: 'Purchases VAT', amount: purchase['vatAmount']!),
                                  summaryRow(name: 'Payable Amount', amount: purchase['payable']!),
                                ],
                              ),
                            ),
                          ),

                          kHeight10,
                          //== == == == == Expenses Summary Card == == == == ==
                          Card(
                            elevation: 5,
                            child: ListTile(
                              title: const Text('Expenses', style: TextStyle(decoration: TextDecoration.underline), textAlign: TextAlign.center),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kHeight5,
                                  summaryRow(name: 'Total Expenses', amount: expense['totalAmount']!),
                                  summaryRow(name: 'Expenses VAT', amount: expense['vatAmount']!),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (_, __) => const Center(child: Text('Something went wrong!')),
                    loading: () => const SingleChildScrollView(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//=== === === === === Summary Row === === === === ===
  Row summaryRow({required String name, required num amount}) {
    return Row(
      children: [
        Expanded(flex: 6, child: Text(name, textAlign: TextAlign.end, style: kText12)),
        const Expanded(flex: 1, child: Text(' : ', textAlign: TextAlign.center)),
        Expanded(flex: 6, child: Text(Converter.currency.format(amount), style: kText12Black)),
        kHeight2,
      ],
    );
  }
}

//==== ==== ==== ==== ==== Get Summaries ==== ==== ==== ==== ====
Future<List<Map<String, num>>> _getSummaries({
  required final List<SalesModel> sales,
  required final List<PurchaseModel> purchases,
  required final List<ExpenseModel> expenses,
}) async {
  final List<num> totalAmount = [];
  final List<num> cashAmount = [];
  final List<num> bankAmount = [];
  final List<num> vatAmount = [];
  final List<num> receivable = [];
  final List<num> payable = [];

  //== == == == == Sales Summary == == == == ==
  for (SalesModel sale in sales) {
    totalAmount.add(num.parse(sale.grantTotal));
    if (sale.paymentType == 'Cash') cashAmount.add(num.parse(sale.paid));
    if (sale.paymentType == 'Bank') bankAmount.add(num.parse(sale.paid));
    vatAmount.add(num.parse(sale.vatAmount));
    receivable.add(num.parse(sale.balance));
  }

  final Map<String, num> saleSummary = {
    'totalAmount': totalAmount.sum,
    'cashAmount': cashAmount.sum,
    'bankAmount': bankAmount.sum,
    'vatAmount': vatAmount.sum,
    'receivable': receivable.sum,
  };

  totalAmount.clear();
  cashAmount.clear();
  bankAmount.clear();
  vatAmount.clear();
  receivable.clear();

  //== == == == == Purchases Summary == == == == ==
  for (PurchaseModel purchase in purchases) {
    totalAmount.add(num.parse(purchase.grantTotal));
    if (purchase.paymentType == 'Cash') cashAmount.add(num.parse(purchase.paid));
    if (purchase.paymentType == 'Bank') bankAmount.add(num.parse(purchase.paid));
    vatAmount.add(num.parse(purchase.vatAmount));
    payable.add(num.parse(purchase.balance));
  }

  final Map<String, num> purchasesSummary = {
    'totalAmount': totalAmount.sum,
    'cashAmount': cashAmount.sum,
    'bankAmount': bankAmount.sum,
    'vatAmount': vatAmount.sum,
    'payable': payable.sum,
  };

  totalAmount.clear();
  cashAmount.clear();
  bankAmount.clear();
  vatAmount.clear();
  payable.clear();

  //== == == == == Expenses Summary == == == == ==
  for (ExpenseModel expense in expenses) {
    totalAmount.add(num.parse(expense.amount));
    vatAmount.add(num.parse(expense.vatAmount ?? '0'));
  }

  final Map<String, num> expensesSummary = {
    'totalAmount': totalAmount.sum,
    'vatAmount': vatAmount.sum,
  };

  return [saleSummary, purchasesSummary, expensesSummary];
}
