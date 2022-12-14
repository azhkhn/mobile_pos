// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/icons.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/db/db_functions/category/category_db.dart';
import 'package:mobile_pos/db/db_functions/sub_category/sub_category_db.dart';
import 'package:mobile_pos/model/category/category_model.dart';
import 'package:mobile_pos/model/sub-category/sub_category_model.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:mobile_pos/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:sizer/sizer.dart';

import '../../core/utils/snackbar/snackbar.dart';

class SubCategoryScreen extends StatelessWidget {
  SubCategoryScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  //========== Databse Instances ==========
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;

  //========== Value Notifiers ==========
  final subCategoryNotifiers = SubCategoryDatabase.subCategoryNotifier;

  final _subCategoryController = TextEditingController();
  String? _categoryController;
  int? _categoryIdController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        title: 'Sub-Category',
      ),
      body: ItemScreenPaddingWidget(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //========== Item Category Dropdown ==========
              FutureBuilder(
                future: categoryDB.getAllCategories(),
                builder: (context, dynamic snapshot) {
                  final snap = snapshot as AsyncSnapshot;
                  switch (snap.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.done:
                    default:
                      return CustomDropDownField(
                        labelText: 'Choose Category *',
                        snapshot: snapshot.data,
                        onChanged: (value) {
                          final CategoryModel category = CategoryModel.fromJson(jsonDecode(value!));
                          log(category.category);
                          log(category.id.toString());

                          _categoryController = category.category;
                          _categoryIdController = category.id;
                        },
                        validator: (value) {
                          if (value == null || _categoryController == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      );
                  }
                },
              ),
              kHeight10,

              //========== Category Field ==========
              TextFeildWidget(
                labelText: 'Sub Category *',
                controller: _subCategoryController,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required*';
                  }
                  return null;
                },
              ),

              kHeight20,

              //========== Submit Button ==========
              CustomMaterialBtton(
                buttonText: 'Submit',
                onPressed: () async {
                  final category = _categoryController;
                  final categoryId = _categoryIdController;
                  final subCategory = _subCategoryController.text.trim();

                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Category == ' + category!);
                    log('CategoryId == $categoryId');
                    log('Sub-Category == ' + subCategory);

                    final _subCategory = SubCategoryModel(category: category, categoryId: categoryId!, subCategory: subCategory);

                    try {
                      await subCategoryDB.createSubCategory(_subCategory);
                      kSnackBar(context: context, success: true, content: 'Sub-Category "$subCategory" added successfully!');
                      _subCategoryController.clear();
                    } catch (e) {
                      kSnackBar(context: context, color: kSnackBarDeleteColor, error: true, content: 'Sub-Category "$subCategory" already exist!');
                    }
                  }
                },
              ),

              SizedBox(height: .5.h),

              //========== Category List Field ==========
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: subCategoryDB.getAllSubCategories(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                      default:
                        if (snapshot.hasData) {
                          subCategoryNotifiers.value = snapshot.data;
                        }
                        return ValueListenableBuilder(
                            valueListenable: subCategoryNotifiers,
                            builder: (context, List<SubCategoryModel> subCategories, _) {
                              return ListView.separated(
                                itemBuilder: (context, index) {
                                  final item = subCategories[index];
                                  log('item == $item');
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: kTransparentColor,
                                      child: Text(
                                        '${index + 1}'.toString(),
                                        style: const TextStyle(color: kTextColorBlack),
                                      ),
                                    ),
                                    title: Text(item.subCategory),
                                    subtitle: Text(item.category),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            final _subCategoryController = TextEditingController(text: subCategories[index].subCategory);

                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                        content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextFeildWidget(
                                                          labelText: 'Sub-Category Name',
                                                          controller: _subCategoryController,
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
                                                              final String subCategoryName = _subCategoryController.text.trim();
                                                              if (subCategoryName == subCategories[index].subCategory) {
                                                                return Navigator.pop(context);
                                                              }

                                                              try {
                                                                await subCategoryDB.updateSubCategory(
                                                                    subCategory: subCategories[index], subCategoryName: subCategoryName);
                                                                Navigator.pop(context);

                                                                kSnackBar(
                                                                    context: context, content: 'Sub-Category updated successfully', update: true);
                                                              } catch (e) {
                                                                if (e == 'SubCategory Name Already Exist!') {
                                                                  return kSnackBar(
                                                                      context: context, error: true, content: 'Sub-Category Name Already Exist!');
                                                                }
                                                                log(e.toString());
                                                                log('Something went wrong!');
                                                              }
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
                                                        await subCategoryDB.deleteSubCategory(item.id!);
                                                        Navigator.pop(context);

                                                        kSnackBar(
                                                          context: context,
                                                          content: 'Sub-Category deleted successfully',
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
                                separatorBuilder: (context, index) => const Divider(),
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
