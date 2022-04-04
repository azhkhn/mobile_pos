import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

class SalesTableHeaderWidget extends StatelessWidget {
  const SalesTableHeaderWidget({
    Key? key,
  }) : super(key: key);

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
            child: const AutoSizeText('Product',
                minFontSize: 8,
                maxFontSize: 20,
                style: TextStyle(
                  color: kWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: const AutoSizeText('Price',
                minFontSize: 8,
                maxFontSize: 20,
                style: TextStyle(
                  color: kWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: const AutoSizeText('Qty',
                minFontSize: 8,
                maxFontSize: 20,
                style: TextStyle(
                  color: kWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            alignment: Alignment.center,
            child: const AutoSizeText('Subtotal',
                minFontSize: 8,
                maxFontSize: 20,
                style: TextStyle(
                  color: kWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                )),
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
