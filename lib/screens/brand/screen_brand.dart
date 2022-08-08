// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/icons.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/brand/brand_database.dart';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:sizer/sizer.dart';

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
        title: 'Brands',
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
                  textCapitalization: TextCapitalization.words,
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
                  final brand = _brandEditingController.text.trim();
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Brand == ' + brand);
                    final _brand = BrandModel(brand: brand);

                    try {
                      await brandDB.createBrand(_brand);
                      kSnackBar(context: context, success: true, content: 'Brand "$brand" added successfully!');
                      _brandEditingController.clear();
                    } catch (e) {
                      log(e.toString());
                      kSnackBar(context: context, error: true, content: 'Brand "$brand" already exist!');
                    }
                  }
                },
              ),

              SizedBox(height: .5.h),

              //========== Brand List Field ==========
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
                                  final BrandModel brand = brands[index];
                                  log('Brand == $brand');
                                  return ListTile(
                                    dense: isThermal,
                                    leading: CircleAvatar(
                                      backgroundColor: kTransparentColor,
                                      child: Text(
                                        '${index + 1}'.toString(),
                                        style: kTextNo12,
                                      ),
                                    ),
                                    title: Text(brand.brand),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            final _brandController = TextEditingController(text: brand.brand);

                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                  content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFeildWidget(
                                                    labelText: 'Brand Name',
                                                    controller: _brandController,
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
                                                        final String brandName = _brandController.text.trim();
                                                        if (brandName == brands[index].brand) {
                                                          return Navigator.pop(context);
                                                        }
                                                        try {
                                                          await brandDB.updateBrand(brand: brands[index], brandName: brandName);
                                                          Navigator.pop(context);

                                                          kSnackBar(context: context, content: 'Brand updated successfully', update: true);
                                                        } catch (e) {
                                                          if (e == 'Brand Name Already Exist!') {
                                                            kSnackBar(context: context, error: true, content: 'Brand name already exist!');
                                                            return;
                                                          }
                                                          log(e.toString());
                                                          log('Something went wrong!');
                                                        }
                                                      },
                                                      buttonText: 'Update'),
                                                ],
                                              )),
                                            );
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
                                                      child: kTextCancel),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await brandDB.deleteBrand(brand.id!);
                                                        Navigator.pop(context);
                                                        kSnackBar(
                                                          context: context,
                                                          content: 'Brand deleted successfully',
                                                          delete: true,
                                                        );
                                                      },
                                                      child: kTextDelete),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: kIconDelete,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => const Divider(
                                  height: 2,
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
