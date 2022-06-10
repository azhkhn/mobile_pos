import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/transaction/purchase_transaction/widgets/transaction_purchase_details_table.dart';
import 'package:shop_ez/screens/transaction/purchase_transaction/widgets/transaction_purchase_payment_widget.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';

class TransactionScreenPurchase extends StatelessWidget {
  const TransactionScreenPurchase({Key? key, required this.purchaseModel}) : super(key: key);

  final PurchaseModel purchaseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Add Paymnet'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //==================== Payment Type Widget ====================
              TransactionPurchasePayment(
                totalPayable: num.parse(purchaseModel.balance),
              ),
              kHeight10,

              //==================== Transaction Details Table Widget ====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  children: [
                    TransactionPurchaseDetailsTable(borderTop: 0.5, firstRow: true, purchase: purchaseModel),
                    TransactionPurchaseDetailsTable(borderTop: 0, firstRow: false, purchase: purchaseModel),
                  ],
                ),
              ),

              kHeight15,

              CustomMaterialBtton(
                  onPressed: () async {
                    final _formState = TransactionPurchasePayment.formKey.currentState!;
                    if (_formState.validate()) {
                      showDialog(
                        context: context,
                        builder: (ctx) => KAlertDialog(
                          content: const Text('Are you sure you want to submit this transaction?'),
                          submitText: const Text(
                            'Submit',
                            style: TextStyle(),
                          ),
                          submitAction: () async {
                            Navigator.pop(ctx);
                            final PurchaseModel? updatedPurchase = await addTransaction(context, purchase: purchaseModel);
                            if (updatedPurchase != null) {
                              _formState.reset();
                              TransactionPurchaseDetailsTable.balanceNotifier.value = 0;
                              TransactionPurchaseDetailsTable.totalPayingNotifier.value = 0;
                              Navigator.pop(context, updatedPurchase);
                            } else {
                              log('Something went wrong!');
                            }
                          },
                        ),
                      );
                    } else {
                      kSnackBar(context: context, content: 'Please fill the required informations', error: true);
                    }
                  },
                  buttonText: 'Submit'),

              kHeight20,

              FutureBuilder(
                future: TransactionDatabase.instance.getAllTransactionsByPurchaseId(purchaseModel.id!),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:

                    default:
                      final List<TransactionsModel> _recentPayments = (snapshot.data as List<TransactionsModel>).reversed.toList();

                      return _recentPayments.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: _recentPayments.length,
                                itemBuilder: (ctx, index) {
                                  final _payment = _recentPayments[index];
                                  return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: kTransparentColor,
                                        child: Text(
                                          '${index + 1}'.toString(),
                                          style: const TextStyle(fontSize: 12, color: kTextColor),
                                        ),
                                      ),
                                      title: Text(
                                        Converter.dateTimeFormatAmPm.format(DateTime.parse(_payment.dateTime)),
                                        style: kText12Lite,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _payment.transactionType == 'Income'
                                                ? Converter.currency.format(num.parse(_payment.amount))
                                                : Converter.currency.format(num.parse(_payment.amount)),
                                            style: TextStyle(
                                                color: _payment.transactionType == 'Income' ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C)),
                                          ),
                                          kWidth10,
                                          Icon(Icons.verified_outlined, color: _payment.transactionType == 'Income' ? kGreen : Colors.red),
                                        ],
                                      ));
                                },
                              ),
                            )
                          : const Center(child: Text('No recent Transactions'));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<PurchaseModel?> addTransaction(BuildContext context, {required final PurchaseModel purchase}) async {
    try {
      final TransactionDatabase transactionDatabase = TransactionDatabase.instance;
      final PurchaseDatabase purchaseDatabase = PurchaseDatabase.instance;
      final String _dateTime = DateTime.now().toIso8601String();

      final num _payable = num.parse(purchase.balance);
      final num _paid = num.parse(purchase.paid);
      final num _paying = num.parse(TransactionPurchasePayment.amountController.text.trim());
      final num _updatedPaid = _paid + _paying;
      final num _updatedBalance = _payable - _paying;

      final TransactionsModel _transaction = TransactionsModel(
        category: 'Purchase',
        transactionType: 'Expense',
        dateTime: _dateTime,
        amount: _paying.toString(),
        status: purchase.paymentStatus,
        description: 'Transaction ${purchase.id}',
        purchaseId: purchase.id,
      );

      //-------------------- Create Transactions --------------------
      transactionDatabase.createTransaction(_transaction);

      final PurchaseModel updatedPurchase = purchase.copyWith(
        paid: _updatedPaid.toString(),
        balance: _updatedBalance.toString(),
        paymentStatus: _updatedBalance == 0 ? 'Paid' : 'Partial',
      );

      //-------------------- Update Purchase with Purchases Return --------------------
      await purchaseDatabase.updatePurchaseByPurchaseId(purchase: updatedPurchase);
      kSnackBar(context: context, content: 'Transaction added successfully', success: true);

      return updatedPurchase;
    } catch (e) {
      log(e.toString());
      kSnackBar(context: context, content: 'Something went wrong. Please try again', error: true);
      return null;
    }
  }
}
