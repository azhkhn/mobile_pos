// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/icons.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/vat/vat_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class VatScreen extends StatelessWidget {
  VatScreen({Key? key}) : super(key: key);

  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Database Instances ==========
  final vatDB = VatDatabase.instance;

  //========== Value Notifiers ==========
  final vatNotifier = VatDatabase.vatNotifer;

  //========== DropDown Items ==========
  static const types = ['Percentage', 'Fixed'];

  //========== DropDown Controllers ==========
  String _vatType = '';

  //========== Text Editing Controllers ==========
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'TAX Rate'),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //========== Name Field ==========
                TextFeildWidget(
                  labelText: 'Name *',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),
                kHeight10,

                //========== Code Field ==========
                TextFeildWidget(
                  labelText: 'Code *',
                  controller: _codeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),
                kHeight10,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //========== Rate Field ==========
                    Flexible(
                      flex: 6,
                      child: TextFeildWidget(
                        labelText: 'Rate *',
                        controller: _rateController,
                        textInputType: TextInputType.number,
                        inputFormatters: Validators.digitsOnly,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      ),
                    ),

                    kWidth20,

                    //========== Type DropDown ==========
                    Flexible(
                      flex: 4,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            label: Text(
                          'VAT Type *',
                          style: TextStyle(color: klabelColorGrey),
                        )),
                        items: types
                            .map((values) => DropdownMenuItem<String>(
                                  value: values,
                                  child: Text(values),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _vatType = value.toString();
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                kHeight20,

                //========== Submit Button ==========
                CustomMaterialBtton(
                  onPressed: () => addVat(context),
                  buttonText: 'Submit',
                ),

                //========== VAT List Field ==========
                kHeight50,
                Expanded(
                  child: FutureBuilder<List<VatModel>>(
                    future: vatDB.getAllVats(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.done:
                        default:
                          if (snapshot.hasData) {
                            vatNotifier.value = snapshot.data!;
                          }
                          return ValueListenableBuilder(
                              valueListenable: vatNotifier,
                              builder: (context, List<VatModel> vats, _) {
                                return ListView.separated(
                                  itemBuilder: (context, index) {
                                    final vat = vats[index];
                                    log('vat == $vat');
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: kTransparentColor,
                                        child: Text(
                                          '${index + 1}'.toString(),
                                          style: const TextStyle(color: kTextColorBlack),
                                        ),
                                      ),
                                      title: Text(vat.name),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              final _vatNameController = TextEditingController(text: vats[index].name);
                                              final _vatRateController = TextEditingController(text: vats[index].rate.toString());
                                              String _vatTypeController = vats[index].type;

                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                          content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextFeildWidget(
                                                            labelText: 'VAT Name',
                                                            controller: _vatNameController,
                                                            textInputType: TextInputType.text,
                                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                                            inputBorder: const OutlineInputBorder(),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            isDense: true,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'This field is required*';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          kHeight10,
                                                          TextFeildWidget(
                                                            labelText: 'VAT Rate',
                                                            controller: _vatRateController,
                                                            textInputType: TextInputType.number,
                                                            inputFormatters: Validators.digitsOnly,
                                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                                            inputBorder: const OutlineInputBorder(),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            isDense: true,
                                                            validator: (value) {
                                                              if (value == null || value.isEmpty) {
                                                                return 'This field is required*';
                                                              }
                                                              return null;
                                                            },
                                                          ),

                                                          kHeight10,

                                                          //========== Type DropDown ==========
                                                          DropdownButtonFormField(
                                                            decoration: const InputDecoration(
                                                                label: Text('VAT Type', style: TextStyle(color: klabelColorGrey)),
                                                                border: OutlineInputBorder(),
                                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                                contentPadding: EdgeInsets.all(15)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            isDense: true,
                                                            items: types
                                                                .map((values) => DropdownMenuItem<String>(
                                                                      value: values,
                                                                      child: Text(values),
                                                                    ))
                                                                .toList(),
                                                            onChanged: (value) {
                                                              _vatTypeController = value.toString();
                                                            },
                                                            value: _vatTypeController,
                                                            validator: (value) {
                                                              if (value == null) {
                                                                return 'This field is required*';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          kHeight5,
                                                          CustomMaterialBtton(
                                                              onPressed: () async {
                                                                final String vatName = _vatNameController.text.trim();
                                                                final int vatRate = int.parse(_vatRateController.text.trim());
                                                                final String vatType = _vatTypeController.trim();

                                                                if (vatName == vats[index].name &&
                                                                    vatRate == vats[index].rate &&
                                                                    vatType == vats[index].type) {
                                                                  return Navigator.pop(context);
                                                                }
                                                                await vatDB.updateVAT(
                                                                    vat: vats[index], vatName: vatName, vatRate: vatRate, vatType: vatType);
                                                                Navigator.pop(context);

                                                                kSnackBar(
                                                                  context: context,
                                                                  content: 'VAT updated successfully',
                                                                  update: true,
                                                                );
                                                              },
                                                              buttonText: 'Update'),
                                                        ],
                                                      )));
                                            },
                                            icon: kIconEdit,
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    content: const Text('Are you sure you want to delete this item?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: kTextCancel,
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await vatDB.deleteVAT(vat.id!);
                                                          Navigator.pop(context);

                                                          kSnackBar(
                                                            context: context,
                                                            content: 'VAT deleted successfully',
                                                            delete: true,
                                                          );
                                                        },
                                                        child: kTextDelete,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: kIconDelete),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const Divider(
                                    thickness: 1,
                                  ),
                                  itemCount: vats.length,
                                );
                              });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //========== Add VAT ==========
  addVat(BuildContext context) async {
    final String name, code, type;
    final int rate;

    final _formState = _formKey.currentState!;
    if (_formState.validate()) {
      //Retrieving values from TextFields
      name = _nameController.text.trim();
      code = _codeController.text.trim();
      rate = int.parse(_rateController.text.trim());
      type = _vatType;

      final _vatModel = VatModel(name: name, code: code, rate: rate, type: type);

      try {
        await vatDB.createVAT(_vatModel);
        log('VAT Created Successfully');

        _formState.reset();

        kSnackBar(context: context, success: true, content: 'Vat added successfully!');
      } catch (e) {
        if (e == 'VAT Already Exist!') {
          kSnackBar(context: context, error: true, content: 'VAT already exist!');
          return;
        }
        log(e.toString());
        log('Something went wrong!');
      }
    }
  }
}
