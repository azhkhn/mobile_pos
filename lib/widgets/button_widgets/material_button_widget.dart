import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

class CustomMaterialBtton extends StatelessWidget {
  const CustomMaterialBtton({
    required this.onPressed,
    required this.buttonText,
    this.textColor,
    this.buttonColor,
    Key? key,
  }) : super(key: key);
  final String buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor ?? kButtonTextWhite,
        ),
      ),
      color: buttonColor ?? kButtonColor,
    );
  }
}
