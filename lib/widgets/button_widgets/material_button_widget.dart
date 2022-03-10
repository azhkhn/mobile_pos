import 'package:flutter/material.dart';

class CustomMaterialBtton extends StatelessWidget {
  const CustomMaterialBtton(
      {required this.buttonText,
      required this.textColor,
      required this.buttonColor,
      Key? key})
      : super(key: key);
  final String buttonText;
  final Color textColor;
  final Color buttonColor;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      onPressed: () {},
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
        ),
      ),
      color: buttonColor,
    );
  }
}
