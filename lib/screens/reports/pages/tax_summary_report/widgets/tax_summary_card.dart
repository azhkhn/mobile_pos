import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';

class TaxSummaryCard extends StatelessWidget {
  const TaxSummaryCard({
    Key? key,
    required this.title,
    required this.totalAmount,
    this.excludeAmount,
    required this.vatAmount,
    this.color,
  }) : super(key: key);

  final String title;
  final num totalAmount;
  final num? excludeAmount;
  final num vatAmount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: color ?? kBlueGrey,
      child: ListTile(
        dense: true,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color ?? kBlueGrey,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            decorationStyle: TextDecorationStyle.dashed,
            decoration: TextDecoration.underline,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            kHeight5,
            RichText(
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Total Amount:  ',
                    style: kText12Lite,
                  ),
                  TextSpan(
                    text: Converter.currency.format(totalAmount),
                    style: kTextSalesCard,
                  ),
                ],
              ),
            ),
            kHeight5,
            if (excludeAmount != null)
              RichText(
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Exluding VAT:  ',
                      style: kText12Lite,
                    ),
                    TextSpan(
                      text: Converter.currency.format(excludeAmount),
                      style: kTextSalesCard,
                    ),
                  ],
                ),
              ),
            if (excludeAmount != null) kHeight5,
            RichText(
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: 'VAT Amount:  ',
                    style: kText12Lite,
                  ),
                  TextSpan(
                    text: Converter.currency.format(vatAmount),
                    style: kTextSalesCard,
                  ),
                ],
              ),
            ),
            kHeight5,
          ],
        ),
      ),
    );
  }
}
