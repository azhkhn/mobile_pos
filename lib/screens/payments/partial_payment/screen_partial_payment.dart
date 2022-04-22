import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/payment_details_table_widget.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/quick_cash_widget.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_button_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import '../../../core/constant/sizes.dart';
import 'widgets/payment_type_widget.dart';

class PartialPayment extends StatelessWidget {
  const PartialPayment({
    Key? key,
    required this.paymentDetails,
    this.purchase = false,
  }) : super(key: key);

  final Map paymentDetails;
  final bool purchase;
  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _screenSize.width * .02,
                horizontal: _screenSize.width * .03),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _screenSize.width * .015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //==================== Quick Cash Widget ====================
                      SizedBox(
                        width: _screenSize.width / 1.3,
                        child: QuickCashWidget(
                          totalPayable: paymentDetails['totalPayable'],
                        ),
                      ),
                      kHeight20,

                      //==================== Payment Type Widget ====================
                      PaymentTypeWidget(
                        totalPayable: paymentDetails['totalPayable'],
                      ),
                      kHeight15,

                      //==================== Payment Details Table Widget ====================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Column(
                          children: [
                            PaymentDetailsTableWidget(
                              borderTop: 0.5,
                              firstRow: true,
                              totalItems: paymentDetails['totalItems'],
                              totalPayable: paymentDetails['totalPayable'],
                            ),
                            PaymentDetailsTableWidget(
                              borderTop: 0,
                              totalItems: paymentDetails['totalItems'],
                              totalPayable: paymentDetails['totalPayable'],
                            ),
                          ],
                        ),
                      ),

                      kHeight10,
                    ],
                  ),
                ),
                CustomMaterialBtton(
                    onPressed: () {
                      final _formState =
                          PaymentTypeWidget.formKey.currentState!;
                      if (_formState.validate()) {
                        final String _paid =
                            PaymentTypeWidget.amountController.text.toString();

                        final String _balance = PaymentDetailsTableWidget
                            .balanceNotifier.value
                            .toString();

                        final String _paymentStatus =
                            _balance == '0.0' ? 'Paid' : 'Partial';

                        log(_balance);

                        final String _paymentType =
                            PaymentTypeWidget.payingByController!;

                        final String? _paymentNote =
                            PaymentTypeWidget.payingNoteController.text == ''
                                ? null
                                : PaymentTypeWidget.payingNoteController.text;
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text(
                                'Purchase',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              content: const Text(
                                  'Do you want to add this purchase?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () {
                                      if (purchase) {
                                        //========== Purchase Payment ==========
                                        const PurchaseButtonsWidget()
                                            .addPurchase(context,
                                                argBalance: _balance,
                                                argPaymentStatus:
                                                    _paymentStatus,
                                                argPaymentType: _paymentType,
                                                argPaid: _paid,
                                                argPurchaseNote: _paymentNote);
                                      } else {
                                        //========== Sale Payment ==========
                                        const PaymentButtonsWidget().addSale(
                                          context,
                                          argBalance: _balance,
                                          argPaymentStatus: _paymentStatus,
                                          argPaymentType: _paymentType,
                                          argPaid: _paid,
                                          argSalesNote: _paymentNote,
                                        );
                                      }

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Accept')),
                              ],
                            );
                          },
                        );
                      }
                    },
                    buttonText: 'Submit'),
                kHeight5,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
