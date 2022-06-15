import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:sqflite/sqflite.dart';

class ScreenDatabase extends StatelessWidget {
  const ScreenDatabase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Database Manage'),
      body: Card(
        child: Column(
          children: [
            //========== Database Backup Button ==========
            CustomMaterialBtton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => KAlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Are you sure you want to backup database?'),
                          kHeight5,
                          Text(
                            'location : "storage/emulated/0/MobilePOS"',
                            style: kText12Lite,
                          )
                        ],
                      ),
                      submitColor: ContstantTexts.kColorEditText,
                      submitAction: () async {
                        Navigator.pop(ctx);
                        return await backupDatabase(context);
                      },
                    ),
                  );
                },
                buttonText: 'Backup Database',
                icon: const Icon(Icons.backup_outlined, color: kWhite)),

            //========== Database Restore Button ==========
            CustomMaterialBtton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => KAlertDialog(
                      content: const Text("Select any .db file from previous backup to restore the database."),
                      submitColor: ContstantTexts.kColorEditText,
                      submitText: 'Select',
                      submitAction: () async {
                        Navigator.pop(ctx);
                        return await restoreDatabase(context);
                      },
                    ),
                  );
                },
                buttonText: 'Restore Database',
                icon: const Icon(Icons.restore_outlined, color: kWhite)),

            //========== Database List Button ==========
            CustomMaterialBtton(
                onPressed: () {}, buttonText: "Databases", icon: const ImageIcon(AssetImage('assets/images/database.png'), color: kWhite)),
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
    Directory backupDirectory = Directory("storage/emulated/0/MobilePOS");

    final String dbBackupName = 'DB-' + Converter.dateTimeForFileName.format(DateTime.now()).trim() + '.db';
    log('Database backup name == $dbBackupName');

    final String dbBackupPath = join(backupDirectory.path, dbBackupName);
    log('Database backup path == $dbBackupPath');

    // Checking if Directory already exist..
    if ((await backupDirectory.exists())) {
      log("Directory exist!");

      Map<Permission, PermissionStatus> statuses = await [
        Permission.manageExternalStorage,
        Permission.storage,
      ].request();

      if (statuses[Permission.manageExternalStorage]!.isDenied) {
        log("manageExternalStorage permission is denied.");
      } else if (statuses[Permission.storage]!.isDenied) {
        log("storage permission is denied.");
      } else if (statuses[Permission.storage]!.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      log("Directory do not exist.. creating directory!");
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        await backupDirectory.create();
      }
    }

    try {
      await dbFile.copy(dbBackupPath);
    } on FileSystemException catch (_) {
      return kSnackBar(context: context, error: true, content: 'Please allow required permissions to backup');
    }

    log('Database backed up successfully');
    kSnackBar(context: context, success: true, content: 'Database backed up successfully');
  }

//==================== Restore Database ====================
  Future<void> restoreDatabase(BuildContext context) async {
    var databasesPath = await getDatabasesPath();
    var dbPath = join(databasesPath, 'user.db');

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
            },
          ),
        );
      } else {
        kSnackBar(context: context, error: true, content: 'Please make sure you select only .db file');
      }
    } on PlatformException catch (_) {
      return kSnackBar(context: context, error: true, content: 'Please allow required permissions to restore');
    }
  }
}
