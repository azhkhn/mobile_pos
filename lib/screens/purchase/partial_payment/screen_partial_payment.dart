import 'package:flutter/material.dart';
import 'package:shop_ez/screens/purchase/partial_payment/widgets/payment_details_table_widget.dart';
import 'package:shop_ez/screens/purchase/partial_payment/widgets/quick_cash_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import '../../../core/constant/sizes.dart';
import 'widgets/payment_type_widget.dart';

class PartialPayment extends StatelessWidget {
  const PartialPayment({
    Key? key,
    required this.paymentDetails,
  }) : super(key: key);

  final Map paymentDetails;
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
                CustomMaterialBtton(onPressed: () {}, buttonText: 'Submit'),
                kHeight5,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
