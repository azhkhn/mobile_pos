import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';

const List homeGridIcons = [
  'assets/images/stock_module.png',
  'assets/images/sales_module.png',
  'assets/images/item_master.png',
  'assets/images/manage_user.png',
  'assets/images/purchase.png',
  'assets/images/offers.png',
  'assets/images/stock_module.png',
  'assets/images/transportation.png',
  'assets/images/settings_module.png',
];

const List homeGridName = [
  'POS',
  'SALES',
  'ITEM MASTER',
  'USER MODULE',
  'PURCHASE',
  'EXPENSE',
  'STOCK',
  'REPORTS',
  'SETTINGS',
];

class HomeGrid extends StatelessWidget {
  const HomeGrid({
    Key? key,
    required this.index,
    required this.screenSize,
  }) : super(key: key);
  final Size screenSize;
  final int index;

  @override
  Widget build(BuildContext context) {
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
                case 4:
                  Navigator.pushNamed(context, routePurchase);
                  break;
                case 5:
                  Navigator.pushNamed(context, routeExpense);
                  break;
                case 6:
                  await OrientationMode.toLandscape();
                  await Navigator.pushNamed(context, routeStock);
                  await OrientationMode.toPortrait();
                  break;
                case 8:
                  await changeDeviceMode(context);
                  break;
                default:
              }
            },
            child: GridTile(
              footer: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  homeGridName[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: screenSize.width / 45,
                    // fontSize: screenSize.width * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Image(
                image: AssetImage(
                  homeGridIcons[index],
                ),
              ),
            ),
          )),
    );
  }

  Future<void> changeDeviceMode(BuildContext context) async {
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
                          child: const Text(
                            'Vertical Mode',
                            style: TextStyle(color: kWhite),
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
                          child: const Text(
                            'Normal Mode',
                            style: TextStyle(color: kWhite),
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
