import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/device/date_time.dart';
import 'package:mobile_pos/db/db_functions/expense/expense_database.dart';
import 'package:mobile_pos/db/db_functions/purchase/purchase_database.dart';
import 'package:mobile_pos/db/db_functions/sales/sales_database.dart';
import 'package:mobile_pos/db/db_functions/transactions/transactions_database.dart';
import 'package:mobile_pos/model/expense/expense_model.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import 'package:mobile_pos/model/transactions/transactions_model.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';

//=-=-=-=-=-=-=-=-=-= Providers =-=-=-=-=-=-=-=-=-=
final _fromDateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _toDateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

final _fromDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final _toDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

final _isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

final _summaryProvider = StateProvider.autoDispose<List<Map<String, num>>>((ref) => []);

final _summaryFutureProvider = FutureProvider.autoDispose<List<Map<String, num>>>((ref) async {
  final DateTime _today = DateTime.now();

  final List<SalesModel> sales = await SalesDatabase.instance.getSalesByDay(_today);
  final List<TransactionsModel> salesTransactions = await TransactionDatabase.instance.getAllSalesTransactionsByDay(_today);

  final List<PurchaseModel> purchases = await PurchaseDatabase.instance.getPurchasesByDay(_today);
  final List<TransactionsModel> purchasesTransactions = await TransactionDatabase.instance.getAllPurchasesTransactionsByDay(_today);

  final List<ExpenseModel> expenses = await ExpenseDatabase.instance.getExpensesByDay(_today);

  return await _getSummaries(
      sales: sales, salesTransaction: salesTransactions, purchases: purchases, purchasesTransaction: purchasesTransactions, expenses: expenses);
});

class ScreenOperationSummary extends StatelessWidget {
  const ScreenOperationSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('Build()=> called!');

