import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';

class ManageUsers extends StatelessWidget {
  ManageUsers({Key? key}) : super(key: key);
  late Size _screenSize;
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
      ),
      body: Container(
        width: _screenSize.width,
        height: _screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/home_items.jpg',
            ),
          ),
        ),
      ),
    );
  }
}
