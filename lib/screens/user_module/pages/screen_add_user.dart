import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenAddUser extends StatelessWidget {
  ScreenAddUser({
    Key? key,
  }) : super(key: key);

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> items = ['Admin', 'Sales'];

  //========== TextEditing Controllers ==========
  final TextEditingController _userGroupController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameArabicController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add User',
      ),
      body: ItemScreenPaddingWidget(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //========== User Group Field ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                      label: Text(
                        'User Group *',
                        style: TextStyle(color: klabelColorGrey),
                      ),
                      hintText: 'Select User Group',
                      hintStyle: kText12,
                      isDense: true,
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.all(10)),
                  isExpanded: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: items
                      .map(
                        (values) => DropdownMenuItem(value: values, child: Text(values)),
                      )
                      .toList(),
                  onChanged: (value) {
                    _userGroupController.text = value.toString();
                    log('User Type = ${_userGroupController.text}');
                  },
                  validator: (String? value) {
                    if (value == null || _userGroupController.text.isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),

                kHeight10,

                //========== Name Field ==========
                TextFeildWidget(
                  controller: _nameController,
                  labelText: 'Name *',
                  isDense: true,
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
                  isDense: true,
                  inputBorder: const OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  textInputType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required*';
                    } else if (value.contains(' ')) {
                      return 'Username cannot contain space*';
                    }
                    return null;
                  },
                ),
                kHeight10,

                //========== Password Field ==========
                TextFeildWidget(
                  controller: _passwordController,
                  labelText: 'Password *',
                  isDense: true,
                  inputBorder: const OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  textInputType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Validators.passwordValidator(value),
                ),
                kHeight10,

                //========== Password Field ==========
                TextFeildWidget(
                  labelText: 'Confirm Password *',
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
                ),

                kHeight5,

                //========== Submit Button ==========
                FractionallySizedBox(
                    widthFactor: .8,
                    child: CustomMaterialBtton(
                      buttonText: 'Create User',
                      onPressed: () async => addUser(context),
                    )),
                kHeight10
              ],
            ),
          ),
        ),
      ),
    );
  }

  //========== Add User ==========
  Future<void> addUser(BuildContext context) async {
    final isFormValid = _formKey.currentState!;
    final UserModel userModel = await UserUtils.instance.loggedUser;

    final String shopName = userModel.shopName,
        countryName = userModel.countryName,
        shopCategory = userModel.shopCategory,
        userGroup = _userGroupController.text,
        name = _nameController.text,
        nameArabic = _nameArabicController.text,
        address = _addressController.text,
        mobileNumber = _contactNumberController.text,
        email = _emailController.text,
        username = _usernameController.text,
        password = _passwordController.text;

    if (isFormValid.validate()) {
      log('userGroup = $userGroup, shopName = $shopName, countryName = $countryName, shopCategory = $shopCategory, name = $name, nameArabic = $nameArabic, address = $address, phoneNumber = $mobileNumber, email = $email, username = $username, password = $password');

      final _user = UserModel(
        userGroup: userGroup,
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
      );
      try {
        await UserDatabase.instance.createUser(_user);
        kSnackBar(
          context: context,
          success: true,
          content: "User Registered Successfully!",
        );
        Navigator.pop(context);
        return;
      } catch (e) {
        kSnackBar(context: context, error: true, content: e.toString());
        return;
      }
    }
  }

  //========== Reset Supplier Fields ==========
  void resetSupplier() {
    _nameController.clear();
    _nameArabicController.clear();
    _usernameController.clear();
    _contactNumberController.clear();
    _emailController.clear();
  }
}
