import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/payment_details_table_widget.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/quick_cash_widget.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_button_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import '../../../core/constant/sizes.dart';
import 'widgets/payment_type_widget.dart';

class PartialPayment extends ConsumerWidget {
  const PartialPayment({
    Key? key,
    required this.paymentDetails,
    this.purchase = false,
    this.isVertical = false,
  }) : super(key: key);

  final Map paymentDetails;
  final bool purchase;
  final bool isVertical;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('isVetical == $isVertical');
    final Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: isVertical
                ? EdgeInsets.symmetric(vertical: _screenSize.height * .01, horizontal: _screenSize.width * .015)
                : EdgeInsets.symmetric(vertical: _screenSize.width * .02, horizontal: _screenSize.width * .03),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _screenSize.width * .015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //==================== Quick Cash Widget ====================
                      SizedBox(
                        width: isVertical ? _screenSize.width / 1.0 : _screenSize.width / 1.3,
                        child: QuickCashWidget(
                          totalPayable: paymentDetails['totalPayable'],
                          isVertical: isVertical,
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
                      final _formState = PaymentTypeWidget.formKey.currentState!;
                      if (_formState.validate()) {
                        final String _paid = PaymentTypeWidget.amountController.text.toString();

                        final String _balance = PaymentDetailsTableWidget.balanceNotifier.value.toString();
                        final String _totalPayable = paymentDetails['totalPayable'].toString();
                        final String _paymentStatus = _balance == '0.0'
                            ? 'Paid'
                            : _balance == _totalPayable
                                ? 'Credit'
                                : 'Partial';

                        log('Total Payable = $_totalPayable');
                        log('Balance = $_balance');
                        log('Payment Status = $_paymentStatus');

                        final String _paymentType = PaymentTypeWidget.payingByController!;

                        final String? _paymentNote =
                            PaymentTypeWidget.payingNoteController.text == '' ? null : PaymentTypeWidget.payingNoteController.text;
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text(
                                'Partial Payment',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              content: Text(purchase ? 'Do you want to add this purchase?' : 'Do you want to add this sale?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      SalesModel? salesModel;
                                      if (purchase) {
                                        //========== Purchase Payment ==========
                                        await const PurchaseButtonsWidget().addPurchase(context,
                                            argBalance: _balance,
                                            argPaymentStatus: _paymentStatus,
                                            argPaymentType: _paymentType,
                                            argPaid: _paid,
                                            argPurchaseNote: _paymentNote);
                                      } else {
                                        //========== Sale Payment ==========
                                        salesModel = await const PaymentButtonsWidget().addSale(
                                          context,
                                          ref,
                                          argBalance: _balance,
                                          argPaymentStatus: _paymentStatus,
                                          argPaymentType: _paymentType,
                                          argPaid: _paid,
                                          argSalesNote: _paymentNote,
                                        );
                                        Navigator.pop(context, salesModel);
                                      }

                                      PaymentTypeWidget.payingNoteController.clear();
                                      PaymentTypeWidget.amountController.clear();
                                      PaymentTypeWidget.payingByController = null;

                                      if (salesModel != null) {
                                        Navigator.pop(context, salesModel);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Accept')),
                              ],
                            );
                          },
                        );
                      } else {
                        kSnackBar(context: context, content: 'Please fill the required informations', error: true);
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
