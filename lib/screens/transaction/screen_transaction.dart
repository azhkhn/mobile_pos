import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/transaction/widgets/transaction_details_table_widget.dart';
import 'package:shop_ez/screens/transaction/widgets/transaction_payment_widget.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key, required this.salesModel}) : super(key: key);

  final SalesModel salesModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Transaction'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //==================== Payment Type Widget ====================
                TransactionPaymentWidget(
                  totalPayable: num.parse(salesModel.balance),
                ),
                kHeight10,

                //==================== Transaction Details Table Widget ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      TransactionDetailsTableWidget(borderTop: 0.5, firstRow: true, sale: salesModel),
                      TransactionDetailsTableWidget(borderTop: 0, firstRow: false, sale: salesModel),
                    ],
                  ),
                ),

                kHeight15,

                CustomMaterialBtton(
                    onPressed: () async {
                      final _formState = TransactionPaymentWidget.formKey.currentState!;
                      if (_formState.validate()) {
                        final SalesModel? updatedSale = await addTransaction(context, sale: salesModel);
                        if (updatedSale != null) {
                          _formState.reset();
                          TransactionDetailsTableWidget.balanceNotifier.value = 0;
                          TransactionDetailsTableWidget.totalPayingNotifier.value = 0;
                          Navigator.pop(context, updatedSale);
                        }
                      } else {
                        kSnackBar(context: context, content: 'Please fill the required informations', error: true);
                      }
                    },
                    buttonText: 'Submit')
              ],
            ),
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
      final num _paying = num.parse(TransactionPaymentWidget.amountController.text.trim());
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

      final updatedSale = sale.copyWith(
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
