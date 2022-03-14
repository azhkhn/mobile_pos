import 'package:flutter/material.dart';

const List drawerListItemImage = [
  'assets/images/sales_module.png',
  'assets/images/stock_module.png',
  'assets/images/purchase.png',
  'assets/images/offers.png',
  'assets/images/item_master.png',
  'assets/images/manage_user.png',
  'assets/images/manage_user.png',
  'assets/images/purchase.png',
  'assets/images/item_master.png',
  'assets/images/settings_module.png',
  'assets/images/sales_module.png',
  'assets/images/transportation.png',
  'assets/images/stock_module.png',
  'assets/images/manage_user.png',
  'assets/images/stock_module.png',
];

const List drawerListItem = [
  'Sales',
  'Pos',
  'Purchase',
  'Manage Expense',
  'Item Master',
  'Manage Customer',
  'Manage Supplier',
  'Manage Category',
  'Manage Brands',
  'Settings',
  'DB Backup',
  'Reports',
  'About Software',
  'Terms and Conditions',
  'Privacy Policy',
];

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        15,
        (index) => DrawerItemsWidget(
          index: index,
        ),
      ),
    );
  }
}

class DrawerItemsWidget extends StatelessWidget {
  const DrawerItemsWidget({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(
        // color: Colors.white,
        image: AssetImage(drawerListItemImage[index]),
      ),
      title: Text(
        drawerListItem[index],
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
