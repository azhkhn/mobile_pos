// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/group/group_database.dart';
import 'package:shop_ez/model/group/group_model.dart';
import 'package:shop_ez/screens/user_manage/widgets/permission_table_header_widget.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenAddGroup extends StatelessWidget {
  ScreenAddGroup({Key? key, this.groupModel}) : super(key: key);

  //========== Model Class ==========
  final GroupModel? groupModel;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //========== TextEditing Controllers ==========
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //==================== Value Notifiers ====================
  // final ValueNotifier<List<List<bool>>> permValueNotifier = ValueNotifier(
  //   [
  //     [false, false, false, false, false],
  //     [false, false, false, false, false],
  //     [false, false, false, false, false],
  //     [false, false, false, false, false],
  //   ],
  // );

  final ValueNotifier<List<Map>> permValueNotifier = ValueNotifier(
    [
      {
        'name': 'Sales',
        'perms': [false, false, false, false, false]
      },
      {
        'name': 'Purchase',
        'perms': [false, false, false, false, false]
      },
      {
        'name': 'Products',
        'perms': [false, false, false, false, false]
      },
      {
        'name': 'Customer',
        'perms': [false, false, false, false, false]
      },
    ],
  );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (groupModel != null) getUserDetails(groupModel!);
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: groupModel == null ? 'Add Group' : 'Edit Group',
      ),
      body: SafeArea(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //========== Name Field ==========
                  TextFeildWidget(
                    controller: _nameController,
                    labelText: 'Name *',
                    isDense: true,
                    textStyle: kText12,
                    // contentPadding: kPadding10,
                    textCapitalization: TextCapitalization.words,
                    inputBorder: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputType: TextInputType.text,
                    validator: (value) => Validators.nullValidator(value),
                  ),
                  kHeight10,

                  //========== Name Arabic Field ==========
                  TextFeildWidget(
                    controller: _descriptionController,
                    labelText: 'Description *',
                    textStyle: kText12,
                    isDense: true,
                    inputBorder: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputType: TextInputType.text,
                    maxLines: 5,
                    validator: (value) => Validators.nullValidator(value),
                  ),

                  kHeight10,

                  Column(
                    children: [
                      const Text('Group Permission',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          )),
                      kHeight10,

                      //==================== Table Header ====================
                      const PermissionTableHeaderWidget(),

                      //==================== Product Items Table ====================
                      SingleChildScrollView(
                        child: ValueListenableBuilder(
                          valueListenable: permValueNotifier,
                          builder: (context, List<Map> selectedPermissions, child) {
                            return Table(
                              columnWidths: const {
                                0: FractionColumnWidth(0.25),
                                1: FractionColumnWidth(0.15),
                                2: FractionColumnWidth(0.15),
                                3: FractionColumnWidth(0.15),
                                4: FractionColumnWidth(0.15),
                                5: FractionColumnWidth(0.15),
                              },
                              border: TableBorder.all(color: Colors.grey, width: 0.5),
                              children: List<TableRow>.generate(
                                4,
                                (index) {
                                  Map _perms = selectedPermissions[index];

                                  return TableRow(children: [
                                    //==================== Module Name ====================
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _perms['name'],
                                        softWrap: true,
                                        style: kText10Lite,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),

                                    //==================== View Box ====================
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Checkbox(
                                        value: _perms['perms'][0],
                                        onChanged: (value) {
                                          _perms.update('perms', (value) {
                                            value[0] = !_perms['perms'][0];
                                            return value;
                                          });

                                          permValueNotifier.value[index] = _perms;
                                          log('permissions == ' + permValueNotifier.value[index].toString());
                                          permValueNotifier.notifyListeners();
                                        },
                                      ),
                                    ),
                                    //==================== Add Box ====================
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Checkbox(
                                        value: _perms['perms'][1],
                                        onChanged: (value) {
                                          _perms.update('perms', (value) {
                                            value[1] = !_perms['perms'][1];
                                            return value;
                                          });

                                          permValueNotifier.value[index] = _perms;
                                          log('permissions == ' + permValueNotifier.value[index].toString());
                                          permValueNotifier.notifyListeners();
                                        },
                                      ),
                                    ),
                                    //==================== Edit Box ====================
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Checkbox(
                                        value: _perms['perms'][2],
                                        onChanged: (value) {
                                          _perms.update('perms', (value) {
                                            value[2] = !_perms['perms'][2];
                                            return value;
                                          });

                                          permValueNotifier.value[index] = _perms;
                                          log('permissions == ' + permValueNotifier.value[index].toString());
                                          permValueNotifier.notifyListeners();
                                        },
                                      ),
                                    ),
                                    //==================== Delete Box ====================
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Checkbox(
                                        value: _perms['perms'][3],
                                        onChanged: (value) {
                                          _perms.update('perms', (value) {
                                            value[3] = !_perms['perms'][3];
                                            return value;
                                          });

                                          permValueNotifier.value[index] = _perms;
                                          log('permissions == ' + permValueNotifier.value[index].toString());
                                          permValueNotifier.notifyListeners();
                                        },
                                      ),
                                    ),
                                    //==================== All Box ====================
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Checkbox(
                                        value: _perms['perms'][4],
                                        onChanged: (value) {
                                          _perms.update('perms', (val) {
                                            final bool action = !_perms['perms'][4];
                                            List<bool> perms = [action, action, action, action, action];

                                            return perms;
                                          });

                                          permValueNotifier.value[index] = _perms;
                                          log('permissions == ' + permValueNotifier.value[index].toString());
                                          permValueNotifier.notifyListeners();
                                        },
                                      ),
                                    ),
                                  ]);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      kHeight5,
                    ],
                  ),

                  kHeight10,

                  //========== Submit Button ==========
                  FractionallySizedBox(
                      widthFactor: .8,
                      child: CustomMaterialBtton(
                        buttonText: groupModel == null ? 'Create Group' : 'Update Group',
                        onPressed: () async {
                          if (groupModel == null) {
                            return await addGroup(context);
                          } else {
                            return await addGroup(context, isUpdate: true);
                          }
                        },
                      )),
                  kHeight10
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //========== Add Group ==========
  Future<void> addGroup(BuildContext context, {final bool isUpdate = false}) async {
    final String name = _nameController.text, description = _descriptionController.text;

    final isFormValid = _formKey.currentState!;

    if (isFormValid.validate()) {
      log('Name = $name, Description = $description');

      final GroupModel _groupModel = GroupModel(
        id: groupModel?.id,
        name: name,
        description: description,
      );
      try {
        if (!isUpdate) {
          await GroupDatabase.instance.createGroup(_groupModel);
          kSnackBar(context: context, success: true, content: "Group Created Successfully!");
          return Navigator.pop(context);
        } else {
          await GroupDatabase.instance.updateGroup(_groupModel);
          kSnackBar(context: context, update: true, content: "Group Updated Successfully!");
          return Navigator.pop(context, _groupModel);
        }
      } catch (e) {
        kSnackBar(context: context, error: true, content: e.toString());
        return;
      }
    }
  }

  //========== Fetch Group Details ==========
  void getUserDetails(GroupModel group) {
    //retieving values from Database to TextFields
    _nameController.text = group.name;
    _descriptionController.text = group.description;
  }
}
