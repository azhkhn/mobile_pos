import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/supplier_database/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenManageSupplier extends StatelessWidget {
  ScreenManageSupplier({Key? key}) : super(key: key);
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
                    labelText: 'Company in Arabic *',
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
                  ),
                  kHeight10,

                  //========== Email Field ==========
                  TextFeildWidget(
                    controller: _emailController,
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
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
                    labelText: 'Address in Arabic',
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
                    labelText: 'City in Arabic',
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
                    labelText: 'State in Arabic',
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
                    labelText: 'Country in Arabic',
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
        await supplierDB.createSupplier(_supplierModel);
        log('Supplier $supplier Added!');
        showSnackBar(
            context: context,
            color: kSnackBarSuccessColor,
            icon: const Icon(
              Icons.done,
              color: kSnackBarIconColor,
            ),
            content: 'Supplier "$supplier" added successfully!');
      } catch (e) {
        log('Commpany $company Already Exist!');
        showSnackBar(
            context: context,
            color: kSnackBarErrorColor,
            icon: const Icon(
              Icons.new_releases_outlined,
              color: kSnackBarIconColor,
            ),
            content: 'Company "$company" already exist!');
      }
    }
  }

  //========== Show SnackBar ==========
  void showSnackBar(
      {required BuildContext context,
      required String content,
      Color? color,
      Widget? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon ?? const Text(''),
            kWidth5,
            Text(content),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
