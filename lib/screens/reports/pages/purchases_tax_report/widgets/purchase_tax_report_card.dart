import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';

class PurchaseTaxCardWidget extends StatelessWidget {
  const PurchaseTaxCardWidget({
    required this.index,
    required this.purchase,
    Key? key,
  }) : super(key: key);
  final int index;
  final PurchaseModel purchase;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
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
                          purchase.invoiceNumber!,
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
                          Converter.dateFormat.format(DateTime.parse(purchase.dateTime)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // kHeight5,
                  // Row(
                  //   children: [
                  //     const AutoSizeText(
                  //       'Supplier:  ',
                  //       overflow: TextOverflow.ellipsis,
                  //       style: kTextSalesCard,
                  //       maxLines: 1,
                  //       minFontSize: 10,
                  //       maxFontSize: 14,
                  //     ),
                  //     Expanded(
                  //       child: AutoSizeText(
                  //         purchase.supplierName,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: kTextBoldSalesCard,
                  //         maxLines: 1,
                  //         minFontSize: 10,
                  //         maxFontSize: 14,
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                          Converter.currency.format(num.parse(purchase.grantTotal)),
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
                        'Excluded:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Converter.currency.format(num.parse(purchase.subTotal)),
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
                        'VAT Amount:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          Converter.currency.format(num.parse(purchase.vatAmount)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // kHeight5,
                  // Row(
                  //   children: [
                  //     const AutoSizeText(
                  //       'Status:  ',
                  //       overflow: TextOverflow.ellipsis,
                  //       style: kTextSalesCard,
                  //       maxLines: 1,
                  //       minFontSize: 10,
                  //       maxFontSize: 14,
                  //     ),
                  //     Expanded(
                  //       child: purchase.paymentStatus != 'Returned'
                  //           ? AutoSizeText(
                  //               purchase.paymentStatus,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: TextStyle(
                  //                   fontSize: 12,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: purchase.paymentStatus == 'Paid'
                  //                       ? kGreen
                  //                       : purchase.paymentStatus == 'Partial'
                  //                           ? kOrange
                  //                           : purchase.paymentStatus == 'Credit'
                  //                               ? kRed
                  //                               : kRed),
                  //               maxLines: 1,
                  //               minFontSize: 10,
                  //               maxFontSize: 14,
                  //             )
                  //           : Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                  //               Icon(Icons.restore_outlined, color: kRed, size: 18),
                  //               kWidth2,
                  //               AutoSizeText(
                  //                 'Returned',
                  //                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kRed),
                  //                 maxLines: 1,
                  //                 minFontSize: 10,
                  //                 maxFontSize: 14,
                  //               ),
                  //             ]),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
