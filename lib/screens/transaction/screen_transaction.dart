import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
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

                CustomMaterialBtton(onPressed: () {}, buttonText: 'Submit')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
