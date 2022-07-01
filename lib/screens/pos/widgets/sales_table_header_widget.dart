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
    final bool isSmall = DeviceUtil.isSmall;
    final bool isTablet = DeviceUtil.isTablet;
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
            height: isSmall ? 20 : 25,
            alignment: Alignment.center,
            child: Text(
              'Items',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: isSmall
                      ? 10
                      : isTablet
                          ? 13
                          : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.blue,
            height: isSmall ? 20 : 25,
            alignment: Alignment.center,
            child: Text(
              !isPurchase ? 'Price' : 'Cost',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: isSmall
                      ? 10
                      : isTablet
                          ? 13
                          : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.blue,
            height: isSmall ? 20 : 25,
            alignment: Alignment.center,
            child: Text(
              'Qty',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: isSmall
                      ? 10
                      : isTablet
                          ? 13
                          : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.blue,
            height: isSmall ? 20 : 25,
            alignment: Alignment.center,
            child: Text(
              'Subtotal',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: isSmall
                      ? 10
                      : isTablet
                          ? 13
                          : 12,
                  color: kWhite,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              color: Colors.blue,
              height: isSmall ? 20 : 25,
              child: Center(
                  child: Icon(
                Icons.delete,
                size: isSmall ? 12 : 16,
                color: kWhite,
              )))
        ]),
      ],
    );
  }
}
