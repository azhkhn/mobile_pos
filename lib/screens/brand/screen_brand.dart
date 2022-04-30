// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/brand/brand_database.dart';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class BrandScreen extends StatelessWidget {
  BrandScreen({Key? key}) : super(key: key);

  final _brandEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final brandDB = BrandDatabase.instance;
  final brandNotifier = BrandDatabase.brandNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Brand',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Brand Field ==========
              Form(
                key: _formKey,
                child: TextFeildWidget(
                  labelText: 'Brand *',
                  controller: _brandEditingController,
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
                  final brand =
                      _brandEditingController.text.trim().replaceAll("'", "''");
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Brand == ' + brand);
                    final _brand = BrandModel(brand: brand);

                    try {
                      await brandDB.createBrand(_brand);
                      kSnackBar(
                          context: context,
                          success: true,
                          content: 'Brand "$brand" added successfully!');
                      _brandEditingController.clear();
                    } catch (e) {
                      log(e.toString());
                      kSnackBar(
                          context: context,
                          error: true,
                          content: 'Brand "$brand" already exist!');
                    }
                  }
                },
              ),

              //========== Brand List Field ==========
              kHeight50,
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: brandDB.getAllBrands(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());

                      case ConnectionState.done:

                      default:
                        if (snapshot.hasData) {
                          brandNotifier.value = snapshot.data;
                        }

                        return ValueListenableBuilder(
                            valueListenable: brandNotifier,
                            builder: (context, List<BrandModel> brands, _) {
                              return ListView.separated(
                                itemBuilder: (context, index) {
                                  final item = brands[index];
                                  log('item == $item');
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: kTransparentColor,
                                      child: Text(
                                        '${index + 1}'.toString(),
                                        style: const TextStyle(
                                            color: kTextColorBlack),
                                      ),
                                    ),
                                    title: Text(item.brand),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              content: const Text(
                                                  'Are you sure you want to delete this item?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await brandDB
                                                        .deleteBrand(item.id!);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.delete)),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  thickness: 1,
                                ),
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
