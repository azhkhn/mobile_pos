import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/utils/text/converters.dart';

import '../../../../core/constant/sizes.dart';
import '../../../../core/constant/text.dart';
import '../../../../widgets/button_widgets/material_button_widget.dart';

class QuickCashWidget extends StatelessWidget {
  const QuickCashWidget({
    required this.totalPayable,
    Key? key,
  }) : super(key: key);

  final num totalPayable;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AutoSizeText(
          'Quick Cash',
          style: kText16,
        ),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: Converter.currency.format(totalPayable),
                fittedText: true,
                buttonColor: Colors.indigo[400],
              ),
            ),
            kWidth5,
            Expanded(
              flex: 3,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: '10',
                buttonColor: mainColor,
                fittedText: true,
              ),
            ),
            kWidth5,
            Expanded(
              flex: 3,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: '20',
                buttonColor: mainColor,
                fittedText: true,
              ),
            ),
            kWidth5,
            Expanded(
              flex: 3,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: '50',
                buttonColor: mainColor,
                fittedText: true,
              ),
            ),
            kWidth5,
            Expanded(
              flex: 4,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: '100',
                buttonColor: mainColor,
                fittedText: true,
              ),
            ),
            kWidth5,
            Expanded(
              flex: 4,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: '500',
                buttonColor: mainColor,
                fittedText: true,
              ),
            ),
            kWidth5,
            Expanded(
              flex: 4,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: '1000',
                buttonColor: mainColor,
                fittedText: true,
              ),
            ),
            kWidth5,
            Expanded(
              flex: 4,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: '5000',
                buttonColor: mainColor,
                fittedText: true,
              ),
            ),
            kWidth5,
            Expanded(
              flex: 4,
              child: CustomMaterialBtton(
                onPressed: () {},
                buttonText: 'CLEAR',
                fittedText: true,
                buttonColor: Colors.red[300],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
