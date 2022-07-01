import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DeviceType { phone, smallPhone, tablet }

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
}
