import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/screens/home/widgets/home_drawer.dart';
import 'package:shop_ez/screens/home/widgets/home_grid.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);
  late Size _screenSize;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: mainColor,
          child: const HomeDrawer(),
        ),
      ),
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Image(
            image: AssetImage('assets/images/hamburger.png'),
            height: 24,
            width: 24,
          ),
        ),
      ),
      body: Container(
        width: _screenSize.width,
        height: _screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/home.jpg'),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: _screenSize.height / 6),
          child: GridView.count(
            padding: const EdgeInsets.all(25),
            crossAxisCount: 2,
            mainAxisSpacing: _screenSize.width / 20,
            crossAxisSpacing: _screenSize.width / 20,
            children: List.generate(
              8,
              (index) => HomeGrid(index: index),
            ),
          ),
        ),
      ),
    );
  }
}
