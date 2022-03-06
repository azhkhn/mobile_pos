import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/user_database.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    afterSplash();
    super.initState();
  }

  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            mainColor,
            gradiantColor,
          ],
        )),
        child: Center(
          child: Image.asset(
            'assets/images/pos.png',
            width: _size.width / 2,
            height: _size.width / 2,
          ),
        ),
      ),
    );
  }

  Future<void> afterSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    final isLogin = await UserDatabase.instance.isLogin();
    if (isLogin == 0) {
      Navigator.pushReplacementNamed(context, routeLogin);
    } else {
      Navigator.pushReplacementNamed(context, routeHome);
    }
  }
}
