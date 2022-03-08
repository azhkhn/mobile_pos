import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';

const List homeGridIcons = [
  'assets/images/manage_user.png',
  'assets/images/purchase.png',
  'assets/images/stock_module.png',
  'assets/images/sales_module.png',
  'assets/images/item_master.png',
  'assets/images/settings_module.png',
  'assets/images/offers.png',
  'assets/images/transportation.png',
];

const List homeGridName = [
  'MANAGE USERS',
  'PURCHASE',
  'STOCK MODULE',
  'SALES MODULE',
  'ITEM MASTER',
  'SETTTINGS MODULE',
  'OFFERS',
  'TRANSPORTATION',
];

class HomeGrid extends StatelessWidget {
  const HomeGrid({
    Key? key,
    required this.index,
  }) : super(key: key);

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
            onTap: () => Navigator.pushNamed(context, routeManageUsers),
            child: GridTile(
                footer: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    homeGridName[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                child: Image(
                  image: AssetImage(
                    homeGridIcons[index],
                  ),
                )),
          )),
    );
  }
}
