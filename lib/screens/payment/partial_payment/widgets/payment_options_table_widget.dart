import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import '../../../../core/utils/device/device.dart';

class PaymentOptionsTableWidget extends StatelessWidget {
  const PaymentOptionsTableWidget({
    Key? key,
    required this.totalPayable,
    required this.totalItems,
    required this.borderTop,
    this.firstRow = false,
  }) : super(key: key);

  final double borderTop;
  final bool firstRow;
  final num totalPayable;
  final num totalItems;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Table(
        columnWidths: const {
          0: FractionColumnWidth(0.25),
          1: FractionColumnWidth(0.25),
          2: FractionColumnWidth(0.25),
          3: FractionColumnWidth(0.25),
        },
        // border: TableBorder.all(width: 0.5, color: kBlack),
        border: TableBorder(
          top: BorderSide(width: borderTop, color: kBorderColor),
          bottom: const BorderSide(width: 0.5, color: kBorderColor),
          right: const BorderSide(width: 0.5, color: kBorderColor),
          left: const BorderSide(width: 0.5, color: kBorderColor),
          horizontalInside: const BorderSide(
              width: 0.5, color: kBorderColor, style: BorderStyle.solid),
          verticalInside: const BorderSide(
              width: 0.5, color: kBorderColor, style: BorderStyle.solid),
        ),
        children: [
          TableRow(children: [
            Container(
              height: 30,
              alignment: Alignment.center,
              child: AutoSizeText(
                firstRow ? 'Total Items' : 'Total Paying',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kBlack,
                ),
                minFontSize: 12,
                maxFontSize: 13,
              ),
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              child: AutoSizeText(
                firstRow ? '$totalItems' : '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kBlack,
                ),
                minFontSize: 12,
                maxFontSize: 13,
              ),
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              child: AutoSizeText(
                firstRow ? 'Total Payable' : 'Balance',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kBlack,
                ),
                minFontSize: 12,
                maxFontSize: 13,
              ),
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              child: AutoSizeText(
                firstRow ? Converter.currency.format(totalPayable) : '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kBlack,
                ),
                minFontSize: 12,
                maxFontSize: 13,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
