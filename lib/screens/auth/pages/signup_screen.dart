import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/mobile_number/mobile_number.dart';
import 'package:shop_ez/core/utils/permissions/permissions.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/db/db_functions/group/group_database.dart';
import 'package:shop_ez/db/db_functions/permission/permission_database.dart';
import 'package:shop_ez/infrastructure/api_service.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/model/group/group_model.dart';
import 'package:shop_ez/model/permission/permission_model.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:shop_ez/widgets/wave_clip.dart';
import 'package:url_launcher/url_launcher.dart';

final _futureValidateUser = FutureProvider.family.autoDispose((ref, String phoneNumber) async {
  final bool status = await ref.read(apiProvider).validateUser(phoneNumber);
  return status;
});

class ScreenSignUp extends ConsumerWidget {
  ScreenSignUp({Key? key}) : super(key: key);

  final List<String> items = ['Hyper Market', 'IT Company', 'Stationary', 'Mobile Shop', 'Bakery', 'Restaurent', 'Pharmacy', 'Other'];

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController countryNameController = TextEditingController();
  final TextEditingController shopCategoryController = TextEditingController();

  final ValueNotifier<bool> obscureStateNotifier = ValueNotifier(false);
  final ValueNotifier<bool> obscureStateConfirmNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size _screenSise = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: WaveClip(),
            child: Container(
              width: _screenSise.width,
              height: _screenSise.height / 2,
              decoration: const BoxDecoration(
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
                child: Padding(
                  //========== Dividing Screen Half and Half ==========
                  padding: EdgeInsets.only(
                    right: _screenSise.width * 0.05,
                    left: _screenSise.width * 0.05,
                    top: _screenSise.width * 0.10,
                    bottom: _screenSise.width * 0.10,
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
                            controller: shopNameController,
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
                            controller: countryNameController,
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
                                style: TextStyle(color: klabelColorGrey),
                              ),
                              prefixIcon: Icon(
                                Icons.store,
                                color: Colors.black,
                              ),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            isExpanded: true,
                            items: items.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              shopCategoryController.text = value.toString();
                            },
                            validator: (value) {
                              if (value == null || shopCategoryController.text.isEmpty) {
                                return 'This field is required*';
                              }
                              return null;
                            },
                          ),

                          //========== Mobile Number Field ==========
                          TextFeildWidget(
                            controller: mobileNumberController,
                            labelText: 'Mobile Number *',
                            textInputType: TextInputType.phone,
                            prefixIcon: const Icon(
                              Icons.smartphone,
                              color: Colors.black,
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'This field is required*';
                              } else if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(value)) {
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
                            controller: emailController,
                            labelText: 'Email',
                            textInputType: TextInputType.emailAddress,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
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

                          //========== Username Field ==========
                          TextFeildWidget(
                            controller: usernameController,
                            labelText: 'Username *',
                            textInputType: TextInputType.text,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => Validators.usernameValidator(value),
                          ),

                          //========== Password Field ==========
                          ValueListenableBuilder(
                              valueListenable: obscureStateNotifier,
                              builder: (context, bool obscure, _) {
                                return TextFeildWidget(
                                  controller: passwordController,
                                  labelText: 'Password *',
                                  textInputType: TextInputType.text,
                                  obscureText: !obscure,
                                  prefixIcon: const Icon(
                                    Icons.security,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      obscureStateNotifier.value = !obscure;
                                    },
                                    icon: !obscureStateNotifier.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) => Validators.passwordValidator(value),
                                );
                              }),

                          //========== Confirm Password Field ==========
                          ValueListenableBuilder(
                              valueListenable: obscureStateConfirmNotifier,
                              builder: (context, bool obscure, _) {
                                return TextFeildWidget(
                                  labelText: 'Confirm Password *',
                                  textInputType: TextInputType.text,
                                  obscureText: !obscure,
                                  prefixIcon: const Icon(
                                    Icons.security,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      obscureStateConfirmNotifier.value = !obscure;
                                    },
                                    icon: !obscure ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (passwordController.text == value) {
                                      return null;
                                    } else {
                                      return "Password do not match";
                                    }
                                  },
                                );
                              }),
                          kHeight20,

