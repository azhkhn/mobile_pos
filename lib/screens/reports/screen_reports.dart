import 'package:flutter/material.dart';
import 'package:mobile_pos/screens/reports/widgets/reports_grid.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';

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
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: List.generate(11, (index) => ReportsGrid(index: index)),
          ),
        ),
      ),
    );
  }
}
