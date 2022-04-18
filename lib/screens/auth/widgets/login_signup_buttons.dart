import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/model/auth/user_model.dart';

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
  final String? username,
      password,
      mobileNumber,
      email,
      shopName,
      countryName,
      shopCategory;
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
    log('username == $username');
    log('password == $password');

    final isFormValid = formKey.currentState!;

    if (isFormValid.validate()) {
      try {
        await UserDatabase.instance.loginUser(username!, password!);
        log('User Signed Successfully!');
        Navigator.pushReplacementNamed(context, routeHome);
      } catch (e) {
        log(e.toString());
        kSnackBar(
          context: context,
          color: kSnackBarErrorColor,
          icon: const Icon(
            Icons.new_releases_outlined,
            color: kSnackBarIconColor,
          ),
          content: 'Incorrect username or password!',
        );
        return;
      }
    }
  }

//========== SignUp and Verification ==========
  Future<void> onSignUp(BuildContext context) async {
    final String _shopName = shopName!,
        _countryName = countryName!,
        _shopCategory = shopCategory!,
        _mobileNumber = mobileNumber!,
        _password = password!;
    final String? _email = email;

    final isFormValid = formKey.currentState!;

    if (isFormValid.validate()) {
      log(
        'shopName = $_shopName, countryName = $_countryName, shopCategory = $_shopCategory, phoneNumber = $_mobileNumber, email = $_email, password = $_password',
      );

      final _user = UserModel(
        shopName: _shopName,
        countryName: _countryName,
        shopCategory: _shopCategory,
        mobileNumber: _mobileNumber,
        email: _email,
        password: _password,
      );
      try {
        await UserDatabase.instance.createUser(_user, _mobileNumber);
        kSnackBar(
          context: context,
          color: kSnackBarSuccessColor,
          icon: const Icon(
            Icons.done,
            color: kSnackBarIconColor,
          ),
          content: "User Registered Successfully!",
        );
        Navigator.pushReplacementNamed(context, routeHome);
        return;
      } catch (e) {
        kSnackBar(
          context: context,
          color: kSnackBarErrorColor,
          icon: const Icon(
            Icons.new_releases_outlined,
            color: kSnackBarIconColor,
          ),
          content: "Username Already Exist!",
        );
        return;
      }
    }
  }
}
