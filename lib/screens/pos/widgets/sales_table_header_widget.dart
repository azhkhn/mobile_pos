import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

import '../../../core/utils/device/device.dart';

class SalesTableHeaderWidget extends StatelessWidget {
  const SalesTableHeaderWidget({
    Key? key,
    this.isPurchase = false,
  }) : super(key: key);

  final bool isPurchase;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FractionColumnWidth(0.30),
        1: FractionColumnWidth(0.23),
        2: FractionColumnWidth(0.12),
        3: FractionColumnWidth(0.23),
        4: FractionColumnWidth(0.12),
      },
      border: TableBorder.all(width: 0.5),
      children: [
        TableRow(children: [
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Items',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              !isPurchase ? 'Price' : 'Cost',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Qty',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Subtotal',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
              color: Colors.blue,
              height: 30,
              child: const Center(
                  child: Icon(
                Icons.delete,
                size: 16,
                color: kWhite,
              )))
        ]),
      ],
    );
  }
}
