import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';

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
    log('Secondary Splash Screen');
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      body: Container(
        decoration: const BoxDecoration(
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
    log('checking UserLogin!');

    await Future.delayed(const Duration(seconds: 3));
    final isLogin = await UserDatabase.instance.isLogin();
    if (isLogin == 0) {
      Navigator.pushReplacementNamed(context, routeLogin);
    } else {
      Navigator.pushReplacementNamed(context, routeHome);
    }
  }
}
