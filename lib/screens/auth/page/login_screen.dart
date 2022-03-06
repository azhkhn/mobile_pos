import 'package:flutter/material.dart';
import 'package:shop_ez/db/user_database.dart';
import 'package:shop_ez/screens/auth/widgets/login_signup_buttons.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({Key? key}) : super(key: key);
  late Size _screenSise;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserDatabase.instance.getAllUsers();
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
                        LoginAndSignUpButtons(
                            type: 1,
                            username: _usernameController.text,
                            password: _passwordController.text)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
