import 'package:flutter/material.dart';

import '../../../core/constant/colors.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _screenSize.width * 0.07,
        vertical: _screenSize.height * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            elevation: 5,
            color: Colors.blue[300],
            child: SizedBox(
              width: _screenSize.width / 4,
              height: _screenSize.width / 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Today Cash',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kButtonTextWhite,
                        fontSize: _screenSize.width * 0.025),
                  ),
                  // kHeight5,
                  Text(
                    '13840',
                    textAlign: TextAlign.center,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: kButtonTextWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: _screenSize.width * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.green[300],
            child: SizedBox(
              width: _screenSize.width / 4,
              height: _screenSize.width / 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Cash',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kButtonTextWhite,
                        fontSize: _screenSize.width * 0.025),
                  ),
                  // kHeight5,
                  Text(
                    '1856750',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kButtonTextWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: _screenSize.width * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.red[300],
            child: SizedBox(
              width: _screenSize.width / 4,
              height: _screenSize.width / 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Today Sale',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kButtonTextWhite,
                        fontSize: _screenSize.width * 0.025),
                  ),
                  // kHeight5,
                  Text(
                    '160',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kButtonTextWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: _screenSize.width * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
