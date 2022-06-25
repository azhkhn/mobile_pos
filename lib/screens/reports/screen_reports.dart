import 'package:flutter/material.dart';
import 'package:shop_ez/screens/reports/widgets/reports_grid.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenReports extends StatelessWidget {
  const ScreenReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Reports'),
      body: SafeArea(
        child: ItemScreenPaddingWidget(
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(10, (index) => ReportsGrid(index: index)),
          ),
        ),
      ),
    );
  }
}
