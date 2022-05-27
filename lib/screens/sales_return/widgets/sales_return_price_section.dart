import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_side_widget.dart';

import '../../../core/utils/converters/converters.dart';

class SalesReturnPriceSectionWidget extends StatelessWidget {
  const SalesReturnPriceSectionWidget({
    Key? key,
    this.isVertical = false,
  }) : super(key: key);
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    return Container(
      height: isVertical ? _screenSize.height / 20 : _screenSize.width / 20,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items',
                            style: kItemsPriceStyle,
                          ),
                          kWidth5,
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: SalesReturnSideWidget.totalItemsNotifier,
                                  builder: (context, totalItems, child) {
                                    return Text(
                                      '$totalItems',
                                      overflow: TextOverflow.ellipsis,
                                      style: kItemsPriceStyleBold,
                                    );
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: SalesReturnSideWidget.totalQuantityNotifier,
                                  builder: (context, totalQuantity, child) {
                                    return Flexible(
                                      child: Text(
                                        '($totalQuantity)',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: kItemsPriceStyleBold,
                                      ),
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
                          Text(
                            'Total',
                            style: kItemsPriceStyle,
                          ),
                          kWidth5,
                          Flexible(
                            child: ValueListenableBuilder(
                              valueListenable: SalesReturnSideWidget.totalAmountNotifier,
                              builder: (context, totalAmount, child) {
                                return Text(
                                  totalAmount == 0 ? '0' : Converter.currency.format(totalAmount),
                                  overflow: TextOverflow.ellipsis,
                                  style: kItemsPriceStyleBold,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: kItemsPriceStyle,
                          ),
                          kWidth5,
                          Flexible(
                            child: Text(
                              '(0)0.00',
                              overflow: TextOverflow.ellipsis,
                              style: kItemsPriceStyleBold,
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
                          Text(
                            'VAT',
                            style: kItemsPriceStyle,
                          ),
                          kWidth5,
                          Flexible(
                            child: ValueListenableBuilder(
                              valueListenable: SalesReturnSideWidget.totalVatNotifier,
                              builder: (context, totalVAT, child) {
                                return Text(
                                  totalVAT == 0 ? '0' : Converter.currency.format(totalVAT),
                                  overflow: TextOverflow.ellipsis,
                                  style: kItemsPriceStyleBold,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
