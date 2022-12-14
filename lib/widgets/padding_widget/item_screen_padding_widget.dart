import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';

class ItemScreenPaddingWidget extends StatelessWidget {
  const ItemScreenPaddingWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding10,
      child: child,
    );
  }
}


// class ItemScreenPaddingWidget extends StatelessWidget {
//   const ItemScreenPaddingWidget({
//     Key? key,
//     required this.child,
//   }) : super(key: key);
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     final _screenSize = MediaQuery.of(context).size;
//     return Padding(
//       padding: EdgeInsets.only(
//           top: _screenSize.height / 15,
//           right: _screenSize.width * 0.05,
//           left: _screenSize.width * 0.05),
//       child: child,
//     );
//   }
// }
