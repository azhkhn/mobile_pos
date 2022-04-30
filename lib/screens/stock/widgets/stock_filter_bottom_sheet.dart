// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/brand/brand_database.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sub_category/sub_category_db.dart';
import 'package:shop_ez/screens/stock/screen_stock.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';

class StockFilterBottomSheet extends StatelessWidget {
  StockFilterBottomSheet({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final itemMasterDB = ItemMasterDatabase.instance;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> _categorykey = GlobalKey();
  final GlobalKey<FormFieldState> _brandKey = GlobalKey();

  //========== DropDown Controllers ==========
  String? _categoryController, _brandController, _stockController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //========== Item Category Dropdown ==========
                Flexible(
                  flex: 1,
                  child: FutureBuilder(
                    future: categoryDB.getAllCategories(),
                    builder: (context, dynamic snapshot) {
                      return CustomDropDownField(
                        labelText: 'Category',
                        dropdownKey: _categorykey,
                        border: true,
                        isDesne: true,
                        errorStyle: true,
                        constraints: const BoxConstraints(maxHeight: 45),
                        contentPadding: const EdgeInsets.all(10),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        snapshot: snapshot,
                        onChanged: (value) {
                          _categoryController = value.toString();
                          _brandController = null;
                          _brandKey.currentState!.reset();
                        },
                      );
                    },
                  ),
                ),
                kWidth10,

                //========== Item Brand Dropdown ==========
                Flexible(
                  flex: 1,
                  child: FutureBuilder(
                    future: brandDB.getAllBrands(),
                    builder: (context, dynamic snapshot) {
                      return CustomDropDownField(
                        labelText: 'Brand',
                        dropdownKey: _brandKey,
                        border: true,
                        isDesne: true,
                        errorStyle: true,
                        constraints: const BoxConstraints(maxHeight: 45),
                        contentPadding: const EdgeInsets.all(10),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        snapshot: snapshot,
                        onChanged: (value) {
                          _brandController = value.toString();
                          _categoryController = null;
                          _categorykey.currentState!.reset();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            kHeight10,
            //========== Stock Dropdown ==========
            Flexible(
              flex: 1,
              child: DropdownButtonFormField(
                isExpanded: true,
                decoration: const InputDecoration(
                  constraints: BoxConstraints(maxHeight: 45),
                  fillColor: kWhite,
                  filled: true,
                  isDense: true,
                  errorStyle: TextStyle(fontSize: 0.01),
                  contentPadding: EdgeInsets.all(10),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label:
                      Text('Stock', style: TextStyle(color: klabelColorBlack)),
                  border: OutlineInputBorder(),
                ),
                items: types
                    .map((values) => DropdownMenuItem<String>(
                          value: values,
                          child: Text(values),
                        ))
                    .toList(),
                onChanged: (value) {
                  _stockController = value.toString();
                  log(_stockController!);
                },
              ),
            ),

            kHeight15,

            //========== Filter Button ==========
            Flexible(
              flex: 1,
              child: Card(
                  elevation: 10,
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: kBackgroundGrey),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TextButton.icon(
                        onPressed: () => ScreenStock().onFilter(
                            context,
                            _categoryController,
                            _brandController,
                            _stockController,
                            _formKey),
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filter'),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
