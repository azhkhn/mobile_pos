import 'dart:developer';

import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionUtil {
  static Future<bool> isConnected() async {
    try {
      final bool isConnected = await InternetConnectionChecker().hasConnection;
      log('Internet connection = $isConnected');
      return isConnected;
    } catch (_) {
      log('Internet connection = false');
      return false;
    }
  }
}
