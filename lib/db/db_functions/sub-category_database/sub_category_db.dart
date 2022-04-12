import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';

class SubCategoryDatabase {
  static final SubCategoryDatabase instance = SubCategoryDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SubCategoryDatabase._init();

//========== Create Sub-Category ==========
  Future<void> createSubCategory(SubCategoryModel _subCategoryModel) async {
    final db = await dbInstance.database;
    final _subCategory = await db.rawQuery(
        "SELECT * FROM $tableSubCategory WHERE ${SubCategoryFields.category} = '${_subCategoryModel.category}' AND ${SubCategoryFields.subCategory} = '${_subCategoryModel.subCategory}'");
    if (_subCategory.isNotEmpty) {
      log('Sub-Category Already Exist!');
      throw Exception('Sub-Category Already Exist!');
    } else {
      log('Sub-Category Created!');
      final id = await db.insert(tableSubCategory, _subCategoryModel.toJson());
      log('Sub-Category id == $id');
    }
  }

//========== Get Sub-Categories by Category ==========
  Future<List<SubCategoryModel>> getSubCategoryByCategory(
      {required String category}) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableSubCategory,
      columns: ['_id', 'category', 'subCategory'],
      where: 'category = ?',
      whereArgs: [category],
    );
    log('subCategories of $category == $_result');
    final _subCategories =
        _result.map((json) => SubCategoryModel.fromJson(json)).toList();
    return _subCategories;
  }

//========== Get All Sub-Categories ==========
  Future<List<SubCategoryModel>> getAllSubCategories() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSubCategory);
    log('subCategories == $_result');
    final _subCategories =
        _result.map((json) => SubCategoryModel.fromJson(json)).toList();
    return _subCategories;
  }

  //========== Delete Sub-Category ==========
  Future<void> deleteVAT(int id) async {
    final db = await dbInstance.database;
    final _result = await db.delete(tableSubCategory,
        where: '${SubCategoryFields.id} = ?', whereArgs: [id]);
    log('Sub-Category $id Deleted == $_result');
  }
}
