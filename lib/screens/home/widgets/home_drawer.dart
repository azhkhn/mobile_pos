import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/busiess_profile/business_profile_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';

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
    final _screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        FutureBuilder(
          future: BusinessProfileDatabase.instance.getBusinessProfile(),
          builder: (context, AsyncSnapshot<BusinessProfileModel?> snapshot) =>
              InkWell(
                  child: UserAccountsDrawerHeader(
                    currentAccountPicture:
                        snapshot.hasData && snapshot.data!.logo != ''
                            ? CircleAvatar(
                                backgroundImage:
                                    FileImage(File(snapshot.data!.logo)))
                            : Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      radius: _screenSize.width / 10,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.5),
                                      child: Icon(
                                        Icons.business,
                                        size: _screenSize.width / 10,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 3,
                                    right: 0,
                                    child: Icon(
                                      Icons.edit,
                                      color: kWhite,
                                      size: _screenSize.width / 20,
                                    ),
                                  ),
                                ],
                              ),
                    decoration: BoxDecoration(color: mainColor),
                    accountName: Text(snapshot.hasData
                        ? snapshot.data!.business
                        : 'Business Name'),
                    accountEmail: Text(snapshot.hasData
                        ? snapshot.data!.vatNumber
                        : 'Vat Number'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, routeBusinessProfile);
                  }),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                15,
                (index) => DrawerItemsWidget(
                  index: index,
                ),
              ),
            ),
          ),
        ),
      ],
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
        style: const TextStyle(color: kTextColorBlack),
      ),
      onTap: () {
        Navigator.pop(context);
        switch (index) {
          case 3:
            Navigator.pushNamed(context, routeExpense);
            break;
          case 4:
            Navigator.pushNamed(context, routeItemMaster);
            break;
          case 5:
            Navigator.pushNamed(context, routeCustomer);
            break;
          case 6:
            Navigator.pushNamed(context, routeManageSupplier);
            break;
          case 7:
            Navigator.pushNamed(context, routeCategory);
            break;
          case 8:
            Navigator.pushNamed(context, routeBrand);
            break;
          default:
        }
      },
    );
  }
}
