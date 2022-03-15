import 'package:flutter/material.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';

class ManageUsers extends StatelessWidget {
  const ManageUsers({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Manage Users',
        ),
        body: const BackgroundContainerWidget());
  }
}
