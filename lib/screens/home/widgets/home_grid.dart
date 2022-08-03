import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:sizer/sizer.dart';

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
                await Navigator.pushNamed(context, routeDatabase);
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
}
