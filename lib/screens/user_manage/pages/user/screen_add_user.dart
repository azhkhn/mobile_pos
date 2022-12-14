// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/core/utils/validators/validators.dart';
import 'package:mobile_pos/db/db_functions/auth/user_db.dart';
import 'package:mobile_pos/db/db_functions/group/group_database.dart';
import 'package:mobile_pos/model/auth/user_model.dart';
import 'package:mobile_pos/model/group/group_model.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:mobile_pos/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenAddUser extends StatelessWidget {
  ScreenAddUser({
    Key? key,
    this.userModel,
  }) : super(key: key);

  //========== Model Class ==========
  final UserModel? userModel;

  //========== Value Notifier ==========
  final ValueNotifier<GroupModel?> _groupNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _obscureNotifier = ValueNotifier(true);
  final ValueNotifier<bool> _obscure2Notifier = ValueNotifier(true);

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //========== TextEditing Controllers ==========
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userModel != null) getUserDetails(userModel!);
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: userModel == null ? 'Add User' : 'Edit User',
      ),
      body: SafeArea(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  kHeight5,
                  //==================== User Group Field ====================
                  FutureBuilder(
                    future: GroupDatabase.instance.getAllGroups(),
                    builder: (context, dynamic snapshot) {
                      final snap = snapshot as AsyncSnapshot;
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                        default:
                          List<GroupModel> groups = snap.data;
                          if (userModel?.groupId == 1) groups = groups.where((group) => group.id == 1).toList();
                          if (userModel?.groupId != 1) groups.removeWhere((group) => group.id == 1);

                          return ValueListenableBuilder(
                              valueListenable: _groupNotifier,
                              builder: (context, GroupModel? group, _) {
                                return CustomDropDownField(
                                  labelText: 'User Group *',
                                  hintText: 'Select User Group',
                                  labelStyle: kText12,
                                  hintStyle: kText12,
                                  style: kText12Black,
                                  snapshot: groups,
                                  border: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  isDesne: true,
                                  value: group != null ? jsonEncode(group.toJson()) : null,
                                  onChanged: group?.id == 1
                                      ? null
                                      : (value) {
                                          final GroupModel _group = GroupModel.fromJson(jsonDecode(value));
                                          log(_group.name);
                                          log(_group.id.toString());

                                          _groupNotifier.value = _group;
                                        },
                                  validator: (value) {
                                    if (value == null || _groupNotifier.value == null) {
                                      return 'This field is required*';
                                    }
                                    return null;
                                  },
                                );
                              });
                      }
                    },
                  ),
                  kHeight10,

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
                    controller: _nameArabicController,
                    textDirection: TextDirection.rtl,
                    labelText: 'Name Arabic *',
                    textStyle: kText12,
                    isDense: true,
                    inputBorder: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputType: TextInputType.text,
                    validator: (value) => Validators.nullValidator(value),
                  ),
                  kHeight10,

                  //========== Contact Number Field ==========
                  TextFeildWidget(
                    controller: _contactNumberController,
                    labelText: 'Contact Number *',
                    textStyle: kText12,
                    isDense: true,
                    inputBorder: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => Validators.phoneValidator(value),
                  ),
                  kHeight10,

                  //========== Email Field ==========
                  TextFeildWidget(
                    controller: _emailController,
                    labelText: 'Email',
                    textStyle: kText12,
                    isDense: true,
                    inputBorder: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      // Check if the entered email has the right format
                      if (value!.isNotEmpty) {
                        if (!emailValidator.hasMatch(value)) {
                          return 'Please enter a valid Email';
                        }
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Address Field ==========
                  TextFeildWidget(
                    controller: _addressController,
                    labelText: 'Address',
                    textStyle: kText12,
                    isDense: true,
                    inputBorder: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Username Field ==========
                  TextFeildWidget(
                    controller: _usernameController,
                    labelText: 'Username *',
                    textStyle: kText12,
                    isDense: true,
                    inputBorder: const OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    textInputType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => Validators.usernameValidator(value),
                  ),
                  kHeight10,

                  //========== Password Field ==========
                  ValueListenableBuilder(
                      valueListenable: _obscureNotifier,
                      builder: (context, bool obscure, _) {
                        return TextFeildWidget(
                          controller: _passwordController,
                          labelText: 'Password *',
                          textStyle: kText12,
                          isDense: true,
                          inputBorder: const OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          textInputType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => Validators.passwordValidator(value),
                          obscureText: obscure,
                          suffixIcon: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              if (_obscureNotifier.value) {
                                _obscureNotifier.value = false;
                              } else {
                                _obscureNotifier.value = true;
                              }
                            },
                            icon: _obscureNotifier.value == false ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                          ),
                        );
                      }),
                  kHeight10,

                  //========== Password Field ==========
                  ValueListenableBuilder(
                      valueListenable: _obscure2Notifier,
                      builder: (context, bool obscure, _) {
                        return TextFeildWidget(
                          labelText: 'Confirm Password *',
                          textStyle: kText12,
                          isDense: true,
                          inputBorder: const OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          textInputType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (_passwordController.text == value) {
                              return null;
                            } else {
                              return "Password do not match";
                            }
                          },
                          obscureText: obscure,
                          suffixIcon: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              if (_obscure2Notifier.value) {
                                _obscure2Notifier.value = false;
                              } else {
                                _obscure2Notifier.value = true;
                              }
                            },
                            icon: _obscure2Notifier.value == false ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                          ),
                        );
                      }),

                  kHeight5,

                  //========== Submit Button ==========
                  FractionallySizedBox(
                      widthFactor: .8,
                      child: CustomMaterialBtton(
                        buttonText: userModel == null ? 'Create User' : 'Update User',
                        onPressed: () async {
                          if (userModel == null) {
                            return await addUser(context);
                          } else {
                            return await addUser(context, isUpdate: true);
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

  //========== Add User ==========
  Future<void> addUser(BuildContext context, {final bool isUpdate = false}) async {
    final isFormValid = _formKey.currentState!;
    final UserModel user = await UserUtils.instance.loggedUser;

    final int groupId = _groupNotifier.value!.id!;
    log('group Id = $groupId');

    final String shopName = user.shopName,
        countryName = user.countryName,
        shopCategory = user.shopCategory,
        name = _nameController.text,
        nameArabic = _nameArabicController.text,
        address = _addressController.text,
        mobileNumber = _contactNumberController.text,
        email = _emailController.text,
        username = _usernameController.text,
        password = _passwordController.text;

    if (isFormValid.validate()) {
      log('groupId = $groupId, shopName = $shopName, countryName = $countryName, shopCategory = $shopCategory, name = $name, nameArabic = $nameArabic, address = $address, phoneNumber = $mobileNumber, email = $email, username = $username, password = $password');

      final UserModel _userModel = UserModel(
        id: userModel?.id,
        groupId: groupId,
        shopName: shopName,
        countryName: countryName,
        shopCategory: shopCategory,
        name: name,
        nameArabic: nameArabic,
        address: address,
        mobileNumber: mobileNumber,
        email: email,
        username: username,
        password: password,
        status: 1,
      );
      try {
        if (!isUpdate) {
          await UserDatabase.instance.createUser(_userModel);
          kSnackBar(context: context, success: true, content: "User Registered Successfully!");
          return Navigator.pop(context);
        } else {
          final UserModel? _user = await UserDatabase.instance.updateUser(_userModel);
          kSnackBar(context: context, update: true, content: "User Updated Successfully!");
          return Navigator.pop(context, _user);
        }
      } catch (e) {
        kSnackBar(context: context, error: true, content: e.toString());
        return;
      }
    }
  }

  //========== Fetch User Details ==========
  void getUserDetails(UserModel user) async {
    //retieving values from Database to TextFields

    log('User == $user');
    _groupNotifier.value = await GroupDatabase.instance.getGroupById(user.groupId);
    _nameController.text = user.name ?? '';
    _nameArabicController.text = user.nameArabic ?? '';
    _addressController.text = user.address ?? '';
    _contactNumberController.text = user.mobileNumber;
    _emailController.text = user.email ?? '';
    _usernameController.text = user.username;
    _passwordController.text = user.password;
    _groupNotifier.notifyListeners();
  }
}
