import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/category_database/category_db.dart';
import 'package:shop_ez/db/db_functions/sub-category_database/sub_category_db.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();

  static final subCategoryEditingController = TextEditingController();
  static String categoryEditingController = 'null';
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;

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
                        setState(() {
                          SubCategoryScreen.categoryEditingController =
                              value.toString();
                        });
                      },
                      validator: (value) {
                        if (value == null ||
                            SubCategoryScreen.categoryEditingController ==
                                'null') {
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
                  controller: SubCategoryScreen.subCategoryEditingController,
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
                    final category =
                        SubCategoryScreen.categoryEditingController;
                    final subCategory = SubCategoryScreen
                        .subCategoryEditingController.text
                        .trim();

                    final isFormValid = _formKey.currentState!;
                    if (isFormValid.validate()) {
                      log('Category == ' + category);
                      log('Sub-Category == ' + subCategory);

                      final _subCategory = SubCategoryModel(
                          category: category, subCategory: subCategory);

                      try {
                        await subCategoryDB.createSubCategory(_subCategory);
                        showSnackBar(
                            context: context,
                            content: 'Category $subCategory Added!');
                        // _categoryEditingController.text = '';
                        return setState(() {});
                      } catch (e) {
                        showSnackBar(
                            context: context,
                            content:
                                'Sub-Category $subCategory Already Exist!');
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
                                      style: const TextStyle(
                                          color: kTextColorBlack),
                                    ),
                                  ),
                                  title: Text(item.category),
                                  subtitle: Text(item.subCategory),
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
      ),
    );
  }

//========== Show SnackBar ==========
  void showSnackBar({required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        // backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    SubCategoryScreen.subCategoryEditingController.text = '';
    super.dispose();
  }
}
