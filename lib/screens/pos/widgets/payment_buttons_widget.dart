import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

class PaymentButtonsWidget extends StatelessWidget {
  const PaymentButtonsWidget({
    Key? key,
    required Size screenSize,
  })  : _screenSize = screenSize,
        super(key: key);

  final Size _screenSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: _screenSize.width / 25,
          padding: const EdgeInsets.all(8),
          color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AutoSizeText('Total Payable',
                  minFontSize: 10,
                  style: TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
              AutoSizeText('270.71',
                  minFontSize: 10,
                  style: TextStyle(color: kWhite, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(5),
                  color: Colors.yellow[800],
                  child: const Center(
                    child: AutoSizeText(
                      'Credit Payment',
                      minFontSize: 10,
                      style:
                          TextStyle(color: kWhite, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(5),
                  color: Colors.green[800],
                  child: const Center(
                    child: AutoSizeText(
                      'Partial Payment',
                      minFontSize: 10,
                      style:
                          TextStyle(color: kWhite, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(5),
                  color: Colors.red[400],
                  child: const Center(
                    child: AutoSizeText(
                      'Cancel',
                      minFontSize: 10,
                      style:
                          TextStyle(color: kWhite, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: _screenSize.width / 25,
                child: MaterialButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(5),
                  color: Colors.green[300],
                  child: const Center(
                    child: AutoSizeText(
                      'Full Payment',
                      minFontSize: 10,
                      style:
                          TextStyle(color: kWhite, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
