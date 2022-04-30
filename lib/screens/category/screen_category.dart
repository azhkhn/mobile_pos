import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  //========== TextEditing Controllers ==========
  final _categoryEditingController = TextEditingController();

  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Databse Instances ==========
  final categoryDB = CategoryDatabase.instance;

  //========== Value Notifiers ==========
  final categoryNotifiers = CategoryDatabase.categoryNotifiers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Category',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Category Field ==========
              Form(
                key: _formKey,
                child: TextFeildWidget(
                  labelText: 'Category *',
                  controller: _categoryEditingController,
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
                  final category = _categoryEditingController.text
                      .trim()
                      .replaceAll("'", "''");
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Category == ' + category);
                    final _category = CategoryModel(category: category);

                    try {
                      await categoryDB.createCategory(_category);
                      kSnackBar(
                          context: context,
                          success: true,
                          content: 'Category "$category" added successfully!');
                      _categoryEditingController.clear();
                    } catch (e) {
                      log(e.toString());
                      kSnackBar(
                          context: context,
                          error: true,
                          content: 'Category "$category" already exist!');
                    }
                  }
                },
              ),

              //========== Category List Field ==========
              kHeight50,
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
                            builder:
                                (context, List<CategoryModel> categories, _) {
                              return ListView.separated(
                                itemBuilder: (context, index) {
                                  final item = categories[index];
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
                                    trailing: IconButton(
                                      onPressed: () {
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
                                                  await categoryDB
                                                      .deleteCategory(item.id!);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
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
    );
  }
}
