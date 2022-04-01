import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';

class PriceSectionWidget extends StatelessWidget {
  const PriceSectionWidget({
    Key? key,
    required Size screenSize,
  })  : _screenSize = screenSize,
        super(key: key);

  final Size _screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _screenSize.width / 18,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AutoSizeText(
                        'items',
                        minFontSize: 10,
                      ),
                      AutoSizeText(
                        '2(2)',
                        minFontSize: 10,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                kWidth20,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AutoSizeText(
                        'Total',
                        minFontSize: 10,
                      ),
                      AutoSizeText(
                        '234.5',
                        minFontSize: 10,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AutoSizeText(
                        'Discount',
                        minFontSize: 10,
                      ),
                      AutoSizeText(
                        '(0)0.00',
                        minFontSize: 10,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                kWidth20,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AutoSizeText(
                        'VAT',
                        minFontSize: 10,
                      ),
                      AutoSizeText(
                        '35.31',
                        minFontSize: 10,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
