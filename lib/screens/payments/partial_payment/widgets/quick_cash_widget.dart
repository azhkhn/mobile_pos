import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/screens/payments/partial_payment/widgets/payment_type_widget.dart';

import '../../../../core/constant/sizes.dart';
import '../../../../widgets/button_widgets/material_button_widget.dart';

class QuickCashWidget extends StatelessWidget {
  const QuickCashWidget({
    required this.totalPayable,
    Key? key,
    this.isVertical = false,
  }) : super(key: key);

  final num totalPayable;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AutoSizeText(
          'Quick Cash',
          style: TextStyle(fontSize: 18, color: mainColor, fontWeight: FontWeight.bold),
        ),
        //========== Vertical User Interface ==========
        isVertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomMaterialBtton(
                          onPressed: () {
                            // PaymentTypeWidget.amountController.text = '$totalPayable';
                            PaymentTypeWidget.amountController.text = Converter.currency.format(totalPayable);
                            log('total payable == ' + Converter.currency.format(totalPayable));

                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged('$totalPayable');
                          },
                          buttonText: Converter.currency.format(totalPayable),
                          fittedText: true,
                          buttonColor: Colors.indigo[400],
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.text = totalPayable > 10 ? '10' : '$totalPayable';
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged(totalPayable > 10 ? '10' : '$totalPayable');
                          },
                          buttonText: '10',
                          buttonColor: mainColor,
                          fittedText: true,
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.text = totalPayable > 20 ? '20' : '$totalPayable';
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged(totalPayable > 20 ? '20' : '$totalPayable');
                          },
                          buttonText: '20',
                          buttonColor: mainColor,
                          fittedText: true,
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.text = totalPayable > 50 ? '50' : '$totalPayable';
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged(totalPayable > 50 ? '50' : '$totalPayable');
                          },
                          buttonText: '50',
                          buttonColor: mainColor,
                          fittedText: true,
                        ),
                      ),
                      kWidth5,
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.text = totalPayable > 100 ? '100' : '$totalPayable';
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged(totalPayable > 100 ? '100' : '$totalPayable');
                          },
                          buttonText: '100',
                          buttonColor: mainColor,
                          fittedText: true,
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        flex: 1,
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.text = totalPayable > 500 ? '500' : '$totalPayable';
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged(totalPayable > 500 ? '500' : '$totalPayable');
                          },
                          buttonText: '500',
                          buttonColor: mainColor,
                          fittedText: true,
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        flex: 1,
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.text = totalPayable > 1000 ? '1000' : '$totalPayable';
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged(totalPayable > 1000 ? '1000' : '$totalPayable');
                          },
                          buttonText: '1000',
                          buttonColor: mainColor,
                          fittedText: true,
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        flex: 1,
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.text = totalPayable > 5000 ? '5000' : '$totalPayable';
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged(totalPayable > 5000 ? '5000' : '$totalPayable');
                          },
                          buttonText: '5000',
                          buttonColor: mainColor,
                          fittedText: true,
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        flex: 1,
                        child: CustomMaterialBtton(
                          onPressed: () {
                            PaymentTypeWidget.amountController.clear();
                            return PaymentTypeWidget(
                              totalPayable: totalPayable,
                            ).amountChanged('0');
                          },
                          buttonText: 'CLEAR',
                          fittedText: true,
                          buttonColor: Colors.red[300],
                        ),
                      ),
                    ],
                  )
                ],
              )
            //========== Horizontal User Interface ==========
            : Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        // PaymentTypeWidget.amountController.text = '$totalPayable';
                        PaymentTypeWidget.amountController.text = Converter.currency.format(totalPayable);
                        log('total payable == ' + Converter.currency.format(totalPayable));
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged('$totalPayable');
                      },
                      buttonText: Converter.currency.format(totalPayable),
                      fittedText: true,
                      buttonColor: Colors.indigo[400],
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 3,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.text = totalPayable > 10 ? '10' : '$totalPayable';
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged(totalPayable > 10 ? '10' : '$totalPayable');
                      },
                      buttonText: '10',
                      buttonColor: mainColor,
                      fittedText: true,
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 3,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.text = totalPayable > 20 ? '20' : '$totalPayable';
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged(totalPayable > 20 ? '20' : '$totalPayable');
                      },
                      buttonText: '20',
                      buttonColor: mainColor,
                      fittedText: true,
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 3,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.text = totalPayable > 50 ? '50' : '$totalPayable';
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged(totalPayable > 50 ? '50' : '$totalPayable');
                      },
                      buttonText: '50',
                      buttonColor: mainColor,
                      fittedText: true,
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 4,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.text = totalPayable > 100 ? '100' : '$totalPayable';
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged(totalPayable > 100 ? '100' : '$totalPayable');
                      },
                      buttonText: '100',
                      buttonColor: mainColor,
                      fittedText: true,
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 4,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.text = totalPayable > 500 ? '500' : '$totalPayable';
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged(totalPayable > 500 ? '500' : '$totalPayable');
                      },
                      buttonText: '500',
                      buttonColor: mainColor,
                      fittedText: true,
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 4,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.text = totalPayable > 1000 ? '1000' : '$totalPayable';
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged(totalPayable > 1000 ? '1000' : '$totalPayable');
                      },
                      buttonText: '1000',
                      buttonColor: mainColor,
                      fittedText: true,
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 4,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.text = totalPayable > 5000 ? '5000' : '$totalPayable';
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged(totalPayable > 5000 ? '5000' : '$totalPayable');
                      },
                      buttonText: '5000',
                      buttonColor: mainColor,
                      fittedText: true,
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    flex: 4,
                    child: CustomMaterialBtton(
                      onPressed: () {
                        PaymentTypeWidget.amountController.clear();
                        return PaymentTypeWidget(
                          totalPayable: totalPayable,
                        ).amountChanged('0');
                      },
                      buttonText: 'CLEAR',
                      fittedText: true,
                      buttonColor: Colors.red[300],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
