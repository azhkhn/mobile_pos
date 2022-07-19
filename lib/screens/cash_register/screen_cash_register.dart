import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/expense/expense_database.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

//=-=-=-=-=-=-=-=-=-= Providers =-=-=-=-=-=-=-=-=-=
final isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

final summaryProvider = StateProvider.autoDispose<List<Map<String, num>>>((ref) => []);

final summaryFutureProvider = FutureProvider.autoDispose<List<Map<String, num>>>((ref) async {
  final _date = DateTime.now();
  final _today = Converter.dateFormatReverse.format(_date);

  final List<SalesModel> sales = await SalesDatabase.instance.getTodaySales(_today);
  final List<PurchaseModel> purchases = await PurchaseDatabase.instance.getTodayPurchase(_today);
  final List<ExpenseModel> expenses = await ExpenseDatabase.instance.getTodayExpense(_today);

  return await _getSummaries(sales: sales, purchases: purchases, expenses: expenses);
});

class ScreenCashRegister extends StatelessWidget {
  const ScreenCashRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('Build()=> called!');

    return Scaffold(
      appBar: AppBarWidget(title: 'Cash Register'),
      body: SafeArea(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              Consumer(
                builder: (context, ref, _) {
                  log('FutureProvider()=> called');
                  final futureSummary = ref.watch(summaryFutureProvider);

                  return futureSummary.when(
                    data: (value) {
                      Map<String, num> sale = value[0];
                      Map<String, num> purchase = value[1];
                      Map<String, num> expense = value[2];

                      return Consumer(
                        builder: (context, ref, _) {
                          final isLoaded = ref.read(isLoadedProvider.notifier);
                          log('isLoaded = ${isLoaded.state}');
                          final List<Map<String, num>> summary = ref.watch(summaryProvider);
                          if (isLoaded.state) {
                            sale = summary[0];
                            purchase = summary[1];
                            expense = summary[2];
                          }

                          final num netAmount = Converter.amountRounder(sale['cashAmount']! - purchase['cashAmount']!);

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
                                  title: const Text('Outstanding Amount', style: TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Divider(color: kBlack),
                                      Text(
                                        Converter.currency.format(netAmount),
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
