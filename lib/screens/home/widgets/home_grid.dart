import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:sizer/sizer.dart';

const List homeGridIcons = [
  'assets/images/home/pos.png',
  'assets/images/home/sales.png',
  'assets/images/home/item_master.png',
  'assets/images/home/manage_users.png',
  'assets/images/home/purchases.png',
  'assets/images/home/expenses.png',
  'assets/images/home/stocks.png',
  'assets/images/home/reports.png',
  'assets/images/home/manage_databases.png',
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
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20.0)),
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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: .5,
                  heightFactor: .5,
                  alignment: Alignment.center,
                  child: Image(image: AssetImage(homeGridIcons[index])),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: kPadding5,
                    child: Text(
                      homeGridName[index],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 6.sp,
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
