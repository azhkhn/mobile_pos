// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/category/category_model.dart';

class CategoryDatabase {
  static final CategoryDatabase instance = CategoryDatabase._init();
  final dbInstance = EzDatabase.instance;
  CategoryDatabase._init();

  //========== Value Notifiers ==========
  static final ValueNotifier<List<CategoryModel>> categoryNotifier = ValueNotifier([]);

//========== Create Category ==========
  Future<void> createCategory(CategoryModel _categoryModel) async {
    final db = await dbInstance.database;
    final category =
        await db.rawQuery('''select * from $tableCategory where ${CategoryFields.category} = "${_categoryModel.category}" COLLATE NOCASE''');
    if (category.isNotEmpty) {
      log('Category already exist!');
      throw Exception('Category Already Exist!');
    } else {
      log('Category Created!');
      final id = await db.insert(tableCategory, _categoryModel.toJson());
      categoryNotifier.value.add(_categoryModel.copyWith(id: id));
      categoryNotifier.notifyListeners();

      log('Category Id == $id');
    }
  }

  //========== Update Category ==========
  Future<void> updateCategory({required CategoryModel category, required String categoryName}) async {
    final db = await dbInstance.database;

    final _result = await db.rawQuery('''select * from $tableCategory where ${CategoryFields.category} = "$categoryName" COLLATE NOCASE''');

    if (_result.isNotEmpty && category.category != categoryName) throw 'Category Name Already Exist!';
    final updatedCategory = category.copyWith(category: categoryName);
    await db.update(
      tableCategory,
      updatedCategory.toJson(),
      where: '${CategoryFields.id} = ?',
      whereArgs: [category.id],
    );
    log('Category ${category.id} Updated Successfully');
    final index = categoryNotifier.value.indexOf(category);
    categoryNotifier.value[index] = updatedCategory;
    categoryNotifier.notifyListeners();
  }

  //========== Delete Category ==========
  Future<void> deleteCategory(int id) async {
    final db = await dbInstance.database;
    await db.delete(tableCategory, where: '${CategoryFields.id} = ? ', whereArgs: [id]);
    log('Category $id Deleted Successfully!');
    categoryNotifier.value.removeWhere((categories) => categories.id == id);
    categoryNotifier.notifyListeners();
  }

//========== Get All Categories ==========
  Future<List<CategoryModel>> getAllCategories() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableCategory);
    log('Categories === $_result');
    final _categories = _result.map((json) => CategoryModel.fromJson(json)).toList();
    // db.delete(tableCategory);
    return _categories;
  }
}
