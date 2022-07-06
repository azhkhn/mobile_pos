import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/icons.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/db/db_functions/unit/unit_database.dart';
import 'package:shop_ez/model/unit/unit_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class UnitScreen extends StatelessWidget {
  UnitScreen({Key? key}) : super(key: key);

  //========== Text Editing Controllers ==========
  final _unitEditingController = TextEditingController();
  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();
  //========== Database Instances ==========
  final unitDB = UnitDatabase.instance;

  //========== Value Notifiers ==========
  final unitNotifiers = UnitDatabase.unitNotifiers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Unit',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Unit Field ==========
              Form(
                key: _formKey,
                child: TextFeildWidget(
                  labelText: 'Unit *',
                  controller: _unitEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),
              ),
              kHeight20,

              //========== Submit Button ==========
              CustomMaterialBtton(
                buttonText: 'Submit',
                onPressed: () async {
                  final unit = _unitEditingController.text.trim();
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Unit == ' + unit);
                    final _unit = UnitModel(unit: unit);

                    try {
                      await unitDB.createUnit(_unit);
                      kSnackBar(context: context, success: true, content: 'Unit "$unit" added successfully!');
                      _unitEditingController.clear();
                    } catch (e) {
                      kSnackBar(context: context, error: true, content: 'Unit "$unit" already exist!');
                    }
                  }
                },
              ),

              //========== Unit List Field ==========
              kHeight20,
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: unitDB.getAllUnits(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                      default:
                        if (snapshot.hasData) {
                          unitNotifiers.value = snapshot.data;
                        }
                        return ValueListenableBuilder(
                            valueListenable: unitNotifiers,
                            builder: (context, List<UnitModel> units, _) {
                              return ListView.builder(
                                itemBuilder: (context, index) {
                                  final item = units[index];
                                  log('item == $item');
                                  return Card(
                                    child: ListTile(
                                      dense: true,
                                      leading:
                                          CircleAvatar(backgroundColor: kTransparentColor, child: Text('${index + 1}'.toString(), style: kTextNo12)),
                                      title: Text(item.unit),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              final _unitController = TextEditingController(text: units[index].unit);

                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                          content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextFeildWidget(
                                                            labelText: 'Unit Name',
                                                            controller: _unitController,
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
                                                          kHeight5,
                                                          CustomMaterialBtton(
                                                              onPressed: () async {
                                                                final String unitName = _unitController.text.trim();
                                                                if (unitName == units[index].unit) {
                                                                  return Navigator.pop(context);
                                                                }
                                                                await unitDB.updateUnit(unit: units[index], unitName: unitName);
                                                                Navigator.pop(context);

                                                                kSnackBar(
                                                                  context: context,
                                                                  content: 'Unit updated successfully',
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
                                                          await unitDB.deleteUnit(item.id!);
                                                          Navigator.pop(context);

                                                          kSnackBar(
                                                            context: context,
                                                            content: 'Unit deleted successfully',
                                                            delete: true,
                                                          );
                                                        },
                                                        child: kTextDelete,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: kIconDelete)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data.length,
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
    );
  }
}
