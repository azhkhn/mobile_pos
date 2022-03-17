import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/auth/widgets/login_signup_buttons.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:shop_ez/widgets/wave_clip.dart';

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp({Key? key}) : super(key: key);
  static late Size _screenSise;

  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  @override
  Widget build(BuildContext context) {
    ScreenSignUp._screenSise = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClip(),
            child: Container(
              width: ScreenSignUp._screenSise.width,
              height: ScreenSignUp._screenSise.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    mainColor,
                    gradiantColor,
                  ],
                ),
              ),
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
                    width: ScreenSignUp._screenSise.width / 5,
                    // height: _screenSise.width / 3,
                  ),
                ),
                height: ScreenSignUp._screenSise.height / 4,
              ),

              //========== SignUp Feilds ==========
              Expanded(
                child: SignUpFields(callback: callback),
              ),
            ],
          ),
        ],
      ),
    );
  }

//For retrieving value from TextFields (instead of State-Management)
  callback() {
    log('ScreenSignUp() => called!');
    setState(() {});
  }
}

class SignUpFields extends StatefulWidget {
  static const items = [
    'Hyper Market',
    'IT Company',
    'Stationary',
    'Mobile Shop',
    'Bakery',
    'Restaurent',
    'Pharmacy',
    'Other'
  ];
  const SignUpFields({
    Key? key,
    required this.callback,
  }) : super(key: key);

  final Function callback;
  static final _formStateKey = GlobalKey<FormState>();
  static final TextEditingController shopNameController =
      TextEditingController();
  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();
  static final TextEditingController mobileNumberController =
      TextEditingController();
  static final TextEditingController countryNameController =
      TextEditingController();
  static String shopCategoryController = 'null';
  static bool obscureState = false;
  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  late Size _screenSise;

  @override
  Widget build(BuildContext context) {
    log('build() => called!');
    _screenSise = MediaQuery.of(context).size;
    return Padding(
      //========== Dividing Screen Half and Half ==========
      padding: EdgeInsets.only(
        right: _screenSise.width * 0.05,
        left: _screenSise.width * 0.05,
        top: _screenSise.width * 0.10,
        bottom: _screenSise.width * 0.10,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: SignUpFields._formStateKey,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //========== Shop Name Field ==========
              TextFeildWidget(
                controller: SignUpFields.shopNameController,
                labelText: 'Shop Name *',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(
                  Icons.business,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required*';
                  }
                  return null;
                },
              ),

              //========== Country Name Field ==========
              TextFeildWidget(
                controller: SignUpFields.countryNameController,
                labelText: 'Country *',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(
                  Icons.flag,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required*';
                  }
                  return null;
                },
              ),

              //========== Shop Category DropDown Button ==========
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text(
                    'Shop Category *',
                    style: TextStyle(color: Colors.black),
                  ),
                  prefixIcon: Icon(
                    Icons.store,
                    color: Colors.black,
                  ),
                ),
                isExpanded: true,
                items: SignUpFields.items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    SignUpFields.shopCategoryController = value.toString();
                  });
                },
                validator: (value) {
                  if (value == null ||
                      SignUpFields.shopCategoryController == 'null') {
                    return 'This field is required*';
                  }
                  return null;
                },
              ),

              //========== Mobile Number Field ==========
              TextFeildWidget(
                controller: SignUpFields.mobileNumberController,
                labelText: 'Mobile Number *',
                textInputType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.smartphone,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required*';
                  } else if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$')
                      .hasMatch(value)) {
                    if (value.length != 10) {
                      return 'Mobile number must 10 digits';
                    } else {
                      return 'Please enter a valid Phone Number';
                    }
                  }

                  return null;
                },
              ),

              //========== Email Field ==========
              TextFeildWidget(
                controller: SignUpFields.emailController,
                labelText: 'Email',
                textInputType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  } else {
                    // Check if the entered email has the right format
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid Email';
                    }
                  }
                  // Return null if the entered email is valid
                  return null;
                },
              ),

              //========== Password Field ==========
              TextFeildWidget(
                controller: SignUpFields.passwordController,
                labelText: 'Password *',
                textInputType: TextInputType.text,
                obscureText: !SignUpFields.obscureState,
                prefixIcon: const Icon(
                  Icons.security,
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    if (SignUpFields.obscureState) {
                      setState(() {
                        SignUpFields.obscureState = false;
                      });
                    } else {
                      setState(() {
                        SignUpFields.obscureState = true;
                      });
                    }
                  },
                  icon: SignUpFields.obscureState == false
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required*';
                  }
                  if (value.trim().length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  // Return null if the entered password is valid
                  return null;
                },
              ),
              kHeight20,

              //========== Login Buttons and Actions ==========
              LoginAndSignUpButtons.signUp(
                type: 0,
                shopName: SignUpFields.shopNameController.text.trim(),
                countryName: SignUpFields.countryNameController.text.trim(),
                shopCategory: SignUpFields.shopCategoryController,
                mobileNumber: SignUpFields.mobileNumberController.text.trim(),
                email: SignUpFields.emailController.text.trim(),
                password: SignUpFields.passwordController.text.trim(),
                formKey: SignUpFields._formStateKey,
                callback: widget.callback,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SignUpFields.shopNameController.text = '';
    SignUpFields.countryNameController.text = '';
    SignUpFields.mobileNumberController.text = '';
    SignUpFields.emailController.text = '';
    SignUpFields.passwordController.text = '';
    super.dispose();
  }
}
