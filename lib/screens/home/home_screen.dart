import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/user/logged_user.dart';
import 'package:shop_ez/db/db_functions/user_database/user_db.dart';
import 'package:shop_ez/model/user/user_model.dart';
import 'package:shop_ez/screens/home/widgets/home_drawer.dart';
import 'package:shop_ez/screens/home/widgets/home_grid.dart';
import 'package:shop_ez/widgets/floating_popup_widget/floating_add_options.dart';
import 'package:shop_ez/core/utils/device/device.dart';

import '../../model/business_profile/business_profile_model.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({this.initialEntry, Key? key}) : super(key: key);
  final int? initialEntry;
  static late Size _screenSize;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final isDialOpen = ValueNotifier(false);
  static UserModel? _userModel;
  static BusinessProfileModel? _businessProfileModel;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _userModel ??= await UserUtils.instance.loggedUser;
      _businessProfileModel ??= await UserUtils.instance.businessProfile;
    });
    // UserDatabase.instance.getAllUsers();
    if (DeviceUtil.isTablet) {
      log("You're Using a Tablet!");
    } else {
      log("You're Using a Phone!");
    }
    _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,

        //========== Drawer Widget ==========
        drawer: const Drawer(
          child: HomeDrawer(),
        ),

        //========== AppBar Widget ==========
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Image(
              image: AssetImage('assets/images/hamburger.png'),
              height: 24,
              width: 24,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async => await UserDatabase.instance.logout().then(
                    (_) => Navigator.pushReplacementNamed(context, routeLogin),
                  ),
              icon: const Icon(Icons.logout),
            )
          ],
        ),

        //========== Background Image ==========
        body: SafeArea(
          child: Container(
            width: _screenSize.width,
            height: _screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/home.jpg'),
              ),
            ),

            //========== Home GridView Widget ==========
            child: Padding(
              padding: EdgeInsets.only(top: _screenSize.height / 6),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _screenSize.width * 0.07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 5,
                          color: Colors.blue[300],
                          child: SizedBox(
                            width: _screenSize.width / 4,
                            height: _screenSize.width / 12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Today Cash',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kButtonTextWhite,
                                      fontSize: _screenSize.width * 0.025),
                                ),
                                // kHeight5,
                                Text(
                                  '13840',
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    color: kButtonTextWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: _screenSize.width * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          color: Colors.green[300],
                          child: SizedBox(
                            width: _screenSize.width / 4,
                            height: _screenSize.width / 12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total Cash',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kButtonTextWhite,
                                      fontSize: _screenSize.width * 0.025),
                                ),
                                // kHeight5,
                                Text(
                                  '1856750',
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kButtonTextWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: _screenSize.width * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          color: Colors.red[300],
                          child: SizedBox(
                            width: _screenSize.width / 4,
                            height: _screenSize.width / 12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Today Sale',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kButtonTextWhite,
                                      fontSize: _screenSize.width * 0.025),
                                ),
                                // kHeight5,
                                Text(
                                  '160',
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kButtonTextWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: _screenSize.width * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      padding: EdgeInsets.all(_screenSize.width / 50),
                      crossAxisCount: 3,
                      mainAxisSpacing: _screenSize.width / 50,
                      crossAxisSpacing: _screenSize.width / 50,
                      children: List.generate(
                        9,
                        (index) => HomeGrid(
                          index: index,
                          screenSize: _screenSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingAddOptions(isDialOpen: isDialOpen),
      ),
    );
  }
}
