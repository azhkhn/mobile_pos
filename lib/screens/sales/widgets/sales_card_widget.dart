import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/constant/text.dart';
import '../../../core/utils/converters/converters.dart';
import '../../../model/sales/sales_model.dart';

class SalesCardWidget extends StatelessWidget {
  const SalesCardWidget({
    required this.index,
    required this.sales,
    Key? key,
  }) : super(key: key);
  final int index;
  final List<SalesModel> sales;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          sales[index].invoiceNumber!,
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
                          Converter.dateFormat.format(DateTime.parse(sales[index].dateTime)),
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
                        'Customer:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          sales[index].customerName,
                          overflow: TextOverflow.ellipsis,
                          style: kBoldTextSalesCard,
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
                          Converter.currency.format(num.parse(sales[index].grantTotal)),
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
                          Converter.currency.format(num.parse(sales[index].paid)),
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
                          Converter.currency.format(num.parse(sales[index].balance)),
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
                        child: AutoSizeText(
                          sales[index].paymentStatus,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: sales[index].paymentStatus == 'Paid'
                                  ? Colors.green
                                  : sales[index].paymentStatus == 'Partial'
                                      ? Colors.orange
                                      : Colors.red),
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
          ],
        ),
      ),
    );
  }
}