    return Scaffold(
      appBar: AppBarWidget(title: 'Operation Summary'),
      body: SafeArea(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //======================================================================
                //==================== From Date and To Date Filter Fields =============
                //======================================================================
                Consumer(
                  builder: (context, ref, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.watch(_fromDateController);
                      ref.watch(_toDateController);
                      ref.watch(_fromDateProvider);
                      ref.watch(_toDateProvider);
                      ref.watch(_isLoadedProvider);
                    });
                    return Row(
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
                                  if (ref.read(_toDateProvider) != null) {
                                    final List<SalesModel> sales = await SalesDatabase.instance.getSalesByDate(toDate: ref.read(_toDateProvider));
                                    final List<TransactionsModel> salesTransactions =
                                        await TransactionDatabase.instance.getSalesTransactionsByDate(toDate: ref.read(_toDateProvider));

                                    final List<PurchaseModel> purchases =
                                        await PurchaseDatabase.instance.getPurchasesByDate(toDate: ref.read(_toDateProvider));
                                    final List<TransactionsModel> purchasesTransactions =
                                        await TransactionDatabase.instance.getPurchasesTransactionsByDate(toDate: ref.read(_toDateProvider));

                                    final List<ExpenseModel> expenses =
                                        await ExpenseDatabase.instance.getExpensesByDate(toDate: ref.read(_toDateProvider));

                                    ref.read(_summaryProvider.notifier).state = await _getSummaries(
                                      sales: sales,
                                      salesTransaction: salesTransactions,
                                      purchases: purchases,
                                      purchasesTransaction: purchasesTransactions,
                                      expenses: expenses,
                                    );
                                  } else {
                                    final reset = ref.read(_summaryFutureProvider);
                                    ref.read(_summaryProvider.notifier).state = reset.asData!.value;
                                  }
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

                                final List<SalesModel> sales =
                                    await SalesDatabase.instance.getSalesByDate(fromDate: _fromDate, toDate: ref.read(_toDateProvider));
                                final List<TransactionsModel> salesTransactions = await TransactionDatabase.instance
                                    .getSalesTransactionsByDate(fromDate: _fromDate, toDate: ref.read(_toDateProvider));

                                final List<PurchaseModel> purchases =
                                    await PurchaseDatabase.instance.getPurchasesByDate(fromDate: _fromDate, toDate: ref.read(_toDateProvider));
                                final List<TransactionsModel> purchasesTransactions = await TransactionDatabase.instance
                                    .getPurchasesTransactionsByDate(fromDate: _fromDate, toDate: ref.read(_toDateProvider));

                                final List<ExpenseModel> expenses =
                                    await ExpenseDatabase.instance.getExpensesByDate(fromDate: _fromDate, toDate: ref.read(_toDateProvider));

                                ref.read(_summaryProvider.notifier).state = await _getSummaries(
                                    sales: sales,
                                    salesTransaction: salesTransactions,
                                    purchases: purchases,
                                    purchasesTransaction: purchasesTransactions,
                                    expenses: expenses);
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

                                  if (ref.read(_fromDateProvider) != null) {
                                    final List<SalesModel> sales = await SalesDatabase.instance.getSalesByDate(fromDate: ref.read(_fromDateProvider));
                                    final List<TransactionsModel> salesTransactions =
                                        await TransactionDatabase.instance.getSalesTransactionsByDate(fromDate: ref.read(_fromDateProvider));

                                    final List<PurchaseModel> purchases =
                                        await PurchaseDatabase.instance.getPurchasesByDate(fromDate: ref.read(_fromDateProvider));
                                    final List<TransactionsModel> purchasesTransactions =
                                        await TransactionDatabase.instance.getPurchasesTransactionsByDate(fromDate: ref.read(_fromDateProvider));

                                    final List<ExpenseModel> expenses =
                                        await ExpenseDatabase.instance.getExpensesByDate(fromDate: ref.read(_fromDateProvider));
                                    ref.read(_summaryProvider.notifier).state = await _getSummaries(
                                      sales: sales,
                                      salesTransaction: salesTransactions,
                                      purchases: purchases,
                                      purchasesTransaction: purchasesTransactions,
                                      expenses: expenses,
                                    );
                                  } else {
                                    final reset = ref.read(_summaryFutureProvider);
                                    ref.read(_summaryProvider.notifier).state = reset.asData!.value;
                                  }
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
                              final _toDate = await DateTimeUtils.instance.datePicker(context, initDate: ref.read(_toDateProvider), endDate: true);
                              if (_toDate != null) {
                                final parseDate = Converter.dateFormat.format(_toDate);
                                ref.read(_toDateController).text = parseDate.toString();
                                ref.read(_toDateProvider.notifier).state = _toDate;

                                final List<SalesModel> sales =
                                    await SalesDatabase.instance.getSalesByDate(fromDate: ref.read(_fromDateProvider), toDate: _toDate);
                                final List<TransactionsModel> salesTransactions = await TransactionDatabase.instance
                                    .getSalesTransactionsByDate(fromDate: ref.read(_fromDateProvider), toDate: _toDate);

                                final List<PurchaseModel> purchases =
                                    await PurchaseDatabase.instance.getPurchasesByDate(fromDate: ref.read(_fromDateProvider), toDate: _toDate);

                                final List<TransactionsModel> purchasesTransactions = await TransactionDatabase.instance
                                    .getPurchasesTransactionsByDate(fromDate: ref.read(_fromDateProvider), toDate: _toDate);

                                final List<ExpenseModel> expenses =
                                    await ExpenseDatabase.instance.getExpensesByDate(fromDate: ref.read(_fromDateProvider), toDate: _toDate);

                                ref.read(_summaryProvider.notifier).state = await _getSummaries(
                                  sales: sales,
                                  salesTransaction: salesTransactions,
                                  purchases: purchases,
                                  purchasesTransaction: purchasesTransactions,
                                  expenses: expenses,
                                );
                              }
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),

                kHeight10,
                Consumer(
                  builder: (context, ref, _) {
                    log('FutureProvider()=> called');
                    final futureSummary = ref.watch(_summaryFutureProvider);

                    return futureSummary.when(
                      data: (value) {
                        Map<String, num> sale = value[0];
                        Map<String, num> purchase = value[1];
                        Map<String, num> expense = value[2];

                        return Consumer(
                          builder: (context, ref, _) {
                            final isLoaded = ref.read(_isLoadedProvider.notifier);
                            log('isLoaded = ${isLoaded.state}');
                            final List<Map<String, num>> summary = ref.watch(_summaryProvider);
                            if (isLoaded.state) {
                              sale = summary[0];
                              purchase = summary[1];
                              expense = summary[2];
                            }

                            WidgetsBinding.instance.addPostFrameCallback((_) => isLoaded.state = true);

                            return Column(
                              children: [
                                //== == == == == Sales Summary Card == == == == ==
                                Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: const Text('Sales', style: TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.start),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(color: kBlack),
                                        kHeight5,
                                        summaryRow(name: 'Total Sales', amount: sale['totalAmount']!),
                                        summaryRow(name: 'Cash Sales', amount: sale['cashAmount']!),
                                        summaryRow(name: 'Bank Sales', amount: sale['bankAmount']!),
                                        summaryRow(name: 'Sales VAT', amount: sale['vatAmount']!),
                                        summaryRow(name: 'Receivable Amount', amount: sale['receivable']!),
                                        kHeight5,
                                      ],
                                    ),
                                  ),
                                ),

                                kHeight10,
                                //== == == == == Purchases Summary Card == == == == ==
                                Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: const Text('Purchases', style: TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.start),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(color: kBlack),
                                        kHeight5,
                                        summaryRow(name: 'Total Purchases', amount: purchase['totalAmount']!),
                                        summaryRow(name: 'Cash Purchases', amount: purchase['cashAmount']!),
                                        summaryRow(name: 'Bank Purchases', amount: purchase['bankAmount']!),
                                        summaryRow(name: 'Purchases VAT', amount: purchase['vatAmount']!),
                                        summaryRow(name: 'Payable Amount', amount: purchase['payable']!),
                                        kHeight5,
                                      ],
                                    ),
                                  ),
                                ),

                                kHeight10,
                                //== == == == == Expenses Summary Card == == == == ==
                                Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: const Text('Expenses', style: TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.start),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(color: kBlack),
                                        kHeight5,
                                        summaryRow(name: 'Total Expenses', amount: expense['totalAmount']!),
                                        summaryRow(name: 'Cash Expenses', amount: expense['cashAmount']!),
                                        summaryRow(name: 'Bank Expenses', amount: expense['bankAmount']!),
                                        summaryRow(name: 'Expenses VAT', amount: expense['vatAmount']!),
                                        kHeight5,
                                      ],
                                    ),
                                  ),
                                ),

                                //== == == == == Outstanding Amount == == == == ==
                                Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title:
                                        const Text('Outstanding Amount', style: TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Divider(color: kBlack),
                                        Text(
                                          Converter.currency.format(sale['cashAmount']! - purchase['cashAmount']! - expense['cashAmount']!),
                                          style: kTextBlack,
                                          textAlign: TextAlign.center,
                                        ),
                                        kHeight5,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
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
      ),
    );
  }

