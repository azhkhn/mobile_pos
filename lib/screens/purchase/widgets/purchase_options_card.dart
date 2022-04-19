import 'package:flutter/material.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../core/utils/text/converters.dart';

class PurchaseOptionsCard extends StatelessWidget {
  const PurchaseOptionsCard({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  final String title;
  final num amount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(colors: [mainColor, Colors.teal]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: kButtonTextWhite,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
            kHeight5,
            FittedBox(
              child: Text(
                Converter.currency.format(amount),
                textAlign: TextAlign.center,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: const TextStyle(
                  color: kButtonTextWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
