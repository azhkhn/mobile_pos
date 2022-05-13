import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DeviceType { phone, tablet }

class DeviceUtil {
  //========== Singleton Instance ==========
  DeviceUtil._internal();
  static DeviceUtil instance = DeviceUtil._internal();
  factory DeviceUtil() {
    return instance;
  }

  static Enum get _getDeviceType {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? DeviceType.phone : DeviceType.tablet;
  }

  static bool get isTablet {
    return _getDeviceType == DeviceType.tablet;
  }

  //========== Portrait and Landscape ==========
  static bool isLandscape = false;
  static Future<void> toPortrait() async {
    isLandscape = false;
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static Future<void> toLandscape() async {
    isLandscape = true;
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }
}
