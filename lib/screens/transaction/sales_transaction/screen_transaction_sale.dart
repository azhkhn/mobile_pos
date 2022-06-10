import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/transaction/sales_transaction/widgets/transaction_sale_details_table.dart';
import 'package:shop_ez/screens/transaction/sales_transaction/widgets/transaction_sale_payment_widget.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';

class TransactionScreenSale extends StatelessWidget {
  const TransactionScreenSale({Key? key, required this.salesModel}) : super(key: key);

  final SalesModel salesModel;

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
              TransactionSalePayment(
                totalPayable: num.parse(salesModel.balance),
              ),
              kHeight10,

              //==================== Transaction Details Table Widget ====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  children: [
                    TransactionSaleDetailsTable(borderTop: 0.5, firstRow: true, sale: salesModel),
                    TransactionSaleDetailsTable(borderTop: 0, firstRow: false, sale: salesModel),
                  ],
                ),
              ),

              kHeight15,

              CustomMaterialBtton(
                  onPressed: () async {
                    final _formState = TransactionSalePayment.formKey.currentState!;
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
                            final SalesModel? updatedSale = await addTransaction(context, sale: salesModel);
                            if (updatedSale != null) {
                              _formState.reset();
                              TransactionSaleDetailsTable.balanceNotifier.value = 0;
                              TransactionSaleDetailsTable.totalPayingNotifier.value = 0;
                              Navigator.pop(context, updatedSale);
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
                future: TransactionDatabase.instance.getAllTransactionsBySalesId(salesModel.id!),
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
                                    ),
                                  );
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

  Future<SalesModel?> addTransaction(BuildContext context, {required final SalesModel sale}) async {
    try {
      final TransactionDatabase transactionDatabase = TransactionDatabase.instance;
      final SalesDatabase salesDatabase = SalesDatabase.instance;
      final String _dateTime = DateTime.now().toIso8601String();

      final num _payable = num.parse(sale.balance);
      final num _paid = num.parse(sale.paid);
      final num _paying = num.parse(TransactionSalePayment.amountController.text.trim());
      final num _updatedPaid = _paid + _paying;
      final num _updatedBalance = _payable - _paying;

      final TransactionsModel _transaction = TransactionsModel(
        category: 'Sales',
        transactionType: 'Income',
        dateTime: _dateTime,
        amount: _paying.toString(),
        status: sale.paymentStatus,
        description: 'Transaction ${sale.id}',
        salesId: sale.id,
      );

      //-------------------- Create Transactions --------------------
      transactionDatabase.createTransaction(_transaction);

      final SalesModel updatedSale = sale.copyWith(
        paid: _updatedPaid.toString(),
        balance: _updatedBalance.toString(),
        paymentStatus: _updatedBalance == 0 ? 'Paid' : 'Partial',
      );

      //-------------------- Update Sale with Sales Return --------------------
      await salesDatabase.updateSaleBySalesId(sale: updatedSale);
      kSnackBar(context: context, content: 'Transaction added successfully', success: true);

      return updatedSale;
    } catch (e) {
      log(e.toString());
      kSnackBar(context: context, content: 'Something went wrong. Please try again', error: true);
      return null;
    }
  }
}
