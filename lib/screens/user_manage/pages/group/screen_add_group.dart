// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/group/group_database.dart';
import 'package:shop_ez/db/db_functions/permission/permission_database.dart';
import 'package:shop_ez/model/group/group_model.dart';
import 'package:shop_ez/model/permission/permission_model.dart';
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

  final ValueNotifier<List<String>> permValueNotifier = ValueNotifier([
    '0',
    '0',
    '0',
    '0',
    '0',
  ]);

  final ValueNotifier<List<Map>> permissionsNotifier = ValueNotifier(
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
      {
        'name': 'Supplier',
        'perms': [false, false, false, false, false]
      },
    ],
  );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (groupModel != null) {
        await getGroupDetails(groupModel!);
      }
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
                          valueListenable: permissionsNotifier,
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
                                permissionsNotifier.value.length,
                                (index) {
                                  Map _perms = selectedPermissions[index];
                                  List<bool> _permList = _perms['perms'];
                                  final String _permValue = permValueNotifier.value[index];

                                  bool allPerm = true;
                                  for (var i = 0; i < _permList.length - 1; i++) {
                                    final bool value = _permList[i];

                                    if (!value) {
                                      allPerm = false;
                                    }
                                    continue;
                                  }

                                  _perms.update('perms', (val) {
                                    val[4] = allPerm;
                                    return val;
                                  });

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
                                        value: _permList[0],
                                        activeColor: kGreen300,
                                        onChanged: (state) {
                                          _perms.update('perms', (val) {
                                            val[0] = state;
                                            return val;
                                          });

                                          if (state!) {
                                            permValueNotifier.value[index] = _permValue.replaceAll('0', '') + '1';
                                          } else {
                                            permValueNotifier.value[index] = _permValue.replaceAll('1', '');
                                          }

                                          permissionsNotifier.value[index] = _perms;
                                          log('permissions == ' + permissionsNotifier.value[index].toString());
                                          permissionsNotifier.notifyListeners();
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
                                        value: _permList[1],
                                        activeColor: kGreen300,
                                        onChanged: (state) {
                                          _perms.update('perms', (val) {
                                            val[1] = state;
                                            return val;
                                          });

                                          if (state!) {
                                            permValueNotifier.value[index] = _permValue.replaceAll('0', '') + '2';
                                          } else {
                                            permValueNotifier.value[index] = _permValue.replaceAll('2', '');
                                          }

                                          permissionsNotifier.value[index] = _perms;
                                          log('permissions == ' + permissionsNotifier.value[index].toString());
                                          permissionsNotifier.notifyListeners();
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
                                        value: _permList[2],
                                        activeColor: kGreen300,
                                        onChanged: (state) {
                                          _perms.update('perms', (val) {
                                            val[2] = state;
                                            return val;
                                          });

                                          if (state!) {
                                            permValueNotifier.value[index] = _permValue.replaceAll('0', '') + '3';
                                          } else {
                                            permValueNotifier.value[index] = _permValue.replaceAll('3', '');
                                          }

                                          permissionsNotifier.value[index] = _perms;
                                          log('permissions == ' + permissionsNotifier.value[index].toString());
                                          permissionsNotifier.notifyListeners();
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
                                        value: _permList[3],
                                        activeColor: kGreen300,
                                        onChanged: (state) {
                                          _perms.update('perms', (val) {
                                            val[3] = state;
                                            return val;
                                          });

                                          if (state!) {
                                            permValueNotifier.value[index] = _permValue.replaceAll('0', '') + '4';
                                          } else {
                                            permValueNotifier.value[index] = _permValue.replaceAll('4', '');
                                          }

                                          permissionsNotifier.value[index] = _perms;
                                          log('permissions == ' + permissionsNotifier.value[index].toString());
                                          permissionsNotifier.notifyListeners();
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
                                        value: _permList[4],
                                        activeColor: kGreen300,
                                        onChanged: (state) {
                                          _perms.update('perms', (val) {
                                            List<bool> perms = [state!, state, state, state, state];
                                            return perms;
                                          });

                                          if (state!) {
                                            permValueNotifier.value[index] = '1234';
                                          } else {
                                            permValueNotifier.value[index] = '0';
                                          }

                                          permissionsNotifier.value[index] = _perms;
                                          log('permissions == ' + permissionsNotifier.value[index].toString());
                                          permissionsNotifier.notifyListeners();
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
    //Retrieving data from TextFields
    final String name = _nameController.text, description = _descriptionController.text;
    //Retrieving data from CheckBoxes
    final String sale = permValueNotifier.value[0].isEmpty ? '0' : permValueNotifier.value[0],
        purchase = permValueNotifier.value[1].isEmpty ? '0' : permValueNotifier.value[1],
        products = permValueNotifier.value[2].isEmpty ? '0' : permValueNotifier.value[2],
        customer = permValueNotifier.value[3].isEmpty ? '0' : permValueNotifier.value[3],
        supplier = permValueNotifier.value[4].isEmpty ? '0' : permValueNotifier.value[4];

    final isFormValid = _formKey.currentState!;

    if (isFormValid.validate()) {
      log('Name = $name, Description = $description');
      log('sale = $sale, purchase = $purchase, products = $products, customer = $customer, supplier = $supplier');

      final GroupModel _groupModel = GroupModel(
        id: groupModel?.id,
        name: name,
        description: description,
      );

      final PermissionModel _permissionModel = PermissionModel(
          id: groupModel?.id, groupId: groupModel?.id, sale: sale, purchase: purchase, products: products, customer: customer, supplier: supplier);

      try {
        if (!isUpdate) {
          final int groupId = await GroupDatabase.instance.createGroup(_groupModel);
          await PermissionDatabase.instance.createPermission(_permissionModel.copyWith(groupId: groupId));
          kSnackBar(context: context, success: true, content: "Group Created Successfully!");
          Navigator.pop(context);
        } else {
          await GroupDatabase.instance.updateGroup(_groupModel);
          await PermissionDatabase.instance.updatePermissionByGroupId(_permissionModel);
          kSnackBar(context: context, update: true, content: "Group Updated Successfully!");
          Navigator.pop(context, _groupModel);
        }
        //Update fetched Group details from User-Utils
        await UserUtils.instance.updateGroupAndPermission;
      } catch (e) {
        kSnackBar(context: context, error: true, content: e.toString());
        return;
      }
    }
  }

  //========== Fetch Group Details ==========
  Future<void> getGroupDetails(GroupModel group) async {
    _nameController.text = group.name;
    _descriptionController.text = group.description;

    final PermissionModel _permission = await PermissionDatabase.instance.getPermissionByGroupId(group.id!);

    final sale = permissionsNotifier.value[0];
    final purchase = permissionsNotifier.value[1];
    final products = permissionsNotifier.value[2];
    final customer = permissionsNotifier.value[3];
    final supplier = permissionsNotifier.value[4];

    sale.update('perms', (value) {
      value[0] = _permission.sale.contains('1');
      value[1] = _permission.sale.contains('2');
      value[2] = _permission.sale.contains('3');
      value[3] = _permission.sale.contains('4');
      value[4] = _permission.sale.contains('1234');
      return value;
    });
    purchase.update('perms', (value) {
      value[0] = _permission.purchase.contains('1');
      value[1] = _permission.purchase.contains('2');
      value[2] = _permission.purchase.contains('3');
      value[3] = _permission.purchase.contains('4');
      value[4] = _permission.purchase.contains('1234');
      return value;
    });
    products.update('perms', (value) {
      value[0] = _permission.products.contains('1');
      value[1] = _permission.products.contains('2');
      value[2] = _permission.products.contains('3');
      value[3] = _permission.products.contains('4');
      value[4] = _permission.products.contains('1234');
      return value;
    });
    customer.update('perms', (value) {
      value[0] = _permission.customer.contains('1');
      value[1] = _permission.customer.contains('2');
      value[2] = _permission.customer.contains('3');
      value[3] = _permission.customer.contains('4');
      value[4] = _permission.customer.contains('1234');
      return value;
    });
    supplier.update('perms', (value) {
      value[0] = _permission.supplier.contains('1');
      value[1] = _permission.supplier.contains('2');
      value[2] = _permission.supplier.contains('3');
      value[3] = _permission.supplier.contains('4');
      value[4] = _permission.supplier.contains('1234');
      return value;
    });

    permissionsNotifier.value = [sale, purchase, products, customer, supplier];
    permValueNotifier.value = [_permission.sale, _permission.purchase, _permission.products, _permission.customer, _permission.supplier];

    permissionsNotifier.notifyListeners();
    permValueNotifier.notifyListeners();
  }
}
