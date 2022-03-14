import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/db/db_functions/category_database/category_db.dart';
import 'package:shop_ez/db/db_functions/user_database/user_db.dart';
import 'package:shop_ez/screens/auth/widgets/login_signup_buttons.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:shop_ez/widgets/wave_clip.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({Key? key}) : super(key: key);
  static late Size _screenSise;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _screenSise = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClip(),
              child: Container(
                width: _screenSise.width,
                height: _screenSise.height,
                decoration: BoxDecoration(
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
                SignInFields(
                    screenSise: _screenSise,
                    usernameController: _usernameController,
                    passwordController: _passwordController)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignInFields extends StatefulWidget {
  const SignInFields({
    Key? key,
    required Size screenSise,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
  })  : _screenSise = screenSise,
        _usernameController = usernameController,
        _passwordController = passwordController,
        super(key: key);

  final Size _screenSise;
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;
  static final _formStateKey = GlobalKey<FormState>();
  static bool obscureState = false;

  @override
  State<SignInFields> createState() => _SignInFieldsState();
}

class _SignInFieldsState extends State<SignInFields> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget._screenSise.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: SignInFields._formStateKey,
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: widget._screenSise.height / 2 / 10,
                ),
                TextFeildWidget(
                  controller: widget._usernameController,
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
                TextFeildWidget(
                  controller: widget._passwordController,
                  labelText: 'Password',
                  prefixIcon: const Icon(
                    Icons.security,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    color: Colors.black,
                    onPressed: () {
                      if (SignInFields.obscureState) {
                        setState(() {
                          SignInFields.obscureState = false;
                        });
                      } else {
                        setState(() {
                          SignInFields.obscureState = true;
                        });
                      }
                    },
                    icon: SignInFields.obscureState == false
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty*";
                    }
                    return null;
                  },
                  obscureText: !SignInFields.obscureState,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                LoginAndSignUpButtons.logIn(
                  type: 1,
                  username: widget._usernameController.text,
                  password: widget._passwordController.text,
                  formKey: SignInFields._formStateKey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget._usernameController.dispose();
    widget._passwordController.dispose();
    super.dispose();
  }
}
