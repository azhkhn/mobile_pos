// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/screens/user_manage/widgets/user_card_widget.dart';
import 'package:shop_ez/widgets/alertdialog/custom_popup_options.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenUserList extends StatelessWidget {
  const ScreenUserList({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<UserModel>> usersNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
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
                          usersNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: usersNotifier,
                              builder: (context, List<UserModel> users, _) {
                                return users.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: users.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: UserCardwidget(
                                              index: index,
                                              user: users[index],
                                            ),
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => CustomPopupOptions(
                                                        options: [
                                                          //========== Edit User ==========
                                                          {
                                                            'title': 'Edit User',
                                                            'color': Colors.blueGrey[400],
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
                                                          {
                                                            'title': 'Disable User',
                                                            'color': Colors.red[400],
                                                            'icon': Icons.person_off_outlined,
                                                            'action': () async {}
                                                          },
                                                        ],
                                                      ));
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Sales is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        )));
  }
}
