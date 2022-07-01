import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/core/utils/vat/vat.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';

import '../../core/constant/colors.dart';
import '../../core/routes/router.dart';
import '../../core/utils/device/device.dart';
import '../../core/utils/user/user.dart';
import '../../db/db_functions/auth/user_db.dart';

import '../../widgets/floating_popup_widget/floating_add_options.dart';
import 'widgets/home_card_widget.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_grid.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({this.initialEntry, Key? key}) : super(key: key);
  final int? initialEntry;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final isDialOpen = ValueNotifier(false);
  static final ValueNotifier<BusinessProfileModel?> businessNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      try {
        await UserUtils.instance.fetchUserDetails();
        businessNotifier.value = await UserUtils.instance.businessProfile;
        if (VatUtils.instance.vats.isEmpty) await VatUtils.instance.getVats();
      } catch (e) {
        log(e.toString());
      }
    });
    // UserDatabase.instance.getAllUsers();
    if (DeviceUtil.isTablet) {
      log("You're Using a Tablet!");
    } else {
      log("You're Using a Phone!");
    }
    final Size _screenSize = MediaQuery.of(context).size;
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
        drawer: ValueListenableBuilder(
            valueListenable: businessNotifier,
            builder: (context, BusinessProfileModel? business, _) {
              return Drawer(
                child: HomeDrawer(
                  businessProfile: business,
                ),
              );
            }),

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
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Sign out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                          onPressed: () async => await UserDatabase.instance.logout().then(
                                (_) async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(routeLogin, (Route<dynamic> route) => false);
                                },
                              ),
                          child: const Text('Sign out')),
                    ],
                  ),
                );
              },
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
            child: Padding(
              padding: EdgeInsets.only(top: _screenSize.height / 6),
              child: Column(
                children: [
                  //========== Home Card Widget ==========
                  const HomeCardWidget(),

                  //========== Home GridView Widget ==========
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
