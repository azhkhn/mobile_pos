import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/user_database.dart';
import 'package:shop_ez/model/user_model.dart';

class LoginAndSignUpButtons extends StatelessWidget {
  const LoginAndSignUpButtons({
    Key? key,
    required this.type,
    required this.username,
    this.email,
    required this.password,
  }) : super(key: key);
  final int type;
  final String username;
  final String? email;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          minWidth: 150,
          color: mainColor,
          onPressed: () async {
            if (type == 0) {
              await onSignUp(context);
            } else {
              await onLogin(context);
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

  Future<void> onLogin(BuildContext context) async {
    log('username == $username');
    log('password == $password');

    try {
      final result = await UserDatabase.instance.loginUser(username, password);
      log('isUser logged? = $result');
      Navigator.pushReplacementNamed(context, routeHome);
    } catch (e) {
      log(e.toString());
      showSnackBar(
          context: context, content: 'Incorrect username or password!');
      return;
    }
  }

  Future<void> onSignUp(BuildContext context) async {
    final _username = username;
    final _email = email;
    final _password = password;

    if (_username.isEmpty || _email!.isEmpty || _password.isEmpty) {
      log('Feilds cannot be empty!');
      showSnackBar(context: context, content: "Feilds Can't Be Empty!");
      return;
    }
    log('username = $_username, email = $_email, password = $_password');

    final _user =
        UserModel(username: _username, password: _password, email: _email);
    try {
      await UserDatabase.instance.createUser(_user, _username);
      showSnackBar(context: context, content: "User Registered Successfuly!");
      Navigator.pushReplacementNamed(context, routeLogin);
      return;
    } catch (e) {
      showSnackBar(context: context, content: "Username Already Exist!");
      return;
    }
  }

  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        // backgroundColor: Colors.black,
        // behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
