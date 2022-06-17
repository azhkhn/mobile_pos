// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/screens/user_manage/widgets/user_card_widget.dart';
import 'package:shop_ez/widgets/alertdialog/custom_popup_options.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenUserList extends StatelessWidget {
  ScreenUserList({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<UserModel>> usersNotifier = ValueNotifier([]);

  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userModel = await UserUtils.instance.loggedUser;
    });

    return Scaffold(
        appBar: AppBarWidget(
          title: 'Users List',
        ),
        body: BackgroundContainerWidget(
            child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== List Users ==========
              Expanded(
                child: FutureBuilder(
                    future: UserDatabase.instance.getAllUsers(),
                    builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Users is Empty!'));
                          }

                          final List<UserModel> allUsers = snapshot.data!;

                          if (userModel!.userGroup == 'Owner') {
                            usersNotifier.value = snapshot.data!;
                          } else {
                            final List<UserModel> users = [];

                            for (var user in allUsers) {
                              if (user.userGroup != 'Owner') {
                                usersNotifier.value.add(user);
                              }
                            }

                            usersNotifier.value = users;
                          }

                          return ValueListenableBuilder(
                              valueListenable: usersNotifier,
                              builder: (context, List<UserModel> users, _) {
                                return users.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: users.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          final UserModel _user = users[index];
                                          return InkWell(
                                            child: UserCardwidget(
                                              index: index,
                                              user: _user,
                                            ),
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => CustomPopupOptions(
                                                        options: [
                                                          //========== Edit User ==========
                                                          {
                                                            'title': 'Edit User',
                                                            'color': Colors.teal[400],
                                                            'icon': Icons.person_search_outlined,
                                                            'action': () async {
                                                              final dynamic updatedUser = await Navigator.pushNamed(
                                                                context,
                                                                routeAddUser,
                                                                arguments: users[index],
                                                              );
                                                              log('returns == $updatedUser');
                                                              if (updatedUser != null) {
                                                                usersNotifier.value[index] = updatedUser as UserModel;
                                                                usersNotifier.notifyListeners();
                                                              }
                                                            },
                                                          },
                                                          //========== Delete User ==========
                                                          if (_user.userGroup != 'Owner')
                                                            {
                                                              'title': _user.status == 1 ? 'Disable User' : 'Enable User',
                                                              'color': _user.status == 1 ? kRed400 : kGreen400,
                                                              'icon': _user.status == 1 ? Icons.person_off_outlined : Icons.personal_injury_outlined,
                                                              'action': () async {
                                                                if (_user.status == 1) {
                                                                  await UserDatabase.instance.updateUser(_user.copyWith(status: 0));
                                                                  usersNotifier.value[index] = _user.copyWith(status: 0);
                                                                  usersNotifier.notifyListeners();
                                                                } else {
                                                                  await UserDatabase.instance.updateUser(_user.copyWith(status: 1));
                                                                  usersNotifier.value[index] = _user.copyWith(status: 1);
                                                                  usersNotifier.notifyListeners();
                                                                }
                                                              }
                                                            },
                                                        ],
                                                      ));
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Users is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        )));
  }
}
