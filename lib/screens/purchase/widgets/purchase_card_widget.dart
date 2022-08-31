import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/constant/text.dart';
import '../../../core/utils/converters/converters.dart';
import '../../../model/purchase/purchase_model.dart';

class PurchaseCardWidget extends StatelessWidget {
  const PurchaseCardWidget({
    required this.index,
    required this.purchases,
    Key? key,
  }) : super(key: key);
  final int index;
  final PurchaseModel purchases;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: kPadding8,
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.start,
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AutoSizeText(
                        'No.  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          '${index + 1}',
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Invoice:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          purchases.invoiceNumber!,
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Date:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Converter.dateFormat.format(DateTime.parse(purchases.dateTime)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Supplier:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          purchases.supplierName,
                          overflow: TextOverflow.ellipsis,
                          style: kTextBoldSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            kWidth5,
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AutoSizeText(
                        'Amount:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Converter.currency.format(num.parse(purchases.grantTotal)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Paid:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Converter.currency.format(num.parse(purchases.paid)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Balance:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Converter.currency.format(num.parse(purchases.balance)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Status:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: purchases.paymentStatus != 'Returned'
                            ? AutoSizeText(
                                purchases.paymentStatus,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: purchases.paymentStatus == 'Paid'
                                        ? kGreen
                                        : purchases.paymentStatus == 'Partial'
                                            ? kOrange
                                            : purchases.paymentStatus == 'Credit'
                                                ? kRed
                                                : kRed),
                                maxLines: 1,
                                minFontSize: 10,
                                maxFontSize: 14,
                              )
                            : Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                                Icon(Icons.restore_outlined, color: kRed, size: 18),
                                kWidth2,
                                AutoSizeText(
                                  'Returned',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kRed),
                                  maxLines: 1,
                                  minFontSize: 10,
                                  maxFontSize: 14,
                                ),
                              ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
