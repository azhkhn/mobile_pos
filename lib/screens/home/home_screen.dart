import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/images.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/core/utils/vat/vat.dart';
import 'package:mobile_pos/db/db_functions/auth/user_db.dart';
import 'package:mobile_pos/model/business_profile/business_profile_model.dart';
import 'package:mobile_pos/widgets/floating_popup_widget/floating_add_options.dart';
import 'package:sizer/sizer.dart';

import 'widgets/home_card_widget.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_grid.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  static final ValueNotifier<BusinessProfileModel?> businessNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await UserUtils.instance.fetchUserDetails();
        businessNotifier.value = await UserUtils.instance.businessProfile;
        if (VatUtils.instance.vats.isEmpty) await VatUtils.instance.getVats();
      } catch (e) {
        log('', error: e);
      }
    });
    if (isTablet) {
      log("You're Using a Tablet!");
    } else {
      log("You're Using a Phone!");
    }
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
        resizeToAvoidBottomInset: false,
        //========== Drawer Widget ==========
        drawer: ValueListenableBuilder(
            valueListenable: businessNotifier,
            builder: (context, BusinessProfileModel? business, _) {
              return Drawer(
                width: 78.w,
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
          child: Column(
            children: [
              Container(
                color: mainColor,
                // height: 2.sp,
              ),
              Expanded(
                flex: 20,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: isThermal ? BoxFit.fill : BoxFit.fill,
                      scale: 1,
                      image: const AssetImage(kHomeImage),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 70,
                child: Column(
                  children: [
                    //========== Home Card Widget ==========
                    const HomeCardWidget(),

                    //========== Home GridView Widget ==========
                    Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.all(10),
                        crossAxisCount: 3,
                        mainAxisSpacing: SizerUtil.width / 50,
                        crossAxisSpacing: SizerUtil.width / 50,
                        children: List.generate(
                          9,
                          (index) => HomeGrid(index: index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingAddOptions(isDialOpen: isDialOpen),
      ),
    );
  }
}
