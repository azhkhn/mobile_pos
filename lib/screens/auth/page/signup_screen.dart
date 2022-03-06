import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/auth/widgets/login_signup_buttons.dart';

class ScreenSignUp extends StatelessWidget {
  ScreenSignUp({Key? key}) : super(key: key);
  late Size _screenSise;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _cPpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _screenSise = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: _screenSise.width,
          height: _screenSise.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/1.jpg'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //========== Top Image ==========
              SizedBox(
                child: Center(
                  child: Image.asset(
                    'assets/images/2.png',
                    width: _screenSise.width / 2.5,
                    // height: _screenSise.width / 3,
                  ),
                ),
                height: _screenSise.height / 2,
              ),

              //========== Bottom Feilds ==========
              SizedBox(
                height: _screenSise.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SingleChildScrollView(
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _screenSise.height / 2 / 10,
                        ),
                        // kHeight20,
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            label: Text(
                              'Username',
                              style: TextStyle(color: Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            label: Text(
                              'Email',
                              style: TextStyle(color: Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text(
                              'Password',
                              style: TextStyle(color: Colors.black),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        kHeight20,
                        LoginAndSignUpButtons(
                          type: 0,
                          username: _usernameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
