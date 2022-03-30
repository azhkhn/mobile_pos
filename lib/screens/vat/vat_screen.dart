import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/vat_database/vat_database.dart';
import 'package:shop_ez/model/vat/vat_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class VatScreen extends StatefulWidget {
  const VatScreen({Key? key}) : super(key: key);

  @override
  State<VatScreen> createState() => _VatScreenState();
}

class _VatScreenState extends State<VatScreen> {
  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Database Instances ==========
  final vatDB = VatDatabase.instance;

  //========== Text Editing Controllers ==========
  static const types = ['Percentage', 'Fixed'];

  //========== DropDown Controllers ==========
  String _vatType = '';

  //========== Text Editing Controllers ==========
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  void initState() {
    vatDB.getAllVats();
    super.initState();
  }

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
                          style: TextStyle(color: klabelColorBlack),
                        )),
                        items: types
                            .map((values) => DropdownMenuItem<String>(
                                  value: values,
                                  child: Text(values),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _vatType = value.toString();
                          });
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
                  onPressed: () => addVat(),
                  buttonText: 'Submit',
                ),

                //========== VAT List Field ==========
                kHeight50,
                Expanded(
                  child: FutureBuilder<dynamic>(
                    future: vatDB.getAllVats(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                final item = snapshot.data[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: kTransparentColor,
                                    child: Text(
                                      '${index + 1}'.toString(),
                                      style: const TextStyle(
                                          color: kTextColorBlack),
                                    ),
                                  ),
                                  title: Text(item.name),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                thickness: 1,
                              ),
                              itemCount: snapshot.data.length,
                            )
                          : const Center(child: CircularProgressIndicator());
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
  addVat() async {
    final String name, code, rate, type;

    //Retrieving values from TextFields
    name = _nameController.text.trim();
    code = _codeController.text.trim();
    rate = _rateController.text.trim();
    type = _vatType;

    final _formState = _formKey.currentState!;
    if (_formState.validate()) {
      final _vatModel =
          VatModel(name: name, code: code, rate: rate, type: type);

      try {
        await vatDB.createVAT(_vatModel);
        log('VAT Created Successfully');
        showSnackBar(
            context: context,
            color: kSnackBarSuccessColor,
            icon: const Icon(
              Icons.done,
              color: kSnackBarIconColor,
            ),
            content: 'Vat added successfully!');
        return setState(() {});
      } catch (e) {
        if (e == 'VAT Already Exist!') {
          showSnackBar(
              context: context,
              color: kSnackBarErrorColor,
              icon: const Icon(
                Icons.error_outline,
                color: kSnackBarIconColor,
              ),
              content: 'VAT already exist!');
          return;
        }
        log(e.toString());
        log('Something went wrong!');
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
            Flexible(
              child: Text(
                content,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
