import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';

class SalesTaxCardWidget extends StatelessWidget {
  const SalesTaxCardWidget({
    required this.index,
    required this.sales,
    Key? key,
  }) : super(key: key);
  final int index;
  final SalesModel sales;

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
                          sales.invoiceNumber!,
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
                          Converter.dateFormat.format(DateTime.parse(sales.dateTime)),
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
                  //       'Customer:  ',
                  //       overflow: TextOverflow.ellipsis,
                  //       style: kTextSalesCard,
                  //       maxLines: 1,
                  //       minFontSize: 10,
                  //       maxFontSize: 14,
                  //     ),
                  //     Expanded(
                  //       child: AutoSizeText(
                  //         sales.customerName,
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
                          Converter.currency.format(num.parse(sales.grantTotal)),
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
                          Converter.currency.format(num.parse(sales.subTotal)),
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
                          Converter.currency.format(num.parse(sales.vatAmount)),
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
                  //       child: sales.paymentStatus != 'Returned'
                  //           ? AutoSizeText(
                  //               sales.paymentStatus,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: TextStyle(
                  //                   fontSize: 12,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: sales.paymentStatus == 'Paid'
                  //                       ? kGreen
                  //                       : sales.paymentStatus == 'Partial'
                  //                           ? kOrange
                  //                           : sales.paymentStatus == 'Credit'
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