//=== === === === === Summary Row === === === === ===
  Row summaryRow({required String name, required num amount}) {
    return Row(
      children: [
        Expanded(flex: 6, child: Text(name, textAlign: TextAlign.start, style: kText12)),
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
  required final List<TransactionsModel> salesTransaction,
  required final List<PurchaseModel> purchases,
  required final List<TransactionsModel> purchasesTransaction,
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
    vatAmount.add(num.parse(sale.vatAmount));
    receivable.add(num.parse(sale.balance));
  }

  //== == == == == Sales Transactions Summary == == == == ==
  for (TransactionsModel transaction in salesTransaction) {
    if (transaction.paymentMethod == 'Cash') cashAmount.add(num.parse(transaction.amount));
    if (transaction.paymentMethod == 'Bank') bankAmount.add(num.parse(transaction.amount));
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
    vatAmount.add(num.parse(purchase.vatAmount));
    payable.add(num.parse(purchase.balance));
  }

  //== == == == == Purchases Transactions Summary == == == == ==
  for (TransactionsModel transaction in purchasesTransaction) {
    if (transaction.paymentMethod == 'Cash') cashAmount.add(num.parse(transaction.amount));
    if (transaction.paymentMethod == 'Bank') bankAmount.add(num.parse(transaction.amount));
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
    if (expense.paymentMethod == 'Cash') cashAmount.add(num.parse(expense.amount));
    if (expense.paymentMethod == 'Bank') bankAmount.add(num.parse(expense.amount));
    vatAmount.add(num.parse(expense.vatAmount ?? '0'));
  }

  final Map<String, num> expensesSummary = {
    'totalAmount': totalAmount.sum,
    'cashAmount': cashAmount.sum,
    'bankAmount': bankAmount.sum,
    'vatAmount': vatAmount.sum,
  };

  return [saleSummary, purchasesSummary, expensesSummary];
}
