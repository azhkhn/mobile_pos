import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:shop_ez/widgets/wave_clip.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> obscureState = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final Size _screenSise = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await UserDatabase.instance.getAllUsers();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClip(),
              child: Container(
                width: _screenSise.width,
                height: _screenSise.height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    mainColor,
                    gradiantColor,
                  ],
                )),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //========== Top Image ==========
                SizedBox(
                  child: Center(
                    child: Image.asset(
                      'assets/images/pos.png',
                      width: _screenSise.width / 2.5,
                      // height: _screenSise.width / 3,
                    ),
                  ),
                  height: _screenSise.height / 2,
                ),

                //========== SignUp Feilds ==========
                SizedBox(
                  height: _screenSise.height / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: _screenSise.height / 2 / 10,
                            ),
                            TextFeildWidget(
                              controller: usernameController,
                              labelText: 'Username',
                              hintText: 'Phone number, username, or email',
                              hintStyle: kText12,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Username can't be empty*";
                                }
                                return null;
                              },
                            ),
                            ValueListenableBuilder(
                                valueListenable: obscureState,
                                builder: (context, bool obscure, _) {
                                  return TextFeildWidget(
                                    controller: passwordController,
                                    labelText: 'Password',
                                    prefixIcon: const Icon(
                                      Icons.security,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        if (obscure) {
                                          obscureState.value = false;
                                        } else {
                                          obscureState.value = true;
                                        }
                                      },
                                      icon: obscureState.value == false ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Password can't be empty*";
                                      }
                                      return null;
                                    },
                                    obscureText: !obscureState.value,
                                  );
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: kBlack),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                MaterialButton(
                                  minWidth: 150,
                                  color: mainColor,
                                  onPressed: () {
                                    onLogin(context);
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
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
                                    Navigator.pushReplacementNamed(context, routeSignUp);
                                  },
                                  child: const Text('Sign Up'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //========== Login and Verification ==========
  Future<void> onLogin(BuildContext context) async {
    final String _username = usernameController.text.trim(), _password = passwordController.text;

    log('username == $_username');
    log('password == $_password');

    final isFormValid = _formKey.currentState!;

    if (isFormValid.validate()) {
      try {
        await UserDatabase.instance.loginUser(_username, _password);
        log('User Signed Successfully!');
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
}

// class SignInFields extends StatelessWidget {
//   SignInFields({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Size _screenSise = MediaQuery.of(context).size;
//   }
// }
