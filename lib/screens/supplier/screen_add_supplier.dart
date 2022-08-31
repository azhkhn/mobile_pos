import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/validators/validators.dart';
import 'package:mobile_pos/db/db_functions/supplier/supplier_database.dart';
import 'package:mobile_pos/model/supplier/supplier_model.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:mobile_pos/widgets/container/background_container_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class SupplierAddScreen extends StatelessWidget {
  SupplierAddScreen({
    Key? key,
    this.from = false,
    this.supplierModel,
  }) : super(key: key);

  //========== Bool ==========
  final bool from;

  //========== Model Class ==========
  final SupplierModel? supplierModel;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //========== TextEditing Controllers ==========
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _supplierNameArabicController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _vatNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressArabicController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _cityArabicController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _stateArabicController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _countryArabicController = TextEditingController();
  final TextEditingController _poBoxController = TextEditingController();

  final SupplierDatabase supplierDB = SupplierDatabase.instance;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (supplierModel != null) {
        getSupplierDetails(supplierModel!);
      }
    });

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

                  // //========== State Field ==========
                  // TextFeildWidget(
                  //   controller: _stateController,
                  //   labelText: 'State',
                  //   textInputType: TextInputType.text,
                  // ),
                  // kHeight10,

                  // //========== State Arabic Field ==========
                  // TextFeildWidget(
                  //   controller: _stateArabicController,
                  //   textDirection: TextDirection.rtl,
                  //   labelText: 'State Arabic',
                  //   textInputType: TextInputType.text,
                  // ),
                  // kHeight10,

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
                  FractionallySizedBox(
                      widthFactor: .8,
                      child: CustomMaterialBtton(
                        buttonText: 'Submit',
                        onPressed: () async {
                          if (supplierModel == null) return await addSuppler(context);
                          await addSuppler(context, isUpdate: true);
                        },
                      )),
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
  Future<void> addSuppler(BuildContext context, {final bool isUpdate = false}) async {
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
      state = _stateController.text;
      stateArabic = _stateArabicController.text;
      country = _countryController.text;
      countryArabic = _countryArabicController.text;
      poBox = _poBoxController.text;

      final SupplierModel _supplierModel = SupplierModel(
        id: supplierModel?.id,
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
        final SupplierModel? _supplier;
        if (!isUpdate) {
          _supplier = await supplierDB.createSupplier(_supplierModel);
          kSnackBar(context: context, success: true, content: 'Supplier added successfully!');
        } else {
          _supplier = await supplierDB.updateSupplier(_supplierModel);
          kSnackBar(context: context, update: true, content: 'Supplier updated successfully!');
        }
        resetSupplier();
        if (from) {
          Navigator.pop(context, _supplier);
        } else {
          Navigator.pushReplacementNamed(context, routeManageSupplier);
        }
      } catch (e) {
        log('Supplier $supplierName Already Exist!');
        kSnackBar(context: context, error: true, content: 'Supplier "$supplierName" already exist!');
      }
    }
  }

  //========== Fetch Supplier Details ==========
  void getSupplierDetails(SupplierModel supplier) {
    //retieving values from Database to TextFields
    _supplierNameController.text = supplier.supplierName;
    _supplierNameArabicController.text = supplier.supplierNameArabic;
    _contactNameController.text = supplier.contactName;
    _contactNumberController.text = supplier.contactNumber;
    _vatNumberController.text = supplier.vatNumber ?? '';
    _emailController.text = supplier.email ?? '';
    _addressController.text = supplier.address ?? '';
    _addressArabicController.text = supplier.addressArabic ?? '';
    _cityController.text = supplier.city ?? '';
    _cityArabicController.text = supplier.cityArabic ?? '';
    _stateController.text = supplier.state ?? '';
    _stateArabicController.text = supplier.stateArabic ?? '';
    _countryController.text = supplier.country ?? '';
    _countryArabicController.text = supplier.countryArabic ?? '';
    _poBoxController.text = supplier.poBox ?? '';
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
