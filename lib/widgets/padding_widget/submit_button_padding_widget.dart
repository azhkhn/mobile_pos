import 'package:flutter/material.dart';

class SubmitButtonPaddingWidget extends StatelessWidget {
  const SubmitButtonPaddingWidget({Key? key, required this.child})
      : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _screenSize.width / 10),
      child: child,
    );
  }
}
