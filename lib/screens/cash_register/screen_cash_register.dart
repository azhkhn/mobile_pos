import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/debouncer/debouncer.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/cash_register/cash_register_database.dart';
import 'package:shop_ez/db/db_functions/expense/expense_database.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/cash_register/cash_register_model.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

//=-=-=-=-=-=-=-=-=-= Providers =-=-=-=-=-=-=-=-=-=
final _isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

final _summaryProvider = StateProvider.autoDispose<List<Map<String, num>>>((ref) => []);

final summaryFutureProvider = FutureProvider.autoDispose<List<Map<String, num>>>((ref) async {
  final CashRegisterModel? _cashModel = UserUtils.instance.cashRegisterModel;

  final DateTime _date = DateTime.parse(_cashModel!.dateTime);

  final List<SalesModel> sales = await SalesDatabase.instance.getNewSales(_date);
  final List<PurchaseModel> purchases = await PurchaseDatabase.instance.getNewPurchases(_date);
  final List<ExpenseModel> expenses = await ExpenseDatabase.instance.getNewExpense(_date);

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
          child: SingleChildScrollView(
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
                            final isLoaded = ref.read(_isLoadedProvider.notifier);
                            log('isLoaded = ${isLoaded.state}');
                            final List<Map<String, num>> summary = ref.watch(_summaryProvider);
                            if (isLoaded.state) {
                              sale = summary[0];
                              purchase = summary[1];
                              expense = summary[2];
                            }

                            final CashRegisterModel _cashModel = UserUtils.instance.cashRegisterModel!;

                            final num openingCash = num.parse(_cashModel.amount);

                            final num netAmount = Converter.amountRounder(sale['cashAmount']! - purchase['cashAmount']! - expense['cashAmount']!);

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

                                //== == == == == Register Summary == == == == ==
                                Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: const Text('Register Summary', style: TextStyle(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Divider(color: kBlack),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [const Text('Net Cash : '), Text('$netAmount', style: kTextBlack, textAlign: TextAlign.center)],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Opening Cash : '),
                                            Text('$openingCash', style: kTextBlack, textAlign: TextAlign.center)
                                          ],
                                        ),
                                        kHeight5,
                                        Text(Converter.currency.format(netAmount + openingCash), style: kTextBlackW700, textAlign: TextAlign.center),
                                        kHeight5,
                                      ],
                                    ),
                                  ),
                                ),

                                kHeight5,

                                //== == == == == Take Home == == == == ==
                                CustomMaterialBtton(
                                  onPressed: () {
                                    final num balanceAmount = netAmount + openingCash;
                                    final TextEditingController _cashController = TextEditingController(text: '$balanceAmount');
                                    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                                    final closingProvider = StateProvider.autoDispose<num>((ref) => 0);
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text('Net Cash : ', style: kText12),
                                                    Text(
                                                      Converter.currency.format(balanceAmount),
                                                      style: kText12,
                                                    )
                                                  ],
                                                ),
                                                kHeight5,
                                                Consumer(
                                                  builder: (context, ref, _) {
                                                    final num closingCash = ref.watch(closingProvider);
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        const Text('Closing Cash : ', style: kText12),
                                                        Text(
                                                          Converter.currency.format(closingCash),
                                                          style: kText12,
                                                        )
                                                      ],
                                                    );
                                                  },
                                                ),
                                                kHeight15,
                                                Form(
                                                  key: _formKey,
                                                  child: TextFeildWidget(
                                                    labelText: 'Take Home',
                                                    controller: _cashController,
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    inputBorder: const OutlineInputBorder(),
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    inputFormatters: Validators.digitsOnly,
                                                    isDense: true,
                                                    textInputType: TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty || value == '.') {
                                                        return 'This field is required*';
                                                      }
                                                      if (num.parse(value) > balanceAmount) return 'Amount cannot exceed the balance*';
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      Debouncer().run(() {
                                                        ref.read(closingProvider.notifier).state =
                                                            Converter.amountRounder(balanceAmount - num.parse(value!));
                                                      });
                                                    },
                                                  ),
                                                ),
                                                kHeight5,
                                                CustomMaterialBtton(
                                                    onPressed: () async {
                                                      if (!_formKey.currentState!.validate()) return;

                                                      final num closingBalance = ref.read(closingProvider);

                                                      final String amount = closingBalance.toString();
                                                      final String dateTime = DateTime.now().toIso8601String();
                                                      final int userId = UserUtils.instance.userModel!.id!;
                                                      const String action = 'close';

                                                      log('Amount = $closingBalance');
                                                      log('DateTime = $dateTime');
                                                      log('User Id =  $userId');
                                                      log('Action = $action');

                                                      final CashRegisterModel cashRegisterModel =
                                                          CashRegisterModel(dateTime: dateTime, amount: amount, userId: userId, action: action);

                                                      CashRegisterDatabase.instance.createCashRegister(cashRegisterModel);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    buttonText: 'Submit'),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  buttonText: 'Close Register',
                                )
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
