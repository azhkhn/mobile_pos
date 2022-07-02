import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  AppBarWidget({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);
  final String title;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      // elevation: 0,
      // titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      title: FittedBox(
        child: Text(
          title,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
