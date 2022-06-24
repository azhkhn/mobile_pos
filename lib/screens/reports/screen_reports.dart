import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';

class ScreenReports extends StatelessWidget {
  const ScreenReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Reports'),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
