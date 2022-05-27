import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

// static const items = ['Cash Customer', 'Credit Customer'];

class AddCustomerScreen extends StatelessWidget {
  AddCustomerScreen({Key? key, this.fromPos = false}) : super(key: key);

  //========== Bool ==========
  final bool fromPos;

  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Database Instances ==========
  final customerDB = CustomerDatabase.instance;

  //========== TextEditing Controllers ==========
  final _companyController = TextEditingController();
  final _companyArabicController = TextEditingController();
  final _customerController = TextEditingController();
  final _customerArabicController = TextEditingController();
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

  //========== Focus Nodes ==========
  final FocusNode customerTypeFocusNode = FocusNode();
  final FocusNode customerFocusNode = FocusNode();
  final FocusNode customerArabicFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode addressArabicFocusNode = FocusNode();
  final FocusNode companyFocusNode = FocusNode();
  final FocusNode companyArabicFocusNode = FocusNode();
  final FocusNode vatNumberFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode cityArabicFocusNode = FocusNode();
  final FocusNode stateFocusNode = FocusNode();
  final FocusNode stateArabicFocusNode = FocusNode();
  final FocusNode countryFocusNode = FocusNode();
  final FocusNode countryArabicFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await customerDB.getAllCustomers();
    });
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Customer',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // //========== Company Field ==========
                  // DropdownButtonFormField(
                  //   decoration: const InputDecoration(
                  //       label: Text(
                  //         'Customer Type *',
                  //         style: TextStyle(color: klabelColorGrey),
                  //       ),
                  //       contentPadding: EdgeInsets.all(10)),
                  //   isExpanded: true,
                  //   focusNode: customerTypeFocusNode,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   items: CustomerScreen.items
                  //       .map(
                  //         (values) => DropdownMenuItem(
                  //             value: values, child: Text(values)),
                  //       )
                  //       .toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _customerTypeDropdown = value.toString();
                  //     });
                  //   },
                  //   validator: (value) {
                  //     if (value == null || 'General Customer' == 'null') {
                  //       return 'This field is required*';
                  //     }
                  //     return null;
                  //   },
                  // ),

                  //========== Customer Field ==========
                  TextFeildWidget(
                    controller: _customerController,
                    labelText: 'Customer Name *',
                    focusNode: customerFocusNode,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Customer Arabic Field ==========
                  TextFeildWidget(
                    controller: _customerArabicController,
                    labelText: 'Customer Name Arabic *',
                    textDirection: TextDirection.rtl,
                    focusNode: customerArabicFocusNode,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Address Field ==========
                  TextFeildWidget(
                    controller: _addressController,
                    labelText: 'Address *',
                    focusNode: addressFocusNode,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Address Arabic Field ==========
                  TextFeildWidget(
                    controller: _addressArabicController,
                    labelText: 'Address Arabic *',
                    textDirection: TextDirection.rtl,
                    focusNode: addressArabicFocusNode,
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Company Field ==========
                  TextFeildWidget(
                    controller: _companyController,
                    labelText: 'Company',
                    focusNode: companyFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Company Arabic Field ==========
                  TextFeildWidget(
                    controller: _companyArabicController,
                    labelText: 'Company Arabic',
                    textDirection: TextDirection.rtl,
                    focusNode: companyArabicFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== VAT Number Field ==========
                  TextFeildWidget(
                    controller: _vatNumberController,
                    labelText: 'VAT Number',
                    focusNode: vatNumberFocusNode,
                    inputFormatters: Validators.digitsOnly,
                    textInputType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => Validators.vatValidator(value),
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

                  //========== City Field ==========
                  TextFeildWidget(
                    controller: _cityController,
                    labelText: 'City',
                    focusNode: cityFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== City Arabic Field ==========
                  TextFeildWidget(
                    controller: _cityArabicController,
                    labelText: 'City Arabic',
                    textDirection: TextDirection.rtl,
                    focusNode: cityArabicFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== State Field ==========
                  TextFeildWidget(
                    controller: _stateController,
                    labelText: 'State',
                    focusNode: stateFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== State Arabic Field ==========
                  TextFeildWidget(
                    controller: _stateArabicController,
                    labelText: 'State Arabic',
                    textDirection: TextDirection.rtl,
                    focusNode: stateArabicFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Country Field ==========
                  TextFeildWidget(
                    controller: _countryController,
                    labelText: 'Country',
                    focusNode: countryFocusNode,
                    textInputType: TextInputType.text,
                  ),
                  kHeight10,

                  //========== Country Arabic Field ==========
                  TextFeildWidget(
                    controller: _countryArabicController,
                    labelText: 'Country Arabic',
                    textDirection: TextDirection.rtl,
                    focusNode: countryArabicFocusNode,
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
                        onPressed: () {
                          addCustomer(context: context);
                        }),
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
  Future<void> addCustomer({context}) async {
    final String customerType,
        company,
        companyArabic,
        customer,
        customerArabic,
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

    //retieving values from TextFields to String
    customerType = 'General Customer';
    company = _companyController.text;
    companyArabic = _companyArabicController.text;
    customer = _customerController.text;
    customerArabic = _customerArabicController.text;
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
    log(state);
    log(stateArabic);
    final _formState = _formKey.currentState!;

    if (_formState.validate()) {
      final _customerModel = CustomerModel(
        customerType: customerType,
        company: company,
        companyArabic: companyArabic,
        customer: customer,
        customerArabic: customerArabic,
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
        final id = await customerDB.createCustomer(_customerModel);
        _formState.reset();
        log('Customer $customer Added!');
        kSnackBar(context: context, success: true, content: 'Customer "$customer" added successfully!');

        if (fromPos) {
          return Navigator.pop(context, id);
        }
      } catch (e) {
        if (e == 'Company Already Exist!') {
          log('Commpany name Already Exist!');
          companyFocusNode.requestFocus();
          kSnackBar(
            context: context,
            error: true,
            content: 'Company name already exist!',
          );
        } else if (e == 'VAT Number already exist!') {
          vatNumberFocusNode.requestFocus();
          kSnackBar(
            context: context,
            error: true,
            content: 'VAT number already exist!',
          );
        }
      }
    } else {
      if (customerType == 'null') {
        customerTypeFocusNode.requestFocus();
      } else if (customer.isEmpty) {
        customerFocusNode.requestFocus();
      } else if (customerArabic.isEmpty) {
        customerArabicFocusNode.requestFocus();
      } else if (address.isEmpty) {
        addressFocusNode.requestFocus();
      } else if (addressArabic.isEmpty) {
        addressArabicFocusNode.requestFocus();
      } else {
        if (customerType == 'Credit Customer') {
          if (vatNumber.isEmpty) {
            vatNumberFocusNode.requestFocus();
          } else if (address.isEmpty) {
            addressFocusNode.requestFocus();
          } else if (addressArabic.isEmpty) {
            addressArabicFocusNode.requestFocus();
          } else if (city.isEmpty) {
            cityFocusNode.requestFocus();
          } else if (cityArabic.isEmpty) {
            cityArabicFocusNode.requestFocus();
          } else if (state.isEmpty) {
            stateFocusNode.requestFocus();
          } else if (stateArabic.isEmpty) {
            stateArabicFocusNode.requestFocus();
          } else if (country.isEmpty) {
            countryFocusNode.requestFocus();
          } else if (countryArabic.isEmpty) {
            countryArabicFocusNode.requestFocus();
          }
        }
      }
    }
  }
}
