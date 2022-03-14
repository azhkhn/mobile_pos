import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/user_database/user_db.dart';
import 'package:shop_ez/screens/home/widgets/home_drawer.dart';
import 'package:shop_ez/screens/home/widgets/home_grid.dart';
import 'package:shop_ez/widgets/floating_add_options.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({this.initialEntry, Key? key}) : super(key: key);
  final int? initialEntry;
  static late Size _screenSize;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    // UserDatabase.instance.getAllUsers();
    _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
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
          actions: [
            IconButton(
              onPressed: () async => await UserDatabase.instance.logout().then(
                    (_) => Navigator.pushReplacementNamed(context, routeLogin),
                  ),
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
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
                padding: EdgeInsets.all(_screenSize.width / 50),
                crossAxisCount: 3,
                mainAxisSpacing: _screenSize.width / 50,
                crossAxisSpacing: _screenSize.width / 50,
                children: List.generate(
                  9,
                  (index) => HomeGrid(
                    index: index,
                    screenSize: _screenSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingAddOptions(isDialOpen: isDialOpen),
      ),
    );
  }
}
