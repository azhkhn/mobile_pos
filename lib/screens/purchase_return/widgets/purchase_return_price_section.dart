import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/purchase_return/widgets/purchase_return_side_widget.dart';

import '../../../core/utils/device/device.dart';
import '../../../core/utils/converters/converters.dart';

class PurchaseReturnPriceSectionWidget extends StatelessWidget {
  const PurchaseReturnPriceSectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = DeviceUtil.isTablet;
    final Size _screenSize = MediaQuery.of(context).size;
    return Container(
      height: _screenSize.width / 20,
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
                          AutoSizeText(
                            'Items',
                            style: TextStyle(fontSize: isTablet ? 12 : 10),
                            minFontSize: 10,
                          ),
                          kWidth5,
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: PurchaseReturnSideWidget.totalItemsNotifier,
                                  builder: (context, totalItems, child) {
                                    return AutoSizeText(
                                      '$totalItems',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10, fontWeight: FontWeight.bold),
                                      minFontSize: 10,
                                    );
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: PurchaseReturnSideWidget.totalQuantityNotifier,
                                  builder: (context, totalQuantity, child) {
                                    return Flexible(
                                      child: AutoSizeText(
                                        '($totalQuantity)',
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: isTablet ? 12 : 10, fontWeight: FontWeight.bold),
                                        minFontSize: 10,
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
                          AutoSizeText(
                            'Total',
                            style: TextStyle(fontSize: isTablet ? 12 : 10),
                            minFontSize: 10,
                          ),
                          kWidth5,
                          Flexible(
                            child: ValueListenableBuilder(
                              valueListenable: PurchaseReturnSideWidget.totalAmountNotifier,
                              builder: (context, totalAmount, child) {
                                return AutoSizeText(
                                  totalAmount == 0 ? '0' : Converter.currency.format(totalAmount),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: isTablet ? 12 : 10, fontWeight: FontWeight.bold),
                                  minFontSize: 10,
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
                          AutoSizeText(
                            'Discount',
                            style: TextStyle(fontSize: isTablet ? 12 : 10),
                            minFontSize: 10,
                          ),
                          kWidth5,
                          Flexible(
                            child: AutoSizeText(
                              '(0)0.00',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: isTablet ? 12 : 10, fontWeight: FontWeight.bold),
                              minFontSize: 10,
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
                          AutoSizeText(
                            'VAT',
                            style: TextStyle(fontSize: isTablet ? 12 : 10),
                            minFontSize: 10,
                          ),
                          kWidth5,
                          Flexible(
                            child: ValueListenableBuilder(
                              valueListenable: PurchaseReturnSideWidget.totalVatNotifier,
                              builder: (context, totalVAT, child) {
                                return AutoSizeText(
                                  totalVAT == 0 ? '0' : Converter.currency.format(totalVAT),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: isTablet ? 12 : 10, fontWeight: FontWeight.bold),
                                  minFontSize: 10,
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
