import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/infrastructure/api_service.dart';
import 'package:sizer/sizer.dart';

final _futureValidateUser = FutureProvider.autoDispose.family((ref, String phoneNumber) async {
  return await ref.read(apiProvider).validateUser(phoneNumber);
});

const List homeGridIcons = [
  'assets/images/stock_module.png',
  'assets/images/sales_module.png',
  'assets/images/item_master.png',
  'assets/images/manage_user.png',
  'assets/images/purchase.png',
  'assets/images/offers.png',
  'assets/images/stock_module.png',
  'assets/images/transportation.png',
  'assets/images/database.png',
];

const List homeGridName = [
  'POS',
  'SALES',
  'ITEM MASTER',
  'MANAGE USERS',
  'PURCHASES',
  'EXPENSES',
  'STOCKS',
  'REPORTS',
  'MANAGE DATABASES',
];

class HomeGrid extends ConsumerWidget {
  const HomeGrid({
    Key? key,
    required this.index,
    required this.screenSize,
  }) : super(key: key);
  final Size screenSize;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          onTap: () async {
            switch (index) {
              case 0:
                await OrientationMode.toLandscape();
                await Navigator.pushNamed(context, routePos);
                await OrientationMode.toPortrait();
                break;
              case 1:
                Navigator.pushNamed(context, routeSales);
                break;
              case 2:
                Navigator.pushNamed(context, routeItemMaster);
                break;
              case 3:
                Navigator.pushNamed(context, routeUserManage);
                break;
              case 4:
                Navigator.pushNamed(context, routePurchase);
                break;
              case 5:
                Navigator.pushNamed(context, routeAddExpense);
                break;
              case 6:
                await OrientationMode.toLandscape();
                await Navigator.pushNamed(context, routeStock);
                await OrientationMode.toPortrait();
                break;
              case 7:
                await Navigator.pushNamed(context, routeReports);
                break;
              case 8:
                await getDeviceId(context, ref);

                // await Navigator.pushNamed(context, routeDatabase);

                break;
              default:
            }
          },
          child: GridTile(
            footer: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  homeGridName[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            child: Image(
              color: index == 8 ? kTeal400 : null,
              image: AssetImage(
                homeGridIcons[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getDeviceId(BuildContext context, WidgetRef ref) async {
    try {
      final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      final String? androidId = androidInfo.androidId;
      log('androidId = $androidId');

      final _future = ref.watch(_futureValidateUser('12121111').future);

      _future.then((value) => log('status = $value'));

      // final wifeMac = await GetMac.macAddress;
      // log('WIFI MAC = $wifeMac');

      // MacadressGen macadressGen = MacadressGen();
      // final String mac = await macadressGen.getMac();
      // log('WIFI MAC = $mac');

      // final PermissionStatus _permissionStatus = await Permission.phone.request();
      // if (_permissionStatus.isGranted) {
      //   final String imei = await DeviceInformation.deviceIMEINumber;
      //   log('Imei Number = $imei');

      //   final String? mobileNumber = await MobileNumber.mobileNumber;
      //   final List<SimCard>? simCards = await MobileNumber.getSimCards;

      //   log('Mobile Number == $mobileNumber');

      //   if (simCards != null) {
      //     for (SimCard sim in simCards) {
      //       log('carrierName = ${sim.carrierName}');
      //       log('countryIso = ${sim.countryIso}');
      //       log('countryPhonePrefix = ${sim.countryPhonePrefix}');
      //       log('displayName = ${sim.displayName}');
      //       log('number = ${sim.number}');
      //       log('slotIndex = ${sim.slotIndex}');
      //       log('=======================================\n');
      //     }
      //   } else {
      //     log('simCards is Null');
      //   }
      // }

      // if (_permissionStatus.isDenied) {
      //   log("Phone permission is denied.");
      //   return kSnackBar(context: context, error: true, content: 'Please allow required permissions');
      // } else if (_permissionStatus.isPermanentlyDenied) {
      //   log("Storage permission is permanently denied.");
      //   return kSnackBar(
      //       context: context,
      //       duration: 4,
      //       error: true,
      //       content: 'Please allow permissions manually from settings',
      //       action: SnackBarAction(label: 'Open', textColor: kWhite, onPressed: () async => await openAppSettings()));
      // }
    } catch (e) {
      log('Exception : $e');
    }
  }
}
