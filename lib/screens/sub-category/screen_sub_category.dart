import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/db/db_functions/category_database/category_db.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class SubCategoryScreen extends StatefulWidget {
  SubCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final _subCategoryEditingController = TextEditingController();
  late Size _screenSize;
  final _formKey = GlobalKey<FormState>();
  final categoryDB = CategoryDatabase.instance;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const Text('Sub-SCategory'),
      ),
      body: Container(
        width: _screenSize.width,
        height: _screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/home_items.jpg',
            ),
          ),
        ),
        child: ItemScreenPaddingWidget(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //========== Item Category Dropdown ==========
                FutureBuilder(
                    future: categoryDB.getAllCategories(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CategoryModel>> snapshot) {
                      return DropdownButtonFormField(
                        decoration: const InputDecoration(
                          label: Text(
                            'Choose Category *',
                            style: TextStyle(color: Colors.black),
                          ),
                          // prefixIcon: Icon(
                          //   Icons.store,
                          //   color: Colors.black,
                          // ),
                        ),
                        isExpanded: true,
                        items: snapshot.data!.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.category,
                            child: Text(item.category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // setState(() {
                          //   SignUpFields.shopCategoryController = value.toString();
                          // });
                        },
                        validator: (value) {
                          // if (value == null ||
                          //     SignUpFields.shopCategoryController == 'null') {
                          //   return 'This field is required*';
                          // }
                          return null;
                        },
                      );
                    }),
                kHeight10,

                //========== Category Field ==========
                TextFeildWidget(
                  labelText: 'Sub Category *',
                  controller: _subCategoryEditingController,
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
                    final category = _subCategoryEditingController.text;

                    final isFormValid = _formKey.currentState!;
                    if (isFormValid.validate()) {
                      log('Category is == ' + category);

                      try {
                        await categoryDB.createCategory(category);
                        showSnackBar(
                            context: context,
                            content: 'Category $category Added!');
                        // _categoryEditingController.text = '';
                        return setState(() {});
                      } catch (e) {
                        showSnackBar(
                            context: context,
                            content: 'Category $category Already Exist!');
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
                      return snapshot.hasData
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                final item = snapshot.data[index];
                                log('item == $item');
                                return ListTile(
                                  leading: Text('${index + 1}'.toString()),
                                  title: Text(item.category),
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
}
