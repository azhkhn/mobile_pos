import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';

class CustomMaterialBtton extends StatelessWidget {
  const CustomMaterialBtton({
    required this.onPressed,
    required this.buttonText,
    this.icon,
    this.fontSize = 14,
    this.textColor,
    this.buttonColor,
    this.fittedText = false,
    this.minWidth = double.infinity,
    this.padding,
    Key? key,
  }) : super(key: key);
  final String buttonText;
  final Widget? icon;
  final double fontSize;
  final Color? textColor;
  final Color? buttonColor;
  final double minWidth;
  final Function() onPressed;
  final bool fittedText;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: padding,
      minWidth: minWidth,
      onPressed: onPressed,
      child: fittedText
          ? FittedBox(
              child: Text(buttonText,
                  style: TextStyle(
                    color: textColor ?? kButtonTextWhite,
                  )))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: TextStyle(color: textColor ?? kButtonTextWhite, fontSize: fontSize),
                ),
                icon != null ? kWidth10 : kNone,
                icon != null ? icon! : kNone,
              ],
            ),
      color: buttonColor ?? kButtonColor,
    );
  }
}
