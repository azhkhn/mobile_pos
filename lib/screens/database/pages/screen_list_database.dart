import 'dart:developer' show log;
import 'dart:io' show Directory, File, FileSystemEntity;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/icons.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';

final _filesProvider = FutureProvider.autoDispose<List<FileSystemEntity>>((ref) async {
  final Directory backupDirectory = Directory("storage/emulated/0/MobilePOS");
  final PermissionStatus _permStorageStatus = await Permission.storage.status;

  if (await backupDirectory.exists() == true && !_permStorageStatus.isGranted) throw 'Insufficient Storage Permission';
  final List<FileSystemEntity> allFiles = backupDirectory.listSync();
  final List<FileSystemEntity> dbFiles = [];
  for (FileSystemEntity file in allFiles) {
    if (p.extension((file.path)) == '.db') dbFiles.add(file);
  }

  dbFiles.sort((a, b) => a.statSync().modified.compareTo(b.statSync().modified));

  return dbFiles.reversed.toList();
});

class ScreenDatabaseList extends ConsumerWidget {
  const ScreenDatabaseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(_filesProvider);
    return Scaffold(
      appBar: AppBarWidget(title: 'Databases'),
      body: SafeArea(
        child: future.when(
          data: (files) {
            return files.isNotEmpty
                ? ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (BuildContext context, int index) {
                      final file = files[index];
                      return Card(
                          child: ListTile(
                        dense: false,
                        minLeadingWidth: 10,
                        leading: CircleAvatar(
                          backgroundColor: kTransparentColor,
                          maxRadius: 12,
                          child: Text('${index + 1}'.toString(), style: kTextNo12),
                        ),
                        title: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            p.basename(file.path).replaceAll('.db', ''),
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //== == == == == Share Database == == == == ==
                            Flexible(
                              child: IconButton(
                                onPressed: () async {
                                  await Share.shareFiles([file.path]);
                                },
                                icon: kIconShare,
                                iconSize: 15.sp,
                                constraints: const BoxConstraints(minHeight: 35, minWidth: 35),
                              ),
                            ),

                            //== == == == == Restore Database == == == == ==
                            Flexible(
                              child: IconButton(
                                onPressed: () async {
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
                                        final String databasesPath = await getDatabasesPath();
                                        final String dbPath = p.join(databasesPath, 'user.db');
                                        File source = File(file.path);
                                        await source.copy(dbPath);

                                        Navigator.pop(ctx);
                                        log('Database restored successfully');
                                        kSnackBar(context: context, update: true, content: 'Database restored successfully');
                                        await UserUtils.instance.reloadUserDetails();
                                      },
                                    ),
                                  );
                                },
                                icon: kIconUpdate,
                                iconSize: 17.sp,
                                constraints: const BoxConstraints(minHeight: 35, minWidth: 35),
                              ),
                            ),
                            //== == == == == Delete Database == == == == ==
                            Flexible(
                              child: IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => KAlertDialog(
                                            content: const Text('Are you sure you want to delete this item?'),
                                            submitAction: () {
                                              file.deleteSync();
                                              ref.refresh(_filesProvider);
                                              Navigator.pop(context);
                                              log('Database deleted successfully');
                                              kSnackBar(context: context, content: 'Database deleted successfully', delete: true);
                                            },
                                          ));
                                },
                                icon: kIconDelete,
                                iconSize: 17.sp,
                                constraints: const BoxConstraints(minHeight: 35, minWidth: 35),
                              ),
                            ),
                          ],
                        ),
                      ));
                    },
                  )
                : const Center(child: Text('No recent database backups'));
          },
          error: (Object o, StackTrace? e) {
            log('Error : ' + e.toString() + 'Exception : ' + o.toString());

            if (o == 'Insufficient Storage Permission') {
              requestPermission(context, ref);
              return const Center(child: Text('Something went wrong'));
            }
            return const Center(child: Text('No recent database backups'));
          },
          loading: () => const Center(child: SingleChildScrollView()),
        ),
      ),
    );
  }
}

Future<void> requestPermission(
  BuildContext context,
  WidgetRef ref,
) async {
  final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
  final num osVersion = num.parse(androidInfo.version.release!);
  log('Android OS Version = $osVersion');

  final PermissionStatus _permissionStatus = await Permission.storage.request();
  final bool check = await Permission.storage.shouldShowRequestRationale;

  log('Permission Status == $_permissionStatus');
  log('shouldShowRequestRationale == $check');

  if (_permissionStatus.isGranted) return ref.refresh(_filesProvider);

  if (_permissionStatus.isDenied) {
    log("Storage permission is denied.");
    return kSnackBar(context: context, error: true, content: 'Please allow required permissions');
  }
  if (_permissionStatus.isPermanentlyDenied) {
    log("Storage permission is permanently denied.");
    return kSnackBar(
      context: context,
      duration: 4,
      error: true,
      content: 'Please allow permissions manually from settings',
      action: SnackBarAction(label: 'Open', textColor: kWhite, onPressed: () async => await openAppSettings()),
    );
  }
}
