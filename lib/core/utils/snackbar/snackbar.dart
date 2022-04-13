import 'package:flutter/material.dart';

import '../../constant/sizes.dart';

//========== Show SnackBar ==========
void kSnackBar(
    {required BuildContext context,
    required String content,
    Color? color,
    Widget? icon}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon ?? const Text(''),
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
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
