import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

// const items = ['Cash Customer', 'Credit Customer'];

class CustomerAddScreen extends StatelessWidget {
  CustomerAddScreen({Key? key, this.from = false, this.customerModel}) : super(key: key);

  //========== Bool ==========
  final bool from;

  //========== Model Class ==========
  final CustomerModel? customerModel;

  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Database Instances ==========
  final customerDB = CustomerDatabase.instance;

  //========== TextEditing Controllers ==========
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _companyArabicController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _customerArabicController = TextEditingController();
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

  //========== Focus Nodes ==========
  final FocusNode customerTypeFocusNode = FocusNode();
  final FocusNode customerFocusNode = FocusNode();
  final FocusNode customerArabicFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode addressArabicFocusNode = FocusNode();
  final FocusNode contactNumberFocusNode = FocusNode();
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
      // await customerDB.getAllCustomers();

      if (customerModel != null) {
        getCustomerDetails(customerModel!);
      }
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

                  //========== Contact Number Field ==========
                  TextFeildWidget(
                    controller: _contactNumberController,
                    labelText: 'Contact Number *',
                    textInputType: TextInputType.phone,
                    validator: (value) => Validators.phoneValidator(value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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

                  // //========== State Field ==========
                  // TextFeildWidget(
                  //   controller: _stateController,
                  //   labelText: 'State',
                  //   focusNode: stateFocusNode,
                  //   textInputType: TextInputType.text,
                  // ),
                  // kHeight10,

                  // //========== State Arabic Field ==========
                  // TextFeildWidget(
                  //   controller: _stateArabicController,
                  //   labelText: 'State Arabic',
                  //   textDirection: TextDirection.rtl,
                  //   focusNode: stateArabicFocusNode,
                  //   textInputType: TextInputType.text,
                  // ),
                  // kHeight10,

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
                          if (customerModel == null) return addCustomer(context);
                          addCustomer(context, isUpdate: true);
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

  //========== Add Customer ==========
  Future<void> addCustomer(BuildContext context, {final bool isUpdate = false}) async {
    final String customerType,
        company,
        companyArabic,
        customer,
        customerArabic,
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

    //retieving values from TextFields to String
    customerType = 'General Customer';
    company = _companyController.text;
    companyArabic = _companyArabicController.text;
    customer = _customerController.text;
    customerArabic = _customerArabicController.text;
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

    final _formState = _formKey.currentState!;

    if (_formState.validate()) {
      final _customerModel = CustomerModel(
        id: customerModel?.id,
        customerType: customerType,
        company: company,
        companyArabic: companyArabic,
        customer: customer,
        customerArabic: customerArabic,
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
        final CustomerModel? _customer;
        if (!isUpdate) {
          _customer = await customerDB.createCustomer(_customerModel);
          kSnackBar(context: context, success: true, content: 'Customer added successfully!');
        } else {
          _customer = await customerDB.updateCustomer(_customerModel);
          kSnackBar(context: context, update: true, content: 'Customer updated successfully!');
        }
        _formState.reset();

        if (from) {
          return Navigator.pop(context, _customer);
        } else {
          Navigator.pushReplacementNamed(context, routeManageCustomer);
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
      } else if (contactNumber.isEmpty) {
        contactNumberFocusNode.requestFocus();
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

  //========== Fetch Customer Details ==========
  void getCustomerDetails(CustomerModel customer) {
    //retieving values from Database to TextFields
    // const String customerType = 'General Customer';
    _companyController.text = customer.company;
    _companyArabicController.text = customer.companyArabic;
    _customerController.text = customer.customer;
    _customerArabicController.text = customer.customerArabic;
    _contactNumberController.text = customer.contactNumber;
    _vatNumberController.text = customer.vatNumber ?? '';
    _emailController.text = customer.email;
    _addressController.text = customer.address;
    _addressArabicController.text = customer.addressArabic;
    _cityController.text = customer.city;
    _cityArabicController.text = customer.cityArabic;
    _stateController.text = customer.state;
    _stateArabicController.text = customer.stateArabic;
    _countryController.text = customer.country;
    _countryArabicController.text = customer.countryArabic;
    _poBoxController.text = customer.poBox;
  }
}
