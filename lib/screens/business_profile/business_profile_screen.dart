import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/busiess_profile/business_profile_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({Key? key}) : super(key: key);

  @override
  State<BusinessProfile> createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  //========== Image File Path ==========
  File? image, selectedImage;
  File? oldImage;

  //========== Database Instances ==========
  final businessProfileDB = BusinessProfileDatabase.instance;

  //========== Image File Path ==========
  final _formKey = GlobalKey<FormState>();

  //========== MediaQuery Screen Size ==========
  late Size _screenSize;

  //========== Text Editing Controllers ==========
  final _businessNameController = TextEditingController();
  final _businessNameArabicController = TextEditingController();
  final _billerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressArabicController = TextEditingController();
  final _cityController = TextEditingController();
  final _cityArabicController = TextEditingController();
  final _stateController = TextEditingController();
  final _stateArabicController = TextEditingController();
  final _countryController = TextEditingController();
  final _countryArabicController = TextEditingController();
  final _vatNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();

  //========== Focus Node for TextFields ==========
  final FocusNode _businessNameFocusNode = FocusNode();
  final FocusNode _businessNameArabicFocusNode = FocusNode();
  final FocusNode _billerNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _addressArabicFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _cityArabicFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _stateArabicFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _countryArabicFocusNode = FocusNode();

  @override
  void didChangeDependencies() async {
    await getBusinessProfileModel();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(title: 'Business Profile'),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //========== Business Name ==========
                  TextFeildWidget(
                    labelText: 'Business Name *',
                    controller: _businessNameController,
                    focusNode: _businessNameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Business Name Arabic ==========
                  TextFeildWidget(
                    labelText: 'Business Name Arabic *',
                    controller: _businessNameArabicController,
                    textDirection: TextDirection.rtl,
                    focusNode: _businessNameArabicFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Biller Name ==========
                  TextFeildWidget(
                    labelText: 'Biller Name *',
                    controller: _billerNameController,
                    focusNode: _billerNameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Address ==========
                  TextFeildWidget(
                    labelText: 'Address *',
                    controller: _addressController,
                    focusNode: _addressFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Address Arabic ==========
                  TextFeildWidget(
                    labelText: 'Address Arabic *',
                    controller: _addressArabicController,
                    textDirection: TextDirection.rtl,
                    focusNode: _addressArabicFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== City ==========
                  TextFeildWidget(
                    labelText: 'City *',
                    controller: _cityController,
                    focusNode: _cityFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== City Arabic ==========
                  TextFeildWidget(
                    labelText: 'City Arabic *',
                    controller: _cityArabicController,
                    textDirection: TextDirection.rtl,
                    focusNode: _cityArabicFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== State ==========
                  TextFeildWidget(
                    labelText: 'State *',
                    controller: _stateController,
                    focusNode: _stateFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== State Arabic ==========
                  TextFeildWidget(
                    labelText: 'State Arabic *',
                    controller: _stateArabicController,
                    textDirection: TextDirection.rtl,
                    focusNode: _stateArabicFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Country ==========
                  TextFeildWidget(
                    labelText: 'Country *',
                    controller: _countryController,
                    focusNode: _countryFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Country Arabic ==========
                  TextFeildWidget(
                    labelText: 'Country Arabic *',
                    controller: _countryArabicController,
                    textDirection: TextDirection.rtl,
                    focusNode: _countryArabicFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== VAT Number ==========
                  TextFeildWidget(
                    labelText: 'VAT Number',
                    controller: _vatNumberController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (value.length != 15) {
                          return 'Please enter a valid VAT number';
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Phone Number ==========
                  TextFeildWidget(
                    labelText: 'Phone Number',
                    controller: _phoneNumberController,
                    textInputType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      } else {
                        if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(value)) {
                          if (value.length != 10) {
                            return 'Mobile number must 10 digits';
                          } else {
                            return 'Please enter a valid Phone Number';
                          }
                        }
                      }

                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Email ==========
                  TextFeildWidget(
                    labelText: 'Email',
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
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
                  kHeight20,

                  //========== Item Image ==========
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kHeight10,
                      InkWell(
                        onTap: () => imagePopUp(context),
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                width: _screenSize.width / 2.5,
                                height: _screenSize.width / 2.5,
                                fit: BoxFit.fill,
                              )
                            : Icon(
                                Icons.add_photo_alternate_outlined,
                                size: _screenSize.width / 10,
                              ),
                      ),
                      kHeight10,
                      const Text(
                        'Logo',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  kHeight20,

                  //========== Submit ==========
                  CustomMaterialBtton(
                    onPressed: () => addBusinessProfile(),
                    buttonText: 'Submit',
                  ),
                  kHeight10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //========== Image PopUp ==========
  void imagePopUp(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                imagePicker(ImageSource.camera);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Gallery'),
              onTap: () {
                imagePicker(ImageSource.gallery);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //========== Image Picker ==========
  Future<void> imagePicker(ImageSource imageSource) async {
    final imagePicker = ImagePicker();
    try {
      final _file = await imagePicker.pickImage(source: imageSource);
      if (_file == null) return;

      final imageFile = File(_file.path);

      final _imageCropped = await imageCropper(imageFile);
      if (_imageCropped == null) return;
      selectedImage = _imageCropped;
      log('selected Image = $selectedImage');

      setState(() {});

      // blobImage = await selectedImage.readAsBytes();
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }

  //========== Image Cropper ==========
  Future<File?> imageCropper(File imageFile) async {
    return await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original],
      androidUiSettings: const AndroidUiSettings(toolbarTitle: 'Crop Image'),
    );
  }

  //========== Add Business Profile ==========
  addBusinessProfile() async {
    final String business,
        businessArabic,
        billerName,
        address,
        addressArabic,
        city,
        cityArabic,
        state,
        stateArabic,
        country,
        countryArabic,
        vatNumber,
        phoneNumber,
        email,
        logo;

    //Retieving values from TextFields
    business = _businessNameController.text.trim();
    businessArabic = _businessNameArabicController.text.trim();
    billerName = _billerNameController.text.trim();
    address = _addressController.text.trim();
    addressArabic = _addressArabicController.text.trim();
    city = _cityController.text.trim();
    cityArabic = _cityArabicController.text.trim();
    state = _stateController.text.trim();
    stateArabic = _stateArabicController.text.trim();
    country = _countryController.text.trim();
    countryArabic = _countryArabicController.text.trim();
    vatNumber = _vatNumberController.text.trim();
    phoneNumber = _phoneNumberController.text.trim();
    email = _emailController.text.trim();
    if (selectedImage != null && oldImage == null) {
      //========== Getting Directory Path ==========
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      // final fileName = basename(selectedImage!.path);
      final String filePath = '$dirPath/$fileName.jpg';
      log('filePath = $filePath');

      //========== Coping Image to new path ==========
      image = await selectedImage!.copy(filePath);
      logo = image!.path;
    } else if (selectedImage != null) {
      logo = selectedImage!.path;
    } else {
      logo = '';
    }

    //========== Validating Text Form Fields ==========
    final _formState = _formKey.currentState!;
    if (_formState.validate()) {
      final _businessProfileModel = BusinessProfileModel(
          business: business,
          businessArabic: businessArabic,
          billerName: billerName,
          address: address,
          addressArabic: addressArabic,
          city: city,
          cityArabic: cityArabic,
          state: state,
          stateArabic: stateArabic,
          country: country,
          countryArabic: countryArabic,
          vatNumber: vatNumber,
          phoneNumber: phoneNumber,
          email: email,
          logo: logo);

      try {
        await businessProfileDB.createBusinessProfile(_businessProfileModel);
        UserUtils().getBusinessProfile();
        Navigator.pop(context);
        log('Profile Updated!');

        kSnackBar(context: context, success: true, content: 'Profile updated successfully!');
      } catch (e) {
        log(e.toString());
        log('Something went wrong!');
      }
    } else {
      if (business.isEmpty) {
        _businessNameFocusNode.requestFocus();
      } else if (businessArabic.isEmpty) {
        _businessNameArabicFocusNode.requestFocus();
      } else if (address.isEmpty) {
        _addressFocusNode.requestFocus();
      } else if (addressArabic.isEmpty) {
        _addressArabicFocusNode.requestFocus();
      } else if (city.isEmpty) {
        _cityFocusNode.requestFocus();
      } else if (cityArabic.isEmpty) {
        _cityArabicFocusNode.requestFocus();
      } else if (state.isEmpty) {
        _stateFocusNode.requestFocus();
      } else if (stateArabic.isEmpty) {
        _stateArabicFocusNode.requestFocus();
      } else if (country.isEmpty) {
        _countryFocusNode.requestFocus();
      } else if (countryArabic.isEmpty) {
        _countryArabicFocusNode.requestFocus();
      }
    }
  }

  //========== Get Business Profile Details ==========
  getBusinessProfileModel() async {
    final _businessProfileModel = await businessProfileDB.getBusinessProfile();

    if (_businessProfileModel != null) {
      _businessNameController.text = _businessProfileModel.business;
      _businessNameArabicController.text = _businessProfileModel.businessArabic;
      _billerNameController.text = _businessProfileModel.billerName;
      _addressController.text = _businessProfileModel.address;
      _addressArabicController.text = _businessProfileModel.addressArabic;
      _cityController.text = _businessProfileModel.city;
      _cityArabicController.text = _businessProfileModel.cityArabic;
      _stateController.text = _businessProfileModel.state;
      _stateArabicController.text = _businessProfileModel.stateArabic;
      _countryController.text = _businessProfileModel.country;
      _countryArabicController.text = _businessProfileModel.countryArabic;
      _vatNumberController.text = _businessProfileModel.vatNumber;
      _phoneNumberController.text = _businessProfileModel.phoneNumber;
      _emailController.text = _businessProfileModel.email;
      if (_businessProfileModel.logo != '') {
        selectedImage = File(_businessProfileModel.logo);
        oldImage = File(_businessProfileModel.logo);
      }

      setState(() {});
    }
  }
}
