import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/device/device.dart';
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
  'POS',
  'Purchase',
  'Manage Expense',
  'Manage Products',
  'Manage Customer',
  'Manage Supplier',
  'Manage Category',
  'Manage Brands',
  'Settings',
  'Manage Database',
  'Reports',
  'About Software',
  'Terms and Conditions',
  'Privacy Policy',
];

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    this.businessProfile,
  }) : super(key: key);

  final BusinessProfileModel? businessProfile;

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
            child: UserAccountsDrawerHeader(
              currentAccountPicture: businessProfile != null && businessProfile?.logo != ''
                  ? CircleAvatar(backgroundImage: FileImage(File(businessProfile!.logo)))
                  : FittedBox(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: _screenSize.width / 10,
                              backgroundColor: Colors.black.withOpacity(0.5),
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
                    ),
              decoration: const BoxDecoration(color: mainColor),
              accountName: Text(businessProfile?.business ?? 'Business Name'),
              accountEmail: Text(
                businessProfile?.vatNumber ?? 'Vat Number',
                style: kText12,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeBusinessProfile);
            }),
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
      onTap: () async {
        Navigator.pop(context);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, routeSales);
            break;
          case 1:
            await OrientationMode.toLandscape();
            await Navigator.pushNamed(context, routePos);
            await OrientationMode.toPortrait();
            break;
          case 2:
            Navigator.pushNamed(context, routePurchase);
            break;
          case 3:
            Navigator.pushNamed(context, routeExpense);
            break;
          case 4:
            Navigator.pushNamed(context, routeManageItemMaster);
            break;
          case 5:
            Navigator.pushNamed(context, routeManageCustomer);
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
          case 10:
            Navigator.pushNamed(context, routeDatabase);
            break;
          case 11:
            Navigator.pushNamed(context, routeReports);
            break;
          default:
        }
      },
    );
  }
}
