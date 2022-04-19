import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

import '../../../core/utils/device/device.dart';

class StockTableHeader extends StatelessWidget {
  const StockTableHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FractionColumnWidth(0.25),
        1: FractionColumnWidth(0.20),
        2: FractionColumnWidth(0.20),
        3: FractionColumnWidth(0.20),
        4: FractionColumnWidth(0.15),
      },
      border: TableBorder.all(width: 0.5),
      children: [
        TableRow(children: [
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Category',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Cost',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Price',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Quantity',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: DeviceUtil.isTablet ? 13 : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
        ]),
      ],
    );
  }
}
