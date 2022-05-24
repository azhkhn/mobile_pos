// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';

class ScreenSplash extends StatelessWidget {
  ScreenSplash({Key? key}) : super(key: key);

  bool? orientation;
  SharedPreferences? prefs;
  final String modeKey = 'vertical';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();

      await afterSplash(context);
    });
    log('Splash Screen!');
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
          child: FractionallySizedBox(
            widthFactor: .45,
            child: Image.asset(
              'assets/images/pos.png',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> afterSplash(BuildContext context) async {
    prefs ??= prefs = await SharedPreferences.getInstance();

    await Future.delayed(const Duration(seconds: 2));

    orientation = prefs!.getBool(modeKey);

    if (orientation == null) {
      log('Setting up orientation mode');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choose a Mode from below to continue. The application will be shown based on your choice!, and also you can change it later from the settings menu.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  kHeight10,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          child: const Text(
                            'Vertical Mode',
                            style: TextStyle(color: kWhite),
                          ),
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        child: MaterialButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            prefs?.setBool(modeKey, false);
                            await userAuthentication(context);
                          },
                          child: const Text(
                            'Normal Mode',
                            style: TextStyle(color: kWhite),
                          ),
                          color: mainColor.withOpacity(.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      );
    } else {
      await userAuthentication(context);
    }
  }

//========== User Authentication ==========
  Future<void> userAuthentication(BuildContext context) async {
    log('Checking user authentication..');

    final isLogin = await UserDatabase.instance.isLogin();
    if (isLogin == 0) {
      Navigator.pushReplacementNamed(context, routeLogin);
    } else {
      Navigator.pushReplacementNamed(context, routeHome);
    }
  }
}
