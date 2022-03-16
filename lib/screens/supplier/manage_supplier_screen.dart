import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/supplier_database/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenManageSupplier extends StatelessWidget {
  const ScreenManageSupplier({Key? key}) : super(key: key);
  static const items = ['Standard', 'Service'];
  static late Size _screenSize;
  static final _formKey = GlobalKey<FormState>();
  static final _companyController = TextEditingController();
  static final _companyArabicController = TextEditingController();
  static final _supplierController = TextEditingController();
  static final _supplierArabicController = TextEditingController();
  static final _vatNumberController = TextEditingController();
  static final _emailController = TextEditingController();
  static final _addressController = TextEditingController();
  static final _addressArabicController = TextEditingController();
  static final _cityController = TextEditingController();
  static final _cityArabicController = TextEditingController();
  static final _stateController = TextEditingController();
  static final _stateArabicController = TextEditingController();
  static final _countryController = TextEditingController();
  static final _countryArabicController = TextEditingController();
  static final _poBoxController = TextEditingController();

  static final supplierDB = SupplierDatabase.instance;

  @override
  Widget build(BuildContext context) {
    supplierDB.getAllSuppliers();
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

    final _formState = _formKey.currentState!;
    if (_formState.validate()) {
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
        showSnackBar(context: context, content: 'Supplier $supplier Added!');
      } catch (e) {
        log('Commpany $company Already Exist!');
        showSnackBar(
            context: context, content: 'Commpany $company Already Exist!');
      }
    }
  }

  //========== Show SnackBar ==========
  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        // backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
