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
            child: const Center(
              child: Text('Product',
                  style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            child: const Center(
              child: Text(
                'Price',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            child: const Center(
              child: Text(
                'Qty',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            height: 30,
            child: const Center(
              child: Text(
                'Subtotal',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
              color: Colors.blue,
              height: 30,
              child: const Center(
                  child: Icon(
                Icons.delete,
                size: 18,
                color: kWhite,
              )))
        ]),
      ],
    );
  }
}
