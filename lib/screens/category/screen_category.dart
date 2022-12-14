import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/icons.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/db/db_functions/category/category_db.dart';
import 'package:mobile_pos/model/category/category_model.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:sizer/sizer.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  //========== TextEditing Controllers ==========
  final _categoryEditingController = TextEditingController();

  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Databse Instances ==========
  final categoryDB = CategoryDatabase.instance;

  //========== Value Notifiers ==========
  final categoryNotifiers = CategoryDatabase.categoryNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        title: 'Category',
      ),
      body: ItemScreenPaddingWidget(
        child: Column(
          children: [
            //========== Category Field ==========
            Form(
              key: _formKey,
              child: TextFeildWidget(
                labelText: 'Category *',
                controller: _categoryEditingController,
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
                final category = _categoryEditingController.text.trim();
                final isFormValid = _formKey.currentState!;
                if (isFormValid.validate()) {
                  log('Category == ' + category);
                  final _category = CategoryModel(category: category);

                  try {
                    await categoryDB.createCategory(_category);
                    kSnackBar(context: context, success: true, content: 'Category "$category" added successfully!');
                    _categoryEditingController.clear();
                  } catch (e) {
                    log(e.toString());
                    kSnackBar(context: context, error: true, content: 'Category "$category" already exist!');
                  }
                }
              },
            ),

            SizedBox(height: .5.h),

            //========== Category List Field ==========
            Expanded(
              child: FutureBuilder<dynamic>(
                future: categoryDB.getAllCategories(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                    default:
                      if (snapshot.hasData) {
                        categoryNotifiers.value = snapshot.data;
                      }
                      return ValueListenableBuilder(
                          valueListenable: categoryNotifiers,
                          builder: (context, List<CategoryModel> categories, _) {
                            return ListView.separated(
                              itemBuilder: (context, index) {
                                final CategoryModel category = categories[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: kTransparentColor,
                                    child: Text(
                                      '${index + 1}'.toString(),
                                      style: const TextStyle(color: kTextColorBlack),
                                    ),
                                  ),
                                  title: Text(category.category),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final _categoryController = TextEditingController(text: category.category);

                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      content: Column(mainAxisSize: MainAxisSize.min, children: [
                                                    TextFeildWidget(
                                                      labelText: 'Category Name',
                                                      controller: _categoryController,
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
                                                          final String categoryName = _categoryController.text.trim();
                                                          if (categoryName == category.category) {
                                                            return Navigator.pop(context);
                                                          }
                                                          try {
                                                            await categoryDB.updateCategory(category: category, categoryName: categoryName);
                                                            Navigator.pop(context);

                                                            kSnackBar(context: context, content: 'Category updated successfully', update: true);
                                                          } catch (e) {
                                                            if (e == 'Category Name Already Exist!') {
                                                              kSnackBar(context: context, error: true, content: 'Category name already exist!');
                                                              return;
                                                            }
                                                            log(e.toString());
                                                            log('Something went wrong!');
                                                          }
                                                        },
                                                        buttonText: 'Update')
                                                  ])));
                                        },
                                        icon: kIconEdit,
                                      ),
                                      IconButton(
                                        onPressed: () {
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
                                                    await categoryDB.deleteCategory(category.id!);
                                                    Navigator.pop(context);

                                                    kSnackBar(
                                                      context: context,
                                                      content: 'Category deleted successfully',
                                                      delete: true,
                                                    );
                                                  },
                                                  child: kTextDelete,
                                                ),
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
    );
  }
}
