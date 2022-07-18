// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';

class SubCategoryDatabase {
  static final SubCategoryDatabase instance = SubCategoryDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SubCategoryDatabase._init();

  //========== Value Notifiers ==========
  static final ValueNotifier<List<SubCategoryModel>> subCategoryNotifier = ValueNotifier([]);

//========== Create Sub-Category ==========
  Future<void> createSubCategory(SubCategoryModel _subCategoryModel) async {
    final db = await dbInstance.database;
    final _subCategory = await db.rawQuery(
        '''SELECT * FROM $tableSubCategory WHERE ${SubCategoryFields.category} = '${_subCategoryModel.category}' AND ${SubCategoryFields.subCategory} = "${_subCategoryModel.subCategory}" COLLATE NOCASE''');
    if (_subCategory.isNotEmpty) {
      log('Sub-Category Already Exist!');
      throw Exception('Sub-Category Already Exist!');
    } else {
      log('Sub-Category Created!');
      final id = await db.insert(tableSubCategory, _subCategoryModel.toJson());
      subCategoryNotifier.value.add(_subCategoryModel.copyWith(id: id));
      subCategoryNotifier.notifyListeners();
      log('Sub-Category id == $id');
    }
  }

//========== Get Sub-Categories by Category ==========
  Future<List<SubCategoryModel>> getSubCategoryByCategoryId({required int categoryId}) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableSubCategory,
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    log('subCategories of $categoryId == $_result');
    final _subCategories = _result.map((json) => SubCategoryModel.fromJson(json)).toList();
    return _subCategories;
  }

//========== Get All Sub-Categories ==========
  Future<List<SubCategoryModel>> getAllSubCategories() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSubCategory);
    log('subCategories == $_result');
    final _subCategories = _result.map((json) => SubCategoryModel.fromJson(json)).toList();
    return _subCategories;
  }

  //========== Update Sub-Category ==========
  Future<void> updateSubCategory({required SubCategoryModel subCategory, required String subCategoryName}) async {
    final db = await dbInstance.database;

    final _result =
        await db.rawQuery('''select * from $tableSubCategory where ${SubCategoryFields.subCategory} = "$subCategoryName" COLLATE NOCASE''');

    if (_result.isNotEmpty && subCategory.subCategory != subCategoryName) throw 'SubCategory Name Already Exist!';

    final updatedsubCategory = subCategory.copyWith(subCategory: subCategoryName);
    await db.update(
      tableSubCategory,
      updatedsubCategory.toJson(),
      where: '${SubCategoryFields.id} = ?',
      whereArgs: [subCategory.id],
    );
    log('Sub-Category ${subCategory.id} update successfully');
    final index = subCategoryNotifier.value.indexOf(subCategory);
    subCategoryNotifier.value[index] = updatedsubCategory;
    subCategoryNotifier.notifyListeners();
  }

  //========== Delete Sub-Category ==========
  Future<void> deleteSubCategory(int id) async {
    final db = await dbInstance.database;
    final _result = await db.delete(tableSubCategory, where: '${SubCategoryFields.id} = ?', whereArgs: [id]);
    subCategoryNotifier.value.removeWhere(
      (subCategories) => subCategories.id == id,
    );
    subCategoryNotifier.notifyListeners();
    log('Sub-Category $id Deleted == $_result');
  }
}
