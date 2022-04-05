import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';

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
      height: _screenSize.width / 20,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AutoSizeText(
                        'items',
                        style: TextStyle(fontSize: 10),
                        minFontSize: 8,
                      ),
                      kWidth5,
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ValueListenableBuilder(
                              valueListenable:
                                  SaleSideWidget.totalItemsNotifier,
                              builder: (context, totalItems, child) {
                                return AutoSizeText(
                                  '$totalItems',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                  minFontSize: 8,
                                );
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable:
                                  SaleSideWidget.totalQuantityNotifier,
                              builder: (context, totalQuantity, child) {
                                return AutoSizeText(
                                  '($totalQuantity)',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                  minFontSize: 8,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                kWidth20,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AutoSizeText(
                        'Total',
                        style: TextStyle(fontSize: 10),
                        minFontSize: 8,
                      ),
                      kWidth5,
                      Flexible(
                        child: ValueListenableBuilder(
                          valueListenable: SaleSideWidget.totalAmountNotifier,
                          builder: (context, totalAmount, child) {
                            return AutoSizeText(
                              '$totalAmount',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                              minFontSize: 8,
                            );
                          },
                        ),
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
                        style: TextStyle(fontSize: 10),
                        minFontSize: 8,
                      ),
                      kWidth5,
                      Flexible(
                        child: AutoSizeText(
                          '(0)0.00',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                          minFontSize: 8,
                        ),
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
                        style: TextStyle(fontSize: 10),
                        minFontSize: 8,
                      ),
                      kWidth5,
                      Flexible(
                        child: AutoSizeText(
                          '35.31',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                          minFontSize: 8,
                        ),
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
