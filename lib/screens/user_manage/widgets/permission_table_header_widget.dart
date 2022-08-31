import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';

import '../../../core/utils/device/device.dart';

class PermissionTableHeaderWidget extends StatelessWidget {
  const PermissionTableHeaderWidget({
    Key? key,
    this.isPurchase = false,
  }) : super(key: key);

  final bool isPurchase;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FractionColumnWidth(0.25),
        1: FractionColumnWidth(0.15),
        2: FractionColumnWidth(0.15),
        3: FractionColumnWidth(0.15),
        4: FractionColumnWidth(0.15),
        5: FractionColumnWidth(0.15),
      },
      border: TableBorder.all(width: 0.5, color: kWhite),
      children: [
        TableRow(children: [
          Container(
            color: kGreen,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: kGreen,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'View',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: kGreen,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Add',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: kGreen,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Edit',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: kGreen,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'Delete',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
          Container(
            color: kGreen,
            height: 30,
            alignment: Alignment.center,
            child: AutoSizeText(
              'All',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: DeviceUtil.isTablet ? 13 : 12, color: kWhite, fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 13,
            ),
          ),
        ]),
      ],
    );
  }
}
