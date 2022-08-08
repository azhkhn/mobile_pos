import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/text.dart';

import '../../constant/sizes.dart';

//========== Show SnackBar ==========
void kSnackBar({
  required BuildContext context,
  required String content,
  double? height,
  Color? color,
  Widget? icon,
  int? duration,
  bool? error = false,
  bool? success = false,
  bool? delete = false,
  bool? update = false,
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SizedBox(
        height: height,
        child: Row(
          children: [
            icon ?? const Text(''),
            icon == null
                ? error == true
                    ? const Icon(
                        Icons.error_outline,
                        color: kSnackBarIconColor,
                      )
                    : success == true
                        ? const Icon(
                            Icons.done,
                            color: kSnackBarIconColor,
                          )
                        : delete == true
                            ? const Icon(
                                Icons.delete,
                                color: kSnackBarIconColor,
                              )
                            : update == true
                                ? const Icon(
                                    Icons.update,
                                    color: kSnackBarIconColor,
                                  )
                                : kNone
                : kNone,
            kWidth5,
            Flexible(
              child: Text(
                content,
                softWrap: false,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: kText11sp,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: error == true
          ? kSnackBarDeleteColor
          : success == true
              ? kSnackBarSuccessColor
              : delete == true
                  ? kSnackBarDeleteColor
                  : update == true
                      ? kSnackBarUpdateColor
                      : color,
      duration: Duration(seconds: duration ?? 2),
      behavior: SnackBarBehavior.floating,
      action: action,
    ),
  );
}
