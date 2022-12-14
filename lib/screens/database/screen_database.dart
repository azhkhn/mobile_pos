import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/screens/home/widgets/home_card_widget.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_alert.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:sqflite/sqflite.dart';

class ScreenDatabase extends ConsumerWidget {
  const ScreenDatabase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Manage Database'),
      body: Card(
        child: Column(
          children: [
            kHeight10,
            Row(
              children: [
                //========== Database Backup Button ==========
                Flexible(
                  child: CustomMaterialBtton(
                    height: 50,
                    color: kGreen,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => KAlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Are you sure you want to backup the database?'),
                              kHeight5,
                              Text(
                                'Location: "/Android/media/com.cignes.mobilepos/Databases/"',
                                style: kText12Lite,
                              )
                            ],
                          ),
                          submitColor: ContstantTexts.kColorEditText,
                          submitAction: () async {
                            Navigator.pop(ctx);
                            return await requestPermission(context, ref, action: 'backup');
                          },
                        ),
                      );
                    },
                    buttonText: 'Backup Database',
                    fittedText: true,
                    icon: const Icon(Icons.backup_outlined, color: kWhite),
                  ),
                ),

                kWidth10,

                //========== Database Restore Button ==========
                Flexible(
                  child: CustomMaterialBtton(
                    height: 50,
                    color: Colors.indigo[400],
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (ctx) => KAlertDialog(
                          content: const Text("Select any .db file from the previous backups to restore the database."),
                          submitColor: ContstantTexts.kColorEditText,
                          submitText: 'Select',
                          submitAction: () async {
                            Navigator.pop(ctx);
                            return await requestPermission(context, ref, action: 'restore');
                          },
                        ),
                      );
                    },
                    buttonText: 'Restore Database',
                    fittedText: true,
                    icon: const Icon(Icons.restore_outlined, color: kWhite),
                  ),
                ),
              ],
            ),

            kHeight10,

            //========== Database List Button ==========
            CustomMaterialBtton(
              height: 50,
              color: kTeal400,
              onPressed: () => Navigator.pushNamed(context, routeDatabaseList),
              buttonText: "Databases",
              fittedText: true,
              icon: const ImageIcon(AssetImage('assets/images/icons/database.png'), color: kWhite),
            ),
          ],
        ),
      ),
    );
  }

//==================== Backup Database ====================
  Future<void> backupDatabase(BuildContext context) async {
    final String dbFolder = await getDatabasesPath();
    final String dbPath = join(dbFolder, 'user.db');
    final File dbFile = File(dbPath);

    // final Directory documentDirectory = await getApplicationDocumentsDirectory();
    // final String backupFolderPath = join(documentDirectory.path, 'db_backup');
    // final Directory backupDirectory = Directory(backupPath);

    // log('getApplicationDocumentsDirectory == ' + (await p.getApplicationDocumentsDirectory()).path);
    // log('getApplicationSupportDirectory == ' + (await p.getApplicationSupportDirectory()).path);
    // log('getExternalCacheDirectories == ' + (await p.getExternalCacheDirectories()).toString());
    // log('getExternalStorageDirectory == ' + (await p.getExternalStorageDirectory())!.path.toString());
    // log('getTemporaryDirectory == ' + (await p.getTemporaryDirectory()).path);

    Directory backupDirectory = Directory("/storage/emulated/0/Android/media/com.cignes.mobilepos/Databases/");

    final String dbBackupName = 'DB-' + Converter.dateTimeForFileName.format(DateTime.now()).trim() + '.db';
    log('Database backup name == $dbBackupName');

    final String dbBackupPath = join(backupDirectory.path, dbBackupName);
    log('Database backup path == $dbBackupPath');

    //creates the directory if it doesn't exist
    backupDirectory.createSync(recursive: true);

    try {
      await dbFile.copy(dbBackupPath);
    } on FileSystemException catch (_) {
      return kSnackBar(context: context, error: true, content: 'Please allow required permissions to backup');
    }

    log('Database backed up successfully');
    kSnackBar(context: context, success: true, content: 'Database backed up successfully');
  }

//==================== Restore Database ====================
  Future<void> restoreDatabase(BuildContext context, WidgetRef ref) async {
    final String databasesPath = await getDatabasesPath();
    final String dbPath = join(databasesPath, 'user.db');

    try {
      FilePickerResult? _result = await FilePicker.platform.pickFiles(dialogTitle: 'Select Database');
      if (_result == null) return;

      final PlatformFile selectedDB = _result.files.first;

      if (selectedDB.extension == 'db' || selectedDB.extension == 'DB') {
        showDialog(
          context: context,
          builder: (ctx) => KAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Are you sure you want to restore the database?'),
                kHeight5,
                Text(
                  'NB: Your current database will be replaced with the one you restore. Make sure you backup your current one before restore.',
                  style: kText12Lite,
                )
              ],
            ),
            submitText: 'Restore',
            submitAction: () async {
              Navigator.pop(ctx);
              File source = File(selectedDB.path!);
              await source.copy(dbPath);

              log('Database restored successfully');
              kSnackBar(context: context, update: true, content: 'Database restored successfully');
              await UserUtils.instance.reloadUserDetails();
              ref.refresh(HomeCardWidget.homeCardProvider);
            },
          ),
        );
      } else {
        kSnackBar(context: context, error: true, content: 'Please make sure you select only .db file');
      }
    } on PlatformException catch (_) {
      return kSnackBar(context: context, error: true, content: 'Please allow required permissions to restore');
    } on FileSystemException catch (_) {
      return kSnackBar(context: context, error: true, content: 'Please allow required permissions to restore');
    }
  }

  //==================== Permission Handler ====================
  Future<void> requestPermission(BuildContext context, WidgetRef ref, {required final String action}) async {
    final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    final num osVersion = num.parse(androidInfo.version.release!);
    log('Android OS Version = $osVersion');

    // if (action == 'backup') {
    //   if (osVersion > 10) {
    //     log('OS version is > 10 ');
    //     final PermissionStatus _permissionStatus = await Permission.manageExternalStorage.request();
    //     if (_permissionStatus.isDenied) {
    //       log("ManageExternalStorage permission is denied.");
    //       return kSnackBar(context: context, error: true, content: 'Please allow required permissions to $action');
    //     }
    //   }
    // }

    final PermissionStatus _permissionStatus = await Permission.storage.request();
    final bool check = await Permission.storage.shouldShowRequestRationale;

    log('Permission Status == $_permissionStatus');
    log('shouldShowRequestRationale == $check');
    if (_permissionStatus.isDenied) {
      log("Storage permission is denied.");
      return kSnackBar(context: context, error: true, content: 'Please allow required permissions to $action');
    }
    if (_permissionStatus.isPermanentlyDenied) {
      log("Storage permission is permanently denied.");
      return kSnackBar(
          context: context,
          duration: 4,
          error: true,
          content: 'Please allow permissions manually from settings to $action',
          action: SnackBarAction(label: 'Open', textColor: kWhite, onPressed: () async => await openAppSettings()));
    }

//Call backup or restore fucntion
    if (action == 'backup') {
      backupDatabase(context);
    } else {
      restoreDatabase(context, ref);
    }
  }
}
