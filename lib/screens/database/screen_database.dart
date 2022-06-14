import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
                      content: const Text('Are you sure you want to backup database?'),
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
    final dbFolder = await getDatabasesPath();
    const String dbName = 'user.db';
    final String dbPath = join(dbFolder, dbName);
    File dbFile = File(dbPath);

    Directory copyTo = Directory("storage/emulated/0/MobilePOS");
    if ((await copyTo.exists())) {
      log("Directory Exist");
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    } else {
      log("Directory not found!");
      if (await Permission.manageExternalStorage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        await copyTo.create();
      }
    }

    final String dbBackupName = 'DB-' + Converter.dateTimeForFileName.format(DateTime.now()).trim() + '.db';
    log('Database backup name == $dbBackupName');

    final String dbBackupPath = join(copyTo.path, dbBackupName);
    log('Database backup path == $dbBackupPath');

    await dbFile.copy(dbBackupPath);

    log('Database backed up successfully');
    kSnackBar(context: context, success: true, content: 'Database backed up successfully');
  }

//==================== Restore Database ====================
  Future<void> restoreDatabase(BuildContext context) async {
    var databasesPath = await getDatabasesPath();
    var dbPath = join(databasesPath, 'user.db');

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
  }
}
