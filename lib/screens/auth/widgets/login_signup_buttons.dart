import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/db/db_functions/group/group_database.dart';
import 'package:shop_ez/db/db_functions/permission/permission_database.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/model/group/group_model.dart';
import 'package:shop_ez/model/permission/permission_model.dart';
import 'package:shop_ez/screens/auth/pages/login_screen.dart';

import '../../../core/utils/snackbar/snackbar.dart';

class LoginAndSignUpButtons extends StatelessWidget {
  const LoginAndSignUpButtons({
    Key? key,
    required this.type,
    required this.formKey,
    this.username,
    this.password,
    this.mobileNumber,
    this.email,
    this.shopName,
    this.countryName,
    this.shopCategory,
    this.callback,
  }) : super(key: key);

  final int type;
  final String? username, password, mobileNumber, email, shopName, countryName, shopCategory;
  final Function? callback;

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          minWidth: 150,
          color: mainColor,
          onPressed: () {
            if (type == 0) {
              log('Getting Values...');
              callback!();
              onSignUp(context);
            } else {
              onLogin(context);
            }
          },
          child: Text(
            type == 1 ? 'Login' : 'Sign Up',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
            ),
            kWidth10,
            Text('or'),
            kWidth10,
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        MaterialButton(
          minWidth: 150,
          color: Colors.grey[300],
          onPressed: () {
            if (type == 1) {
              Navigator.pushReplacementNamed(context, routeSignUp);
            } else {
              Navigator.pushReplacementNamed(context, routeLogin);
            }
          },
          child: Text(type == 1 ? 'Sign Up' : 'Login'),
        ),
      ],
    );
  }

//========== Login and Verification ==========
  Future<void> onLogin(BuildContext context) async {
    final String _username = SignInFields.usernameController.value.text.trim();
    final String _password = SignInFields.passwordController.value.text.trim();

    log('username == $_username');
    log('password == $_password');

    final isFormValid = formKey.currentState!;

    if (isFormValid.validate()) {
      try {
        await UserDatabase.instance.loginUser(_username, _password);
        log('User Signed Successfully!');
        SignInFields.usernameController.value.clear();
        SignInFields.passwordController.value.clear();
        kSnackBar(context: context, success: true, content: 'User Logged In Successfully!');
        Navigator.pushReplacementNamed(context, routeHome);
      } catch (e) {
        log(e.toString());

        kSnackBar(
          context: context,
          error: true,
          content: e.toString(),
        );
        return;
      }
    }
  }

//========== SignUp and Verification ==========
  Future<void> onSignUp(BuildContext context) async {
    final isFormValid = formKey.currentState!;

    if (isFormValid.validate()) {
      log('shopName = $shopName, countryName = $countryName, shopCategory = $shopCategory, phoneNumber = $mobileNumber, email = $email, username = $username, password = $password');

      // Create group and permission for Owner if not exist
      await createGroupOwner();

      final _user = UserModel(
        groupId: 1,
        shopName: shopName!,
        countryName: countryName!,
        shopCategory: shopCategory!,
        mobileNumber: mobileNumber!,
        email: email,
        username: username!,
        password: password!,
        status: 1,
      );

      try {
        await UserDatabase.instance.createUser(_user);
        kSnackBar(
          context: context,
          success: true,
          content: "User Registered Successfully!",
        );
        Navigator.pushReplacementNamed(context, routeHome);
        return;
      } catch (e) {
        kSnackBar(context: context, error: true, content: e.toString());
        return;
      }
    }
  }

  Future<void> createGroupOwner() async {
    const GroupModel _groupModel = GroupModel(
      id: 1,
      name: 'Owner',
      description: 'Owner of the Business. Owner have full controll over the application',
    );
    const PermissionModel _permissionModel = PermissionModel(
      groupId: 1,
      sale: '1234',
      purchase: '1234',
      products: '1234',
      customer: '1234',
      supplier: '1234',
    );

    try {
      await GroupDatabase.instance.createGroup(_groupModel);
      await PermissionDatabase.instance.createPermission(_permissionModel);
    } catch (e) {
      log(e.toString());
    }
  }
}
