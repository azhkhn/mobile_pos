import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';

enum DeviceType { phone, smallPhone, tablet }

final bool isTablet = DeviceUtil.isTablet;
final bool isThermal = DeviceUtil.isSmall;

class DeviceUtil {
  //========== Singleton Instance ==========
  DeviceUtil._internal();
  static DeviceUtil instance = DeviceUtil._internal();
  factory DeviceUtil() {
    return instance;
  }

  //========== Get Screen Size ==========
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  //========== Get Device Type ==========
  static Enum get _getDeviceType {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;
  }

  //========== Get Phone Type ==========
  static Enum get _getPhoneType {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 360 ? DeviceType.smallPhone : DeviceType.phone;
  }

  //========== Checking if it's Tablet or Smartphone ==========
  static bool get isTablet {
    return _getDeviceType == DeviceType.tablet;
  }

  //========== Checking if Phone is Small or Big ==========
  static bool get isSmall {
    return _getPhoneType == DeviceType.smallPhone;
  }
}

//==============================                  ==============================
//============================== Orientation Mode ==============================
//==============================                  ==============================
class OrientationMode {
  static const String deviceModeKey = 'device_mode';
  static const String verticalMode = 'vertical';
  static const String normalMode = 'normal';
  static String? deviceMode;
  static bool isLandscape = false;

  //========== Singleton Instance ==========
  OrientationMode._internal();
  static OrientationMode instance = OrientationMode._internal();
  factory OrientationMode() {
    return instance;
  }

  //========== Get Current Orientation Mode ==========
  static Future<String> get getDeviceMode async {
    if (deviceMode != null) return deviceMode!;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceMode = prefs.getString(deviceModeKey)!;
    log('Device Mode == $deviceMode');
    return deviceMode!;
  }

  //========== Portrait and Landscape ==========
  static Future<void> toPortrait() async {
    log('Device Mode == $deviceMode');
    if (await getDeviceMode == normalMode) {
      isLandscape = false;
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }

  static Future<void> toLandscape() async {
    log('Device Mode == $deviceMode');
    if (await getDeviceMode == normalMode) {
      isLandscape = true;
      await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

//=== === === === === Change Device Orientation Mode === === === === ===
  static Future<void> changeDeviceMode(BuildContext context) async {
    // prefs = await SharedPreferences.getInstance();
    // prefs!.remove(OrientationMode.deviceModeKey);

    SharedPreferences prefs = await SharedPreferences.getInstance();

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
                            OrientationMode.deviceMode = OrientationMode.verticalMode;
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
                            OrientationMode.deviceMode = OrientationMode.normalMode;
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
  }
}
