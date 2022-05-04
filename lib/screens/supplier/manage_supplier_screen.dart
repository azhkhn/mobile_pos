import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/text/validators.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class ScreenManageSupplier extends StatelessWidget {
  ScreenManageSupplier({
    Key? key,
    this.purchase = false,
  }) : super(key: key);

  final bool purchase;

  static late Size _screenSize;
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _companyArabicController = TextEditingController();
  final _supplierController = TextEditingController();
  final _supplierArabicController = TextEditingController();
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
                  //========== Company Field ==========
                  TextFeildWidget(
                    controller: _companyController,
                    labelText: 'Company *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Company Arabic Field ==========
                  TextFeildWidget(
                    controller: _companyArabicController,
                    textDirection: TextDirection.rtl,
                    labelText: 'Company Arabic *',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Supplier Field ==========
                  TextFeildWidget(
                    controller: _supplierController,
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
                    controller: _supplierArabicController,
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
                    padding: EdgeInsets.symmetric(
                        horizontal: _screenSize.width / 10),
                    child: CustomMaterialBtton(
                        buttonText: 'Submit',
                        onPressed: () => addSuppler(context: context)),
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
    final String company,
        companyArabic,
        supplier,
        supplierArabic,
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
      company = _companyController.text;
      companyArabic = _companyArabicController.text;
      supplier = _supplierController.text;
      supplierArabic = _supplierArabicController.text;
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
        company: company,
        companyArabic: companyArabic,
        supplier: supplier,
        supplierArabic: supplierArabic,
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
        log('Supplier $supplier Added!');
        kSnackBar(
            context: context,
            success: true,
            content: 'Supplier "$supplier" added successfully!');
        if (purchase) {
          Navigator.pop(context, id);
        }
      } catch (e) {
        log('Commpany $company Already Exist!');
        kSnackBar(
            context: context,
            error: true,
            content: 'Company "$company" already exist!');
      }
    }
  }
}
