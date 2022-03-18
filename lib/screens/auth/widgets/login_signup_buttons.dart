import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/user_database/user_db.dart';
import 'package:shop_ez/model/user/user_model.dart';

class LoginAndSignUpButtons extends StatelessWidget {
  LoginAndSignUpButtons.logIn({
    Key? key,
    required this.type,
    required this.username,
    required this.password,
    required this.formKey,
  }) : super(key: key);
  LoginAndSignUpButtons.signUp({
    Key? key,
    required this.type,
    required this.mobileNumber,
    required this.password,
    required this.email,
    required this.shopName,
    required this.countryName,
    required this.shopCategory,
    required this.formKey,
    required this.callback,
  }) : super(key: key);

  int type;
  late final String username,
      password,
      mobileNumber,
      email,
      shopName,
      countryName,
      shopCategory;
  late final Function callback;

  GlobalKey<FormState> formKey;

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
              callback();
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
        await UserDatabase.instance.loginUser(username, password);
        log('User found!');
        Navigator.pushReplacementNamed(context, routeHome);
      } catch (e) {
        log(e.toString());
        showSnackBar(
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
    final String _shopName = shopName,
        _countryName = countryName,
        _shopCategory = shopCategory,
        _mobileNumber = mobileNumber,
        _password = password;
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
        showSnackBar(
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
        showSnackBar(
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

  //========== Show SnackBar ==========
  void showSnackBar(
      {required BuildContext context,
      required String content,
      Color? color,
      Widget? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon ?? const Text(''),
            kWidth5,
            Flexible(
              child: Text(
                content,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
