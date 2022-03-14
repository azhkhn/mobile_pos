import 'dart:developer' show log;
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/category/category_model.dart';

class CategoryDatabase {
  static final CategoryDatabase instance = CategoryDatabase._init();
  final dbInstance = EzDatabase.instance;
  CategoryDatabase._init();

//========== Create Category ==========
  Future<void> createCategory(String newCategory) async {
    final db = await dbInstance.database;
    final category = await db.rawQuery(
        "select * from $tableCategory where category = '$newCategory'");
    if (category.isNotEmpty) {
      log('Category already exist!');
      throw Exception('Category Already Exist!');
    } else {
      log('Category Created!');
      final cat = await db.rawInsert(
          'INSERT INTO $tableCategory(${CategoryFields.category}) VALUES(?)',
          [newCategory]);
      log('id == $cat');
    }
  }

//========== Create Category ==========
  Future<List<CategoryModel>> getAllCategories() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableCategory);
    log('results === $_result');
    final categories =
        _result.map((json) => CategoryModel.fromJson(json)).toList();
    // db.delete(tableCategory);
    return categories;
  }
}
