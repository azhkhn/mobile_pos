import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class ScreenSupplier extends StatelessWidget {
  ScreenSupplier({
    Key? key,
    this.purchase = false,
  }) : super(key: key);

  final bool purchase;

  static late Size _screenSize;
  final _formKey = GlobalKey<FormState>();
  final _supplierNameController = TextEditingController();
  final _supplierNameArabicController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _vatNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressArabicController = TextEditingController();
  final _cityController = TextEditingController();
  final _cityArabicController = TextEditingController();
  final _stateController = TextEditingController();
  final _stateArabicController = TextEditingController();
  final _countryController = TextEditingController();
  final _countryArabicController = TextEditingController();
  final _poBoxController = TextEditingController();

  static final supplierDB = SupplierDatabase.instance;
  getSupplier() async {
    await supplierDB.getAllSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    getSupplier();
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Supplier',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //========== Supplier Field ==========
                  TextFeildWidget(
                    controller: _supplierNameController,
                    labelText: 'Supplier Name *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Supplier Arabic Field ==========
                  TextFeildWidget(
                    controller: _supplierNameArabicController,
                    textDirection: TextDirection.rtl,
                    labelText: 'Supplier Name Arabic *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Contact Name Field ==========
                  TextFeildWidget(
                    controller: _contactNameController,
                    labelText: 'Contact Name *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Contact Number Field ==========
                  TextFeildWidget(
                    controller: _contactNumberController,
                    labelText: 'Contact Number *',
                    textInputType: TextInputType.phone,
                    validator: (value) => Validators.phoneValidator(value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  kHeight10,

                  //========== VAT Number Field ==========
                  TextFeildWidget(
                    controller: _vatNumberController,
                    labelText: 'VAT Number',
                    textInputType: TextInputType.text,
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

                  //========== Email Field ==========
                  TextFeildWidget(
                    controller: _emailController,
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      // Check if the entered email has the right format
                      if (value!.isNotEmpty) {
                        if (!emailValidator.hasMatch(value)) {
                          return 'Please enter a valid Email';
                        }
                      }
                      return null;
                    },
                  ),

                  kHeight10,

                  //========== Address Field ==========
                  TextFeildWidget(
                    controller: _addressController,
                    labelText: 'Address',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Address Arabic Field ==========
                  TextFeildWidget(
                    controller: _addressArabicController,
                    textDirection: TextDirection.rtl,
                    labelText: 'Address Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== City Field ==========
                  TextFeildWidget(
                    controller: _cityController,
                    labelText: 'City',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== City Arabic Field ==========
                  TextFeildWidget(
                    controller: _cityArabicController,
                    textDirection: TextDirection.rtl,
                    labelText: 'City Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== State Field ==========
                  TextFeildWidget(
                    controller: _stateController,
                    labelText: 'State',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== State Arabic Field ==========
                  TextFeildWidget(
                    controller: _stateArabicController,
                    textDirection: TextDirection.rtl,
                    labelText: 'State Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Country Field ==========
                  TextFeildWidget(
                    controller: _countryController,
                    labelText: 'Country',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Country Arabic Field ==========
                  TextFeildWidget(
                    controller: _countryArabicController,
                    textDirection: TextDirection.rtl,
                    labelText: 'Country Arabic',
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== PO Box Field ==========
                  TextFeildWidget(
                    controller: _poBoxController,
                    labelText: 'PO Box',
                    textInputType: TextInputType.text,
                  ),
                  kHeight20,

                  //========== Submit Button ==========
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _screenSize.width / 10),
                    child: CustomMaterialBtton(buttonText: 'Submit', onPressed: () => addSuppler(context: context)),
                  ),
                  kHeight10
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //========== Add Supplier ==========
  Future<void> addSuppler({context}) async {
    final String supplierName,
        supplierNameArabic,
        contactName,
        contactNumber,
        vatNumber,
        email,
        address,
        addressArabic,
        city,
        cityArabic,
        state,
        stateArabic,
        country,
        countryArabic,
        poBox;

    final _formState = _formKey.currentState!;
    if (_formState.validate()) {
      //retieving values from TextFields to String
      supplierName = _supplierNameController.text;
      supplierNameArabic = _supplierNameArabicController.text;
      contactName = _contactNameController.text;
      contactNumber = _contactNumberController.text;
      vatNumber = _vatNumberController.text;
      email = _emailController.text;
      address = _addressController.text;
      addressArabic = _addressArabicController.text;
      city = _cityController.text;
      cityArabic = _cityArabicController.text;
      state = _stateArabicController.text;
      stateArabic = _stateArabicController.text;
      country = _countryController.text;
      countryArabic = _countryArabicController.text;
      poBox = _poBoxController.text;

      final _supplierModel = SupplierModel(
        supplierName: supplierName,
        supplierNameArabic: supplierNameArabic,
        contactName: contactName,
        contactNumber: contactNumber,
        vatNumber: vatNumber,
        email: email,
        address: address,
        addressArabic: addressArabic,
        city: city,
        cityArabic: cityArabic,
        state: state,
        stateArabic: stateArabic,
        country: country,
        countryArabic: countryArabic,
        poBox: poBox,
      );
      try {
        final id = await supplierDB.createSupplier(_supplierModel);
        resetSupplier();
        log('Supplier $supplierName Added!');
        kSnackBar(context: context, success: true, content: 'Supplier "$supplierName" added successfully!');
        if (purchase) {
          Navigator.pop(context, id);
        }
      } catch (e) {
        log('Supplier $supplierName Already Exist!');
        kSnackBar(context: context, error: true, content: 'Supplier "$supplierName" already exist!');
      }
    }
  }

  //========== Reset Supplier Fields ==========
  void resetSupplier() {
    _supplierNameController.clear();
    _supplierNameArabicController.clear();
    _contactNameController.clear();
    _contactNumberController.clear();
    _vatNumberController.clear();
    _emailController.clear();
    _addressController.clear();
    _addressArabicController.clear();
    _cityController.clear();
    _cityArabicController.clear();
    _stateArabicController.clear();
    _stateArabicController.clear();
    _countryController.clear();
    _countryArabicController.clear();
    _poBoxController.clear();
  }
}
