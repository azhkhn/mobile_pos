import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

import '../../constant/sizes.dart';

//========== Show SnackBar ==========
void kSnackBar({
  required BuildContext context,
  required String content,
  Color? color,
  Widget? icon,
  bool? error = false,
  bool? success = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon ?? const Text(''),
          error == true
              ? const Icon(
                  Icons.error_outline,
                  color: kSnackBarIconColor,
                )
              : const SizedBox(),
          success == true
              ? const Icon(
                  Icons.done,
                  color: kSnackBarIconColor,
                )
              : const SizedBox(),
          kWidth5,
          Flexible(
            child: Text(
              content,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: error == true
          ? kSnackBarErrorColor
          : success == true
              ? kSnackBarSuccessColor
              : color,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
