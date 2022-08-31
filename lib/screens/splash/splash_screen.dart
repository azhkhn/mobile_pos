// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/images.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/db/db_functions/auth/user_db.dart';

class ScreenSplash extends StatelessWidget {
  ScreenSplash({Key? key}) : super(key: key);

  String? orientationMode;
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();

      await afterSplash(context);
    });
    log('Splash Screen');
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
              kLogo,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> afterSplash(BuildContext context) async {
    // prefs = await SharedPreferences.getInstance();
    // prefs!.remove(OrientationMode.deviceModeKey);

    // prefs.setString(OrientationMode.deviceModeKey, OrientationMode.verticalMode);
    orientationMode = prefs.getString(OrientationMode.deviceModeKey);

    await Future.delayed(const Duration(seconds: 2));

    if (orientationMode == null) {
      log('=> Setting up orientation mode <=');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Choose a Mode from below to continue. The application will be shown based on your choice!, You can change it later from the settings menu.',
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
                            onPressed: () async {
                              Navigator.pop(context);
                              prefs.setString(OrientationMode.deviceModeKey, OrientationMode.verticalMode);
                              await OrientationMode.getDeviceMode;
                              await userAuthentication(context);
                            },
                            child: const FittedBox(
                              child: Text(
                                'Vertical Mode',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kWhite),
                              ),
                            ),
                            color: Colors.blueGrey[300],
                          ),
                        ),
                        kWidth5,
                        Expanded(
                          child: MaterialButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              prefs.setString(OrientationMode.deviceModeKey, OrientationMode.normalMode);
                              await OrientationMode.getDeviceMode;
                              await userAuthentication(context);
                            },
                            child: const FittedBox(
                              child: Text(
                                'Normal Mode',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kWhite),
                              ),
                            ),
                            color: mainColor.withOpacity(.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
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
