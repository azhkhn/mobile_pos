// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/category/category_model.dart';

class CategoryDatabase {
  static final CategoryDatabase instance = CategoryDatabase._init();
  final dbInstance = EzDatabase.instance;
  CategoryDatabase._init();

  //========== Value Notifiers ==========
  static final ValueNotifier<List<CategoryModel>> categoryNotifiers =
      ValueNotifier([]);

//========== Create Category ==========
  Future<void> createCategory(CategoryModel _categoryModel) async {
    final db = await dbInstance.database;
    final category = await db.rawQuery(
        "select * from $tableCategory where ${CategoryFields.category} = '${_categoryModel.category}'");
    if (category.isNotEmpty) {
      log('Category already exist!');
      throw Exception('Category Already Exist!');
    } else {
      log('Category Created!');
      final id = await db.insert(tableCategory, _categoryModel.toJson());
      categoryNotifiers.value.add(_categoryModel.copyWith(id: id));
      categoryNotifiers.notifyListeners();

      log('Category Id == $id');
    }
  }

  //========== Delete Category ==========
  Future<void> deleteCategory(int id) async {
    final db = await dbInstance.database;
    await db.delete(tableCategory,
        where: '${CategoryFields.id} = ? ', whereArgs: [id]);
    log('Category $id Deleted Successfully!');
    categoryNotifiers.value.removeWhere((categories) => categories.id == id);
    categoryNotifiers.notifyListeners();
  }

//========== Get All Categories ==========
  Future<List<CategoryModel>> getAllCategories() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableCategory);
    log('Categories === $_result');
    final _categories =
        _result.map((json) => CategoryModel.fromJson(json)).toList();
    // db.delete(tableCategory);
    return _categories;
  }
}
