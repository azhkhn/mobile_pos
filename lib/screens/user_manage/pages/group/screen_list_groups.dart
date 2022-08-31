// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/db/db_functions/group/group_database.dart';
import 'package:mobile_pos/model/group/group_model.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_popup_options.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/container/background_container_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenGroupList extends StatelessWidget {
  ScreenGroupList({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  final ValueNotifier<List<GroupModel>> groupsNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final List<GroupModel> _groups = await GroupDatabase.instance.getAllGroups();
      final GroupModel _userGroup = await UserUtils.instance.userGroup;

// Hide owner group if owner is not the one who logged in
      if (_userGroup.id != 1) {
        for (GroupModel group in _groups) {
          if (group.id != 1) groupsNotifier.value.add(group);
        }
      } else {
        groupsNotifier.value = _groups;
      }

      groupsNotifier.notifyListeners();
    });

    return Scaffold(
        appBar: AppBarWidget(
          title: 'Groups List',
        ),
        body: BackgroundContainerWidget(
            child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== List Groups ==========
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: groupsNotifier,
                    builder: (context, List<GroupModel> groups, _) {
                      return groups.isNotEmpty
                          ? ListView.separated(
                              itemCount: groups.length,
                              separatorBuilder: (BuildContext context, int index) => kHeight5,
                              itemBuilder: (BuildContext context, int index) {
                                final GroupModel _group = groups[index];
                                return InkWell(
                                  child: Card(
                                    elevation: 10,
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              const Text('Name:  ', style: kText12Lite),
                                              Text(_group.name, style: kText12Bold),
                                            ],
                                          ),
                                          kHeight5,
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Description:  ', style: kText12Lite),
                                              Expanded(
                                                  child: Text(
                                                _group.description,
                                                style: kText12,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    final GroupModel userGroup = await UserUtils.instance.userGroup;

                                    if (userGroup.id != 1) {
                                      if (userGroup.id == groups[index].id) {
                                        return kSnackBar(context: context, error: true, content: "Contact owner for Admin updation");
                                      }
                                    }
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => CustomPopupOptions(
                                              options: [
                                                //========== Edit Group ==========
                                                {
                                                  'title': 'Edit Group',
                                                  'color': Colors.teal[400],
                                                  'icon': Icons.person_search_outlined,
                                                  'action': () async {
                                                    final dynamic updatedGroup = await Navigator.pushNamed(
                                                      context,
                                                      routeAddGroup,
                                                      arguments: groups[index],
                                                    );
                                                    log('returns == $updatedGroup');
                                                    if (updatedGroup != null) {
                                                      groupsNotifier.value[index] = updatedGroup as GroupModel;
                                                      groupsNotifier.notifyListeners();
                                                    }
                                                  },
                                                },
                                              ],
                                            ));
                                  },
                                );
                              },
                            )
                          : const Center(child: Text('Groups is Empty!'));
                    }),
              ),
            ],
          ),
        )));
  }
}
