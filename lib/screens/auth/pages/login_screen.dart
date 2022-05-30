import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/screens/auth/widgets/login_signup_buttons.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:shop_ez/widgets/wave_clip.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({Key? key}) : super(key: key);

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
                const SignInFields(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignInFields extends StatelessWidget {
  const SignInFields({
    Key? key,
  }) : super(key: key);

  static final ValueNotifier<TextEditingController> usernameController = ValueNotifier(TextEditingController());
  static final ValueNotifier<TextEditingController> passwordController = ValueNotifier(TextEditingController());
  static final _formStateKey = GlobalKey<FormState>();
  static ValueNotifier<bool> obscureState = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final Size _screenSise = MediaQuery.of(context).size;
    return SizedBox(
      height: _screenSise.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formStateKey,
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: _screenSise.height / 2 / 10,
                ),
                TextFeildWidget(
                  controller: usernameController.value,
                  labelText: 'Username',
                  hintText: 'Phone number or email',
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
                        controller: passwordController.value,
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
                LoginAndSignUpButtons(
                  type: 1,
                  formKey: _formStateKey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
