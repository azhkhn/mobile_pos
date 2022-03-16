import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/unit_database/unit_database.dart';
import 'package:shop_ez/model/unit/unit_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class UnitScreen extends StatefulWidget {
  const UnitScreen({Key? key}) : super(key: key);

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  final _unitEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final unitDB = UnitDatabase.instance;
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
                      showSnackBar(
                          context: context, content: 'Unit $unit Added!');
                      // _unitEditingController.text = '';
                      return setState(() {});
                    } catch (e) {
                      showSnackBar(
                          context: context,
                          content: 'Unit $unit Already Exist!');
                    }
                  }
                },
              ),

              //========== Unit List Field ==========
              kHeight50,
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: unitDB.getAllUnits(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            itemBuilder: (context, index) {
                              final item = snapshot.data[index];
                              log('item == $item');
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: kTransparentColor,
                                  child: Text(
                                    '${index + 1}'.toString(),
                                    style:
                                        const TextStyle(color: kTextColorBlack),
                                  ),
                                ),
                                title: Text(item.unit),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
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
    );
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
