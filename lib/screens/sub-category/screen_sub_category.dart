// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/db/db_functions/sub_category/sub_category_db.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class SubCategoryScreen extends StatelessWidget {
  SubCategoryScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  //========== Databse Instances ==========
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;

  //========== Value Notifiers ==========
  final subCategoryNotifiers = SubCategoryDatabase.subCategoryNotifiers;

  final _subCategoryController = TextEditingController();
  String _categoryController = 'null';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Sub-Category',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //========== Item Category Dropdown ==========
                FutureBuilder(
                  future: categoryDB.getAllCategories(),
                  builder: (context, dynamic snapshot) {
                    return CustomDropDownField(
                      labelText: 'Choose Category *',
                      snapshot: snapshot,
                      onChanged: (value) {
                        _categoryController = value.toString();
                      },
                      validator: (value) {
                        if (value == null || _categoryController == 'null') {
                          return 'This field is required*';
                        }
                        return null;
                      },
                    );
                  },
                ),
                kHeight10,

                //========== Category Field ==========
                TextFeildWidget(
                  labelText: 'Sub Category *',
                  controller: _subCategoryController,
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
                    final subCategory = _subCategoryController.text.trim();

                    final isFormValid = _formKey.currentState!;
                    if (isFormValid.validate()) {
                      log('Category == ' + category);
                      log('Sub-Category == ' + subCategory);

                      final _subCategory = SubCategoryModel(
                          category: category, subCategory: subCategory);

                      try {
                        await subCategoryDB.createSubCategory(_subCategory);
                        kSnackBar(
                            context: context,
                            color: kSnackBarSuccessColor,
                            icon: const Icon(
                              Icons.done,
                              color: kSnackBarIconColor,
                            ),
                            content:
                                'Category "$subCategory" added successfully!');
                        _subCategoryController.clear();
                      } catch (e) {
                        kSnackBar(
                            context: context,
                            color: kSnackBarErrorColor,
                            icon: const Icon(
                              Icons.new_releases_outlined,
                              color: kSnackBarIconColor,
                            ),
                            content:
                                'Sub-Category "$subCategory" already exist!');
                      }
                    }
                  },
                ),

                //========== Category List Field ==========
                kHeight50,
                Expanded(
                  child: FutureBuilder<dynamic>(
                    future: subCategoryDB.getAllSubCategories(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:
                        default:
                          if (snapshot.hasData) {
                            subCategoryNotifiers.value = snapshot.data;
                          }
                          return ValueListenableBuilder(
                              valueListenable: subCategoryNotifiers,
                              builder: (context,
                                  List<SubCategoryModel> subCategories, _) {
                                return ListView.separated(
                                  itemBuilder: (context, index) {
                                    final item = subCategories[index];
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
                                      title: Text(item.subCategory),
                                      subtitle: Text(item.category),
                                      trailing: IconButton(
                                          onPressed: () async {
                                            await subCategoryDB
                                                .deleteSubCategory(item.id!);
                                          },
                                          icon: const Icon(Icons.delete)),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
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
      ),
    );
  }
}