                          //========== SignUp Buttons and Actions ==========
                          signUpButton(context, ref)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //========== SignUp Buttons ==========
  Widget signUpButton(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        MaterialButton(
          minWidth: 150,
          color: mainColor,
          onPressed: () async {
            final bool _isGranted = await PermissionUtils.requestPermission(context, permission: Permission.phone);
            if (_isGranted) onSignUp(context, ref);
          },
          child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Expanded(child: Divider(thickness: 0.5, color: Colors.grey)),
            kWidth10,
            Text('or'),
            kWidth10,
            Expanded(child: Divider(thickness: 0.5, color: Colors.grey)),
          ],
        ),
        MaterialButton(
            minWidth: 150,
            color: Colors.grey[300],
            onPressed: () {
              Navigator.pushReplacementNamed(context, routeLogin);
            },
            child: const Text('Login')),
      ],
    );
  }

  //========== SignUp and Verification ==========
  Future<void> onSignUp(BuildContext context, WidgetRef ref) async {
    final isFormValid = _formStateKey.currentState!;

    final String username = usernameController.text.trim(),
        password = passwordController.text,
        mobileNumber = mobileNumberController.text.trim(),
        email = emailController.text.trim(),
        shopName = shopNameController.text.trim(),
        countryName = countryNameController.text.trim(),
        shopCategory = shopCategoryController.text.trim();

    if (isFormValid.validate()) {
      log('shopName = $shopName, countryName = $countryName, shopCategory = $shopCategory, phoneNumber = $mobileNumber, email = $email, username = $username, password = $password');

      final _future = ref.watch(_futureValidateUser(mobileNumber).future);

      _future.then((bool status) async {
        if (status == true) {
          //==== ==== ==== ==== ==== Verify User ==== ==== ==== ==== ====
          final bool _isVerified = await MobileNumberUtils.verifyMobileNumber(mobileNumber: mobileNumber);
          if (_isVerified) {
            // Create group and permission for Owner if not exist
            await createGroupOwner();

            final _user = UserModel(
              groupId: 1,
              shopName: shopName,
              countryName: countryName,
              shopCategory: shopCategory,
              mobileNumber: mobileNumber,
              email: email,
              username: username,
              password: password,
              status: 1,
            );

            try {
              await UserDatabase.instance.createUser(_user);
              kSnackBar(
                context: context,
                success: true,
                content: "User Registered Successfully!",
              );
              Navigator.pushReplacementNamed(context, routeHome);
              return;
            } catch (e) {
              kSnackBar(context: context, error: true, content: e.toString());
              return;
            }
          } else {
            kSnackBar(context: context, error: true, content: 'User verification failed. Please try again.');
          }
        } else {
          log('User not found. Please Contact Admin for Membership.');
          await contactUs(context);
        }
      });
    }
  }

//==== ==== ==== ==== ==== Contact US ==== ==== ==== ==== ====
  contactUs(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return KAlertDialog(
              submitText: 'Okay',
              submitAction: () => Navigator.pop(ctx),
              submitColor: kBlack,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('User not found. Please Contact Admin for Membership.'),
                  kHeight10,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Site: ',
                          style: kTextLite,
                          children: [
                            TextSpan(
                              text: 'https://www.systemsexpert.com.sa',
                              style: const TextStyle(color: kBlue),
                              recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('https://www.systemsexpert.com.sa')),
                            )
                          ],
                        ),
                      ),
                      kHeight10,
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Email: ',
                          style: kTextLite,
                          children: [
                            TextSpan(
                              text: 'info@systemsexpert.com.sa',
                              style: const TextStyle(color: kBlue),
                              recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('mailto:info@systemsexpert.com.sa')),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  kHeight20,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Site: ',
                          style: kTextLite,
                          children: [
                            TextSpan(
                              text: 'https://cignes.com',
                              style: const TextStyle(color: kBlue),
                              recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('https://cignes.com')),
                            )
                          ],
                        ),
                      ),
                      kHeight10,
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: 'Email: ',
                          style: kTextLite,
                          children: [
                            TextSpan(
                              text: 'info@cignes.com',
                              style: const TextStyle(color: kBlue),
                              recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('mailto:info@cignes.com')),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ));
        });
  }

  //========== Create Owner Group ==========
  Future<void> createGroupOwner() async {
    try {
      final List<GroupModel> groups = await GroupDatabase.instance.getAllGroups();

      if (groups.isEmpty) {
        const GroupModel _groupModel = GroupModel(
          id: 1,
          name: 'Owner',
          description: 'Owner of the Business. Owner have full controll over the application',
        );
        const PermissionModel _permissionModel = PermissionModel(
            groupId: 1, user: '1234', sale: '1234', purchase: '1234', returns: '1234', products: '1234', customer: '1234', supplier: '1234');
        const GroupModel _groupModelAdmin = GroupModel(
          id: 2,
          name: 'Admin',
          description: 'Admin has most of the previlege owner has only with few limitations',
        );
        const PermissionModel _permissionModelAdmin =
            PermissionModel(groupId: 2, user: '123', sale: '123', purchase: '123', returns: '123', products: '123', customer: '123', supplier: '123');

        // Creating group for Owner
        await GroupDatabase.instance.createGroup(_groupModel);
        await PermissionDatabase.instance.createPermission(_permissionModel);

        // Creating group for Admin
        await GroupDatabase.instance.createGroup(_groupModelAdmin);
        await PermissionDatabase.instance.createPermission(_permissionModelAdmin);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
