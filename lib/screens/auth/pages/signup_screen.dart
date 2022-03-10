import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/auth/widgets/login_signup_buttons.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:shop_ez/widgets/wave_clip.dart';

class ScreenSignUp extends StatelessWidget {
  ScreenSignUp({Key? key}) : super(key: key);
  late Size _screenSise;

  @override
  Widget build(BuildContext context) {
    _screenSise = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClip(),
            child: Container(
              width: _screenSise.width,
              height: _screenSise.height / 2,
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
                    width: _screenSise.width / 5,
                    // height: _screenSise.width / 3,
                  ),
                ),
                height: _screenSise.height / 4,
              ),

              //========== SignUp Feilds ==========
              Expanded(
                child: SignUpFeilds(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SignUpFeilds extends StatelessWidget {
  static const items = [
    'Hyper Market',
    'Stationary',
    'Mobile Shop',
    'Bakery',
    'Restaurent',
    'Pharmacy'
  ];
  SignUpFeilds({
    Key? key,
  }) : super(key: key);

  late Size _screenSise;
  final _shopNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _cPpasswordController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _countryNameController = TextEditingController();
  final _shopCategoryController = TextEditingController();
  static final _formStateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _screenSise = MediaQuery.of(context).size;
    return Padding(
      //========== Dividing Screen Half and Half ==========
      padding: EdgeInsets.only(
        // bottom: _screenSise.width * 0.10,
        right: _screenSise.width * 0.05,
        left: _screenSise.width * 0.05,
        top: _screenSise.width * 0.10,
        // top: _screenSise.height / 10 / 10,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formStateKey,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //========== Shop Name Field ==========
              TextFeildWidget(
                textEditingController: _shopNameController,
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
                  // if (value.trim().length < 4) {
                  //   return 'Username must be at least 4 characters in length';
                  // }
                  // Return null if the entered username is valid
                  return null;
                },
              ),

              //========== Country Name Field ==========
              TextFeildWidget(
                textEditingController: _countryNameController,
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
                  // if (value.trim().length < 4) {
                  //   return 'Username must be at least 4 characters in length';
                  // }
                  // Return null if the entered username is valid
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
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (_) {},
              ),

              //========== Mobile Number Field ==========
              TextFeildWidget(
                textEditingController: _mobileNumberController,
                labelText: 'Mobile Number *',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(
                  Icons.smartphone,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required*';
                  }
                  // if (value.trim().length < 4) {
                  //   return 'Username must be at least 4 characters in length';
                  // }
                  // Return null if the entered username is valid
                  return null;
                },
              ),

              //========== Email Field ==========
              TextFeildWidget(
                textEditingController: _emailController,
                labelText: 'Email',
                textInputType: TextInputType.text,
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
                textEditingController: _passwordController,
                labelText: 'Password *',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(
                  Icons.security,
                  color: Colors.black,
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
                shopName: _shopNameController.text.trim(),
                countryName: _countryNameController.text.trim(),
                shopCategory: _shopCategoryController.text.trim(),
                mobileNumber: _mobileNumberController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
                formKey: _formStateKey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
