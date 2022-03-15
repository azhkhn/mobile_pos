import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  AppBarWidget({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      elevation: 0,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
