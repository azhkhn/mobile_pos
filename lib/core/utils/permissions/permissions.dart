import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';

class PermissionUtils {
  static Future<bool> requestPermission(BuildContext context, {required PermissionWithService permission}) async {
    final PermissionStatus _permissionStatus = await permission.request();

    //========== Permission Granted ==========
    if (_permissionStatus.isGranted) {
      log("Permission is granted");
      return true;
    }
    //========== Permission Denied ==========
    if (_permissionStatus.isDenied) {
      log("Permission is denied");
      kSnackBar(context: context, error: true, content: 'Please allow required permissions');
      return false;
    }
    //========== Permission Permanently Denied ==========
    if (_permissionStatus.isPermanentlyDenied) {
      log("Permission is permanently denied");
      kSnackBar(
          context: context,
          duration: 4,
          error: true,
          content: 'Please allow permissions manually from settings',
          action: SnackBarAction(label: 'Open', textColor: kWhite, onPressed: () async => await openAppSettings()));
      return false;
    }
    return false;
  }
}
