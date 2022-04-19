import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';

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
  'SETTTINGS',
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
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.0)),
          child: InkWell(
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, routePos);
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
                  Navigator.pushNamed(context, routeStock);
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
}
