// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/expense/expense_category_model.dart';

class ExpenseCategoryDatabase {
  static final ExpenseCategoryDatabase instance = ExpenseCategoryDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  ExpenseCategoryDatabase._init();

  //========== Value Notifiers ==========
  static final ValueNotifier<List<ExpenseCategoryModel>> expenseCategoryNotifier = ValueNotifier([]);

//========== Create Expense Category ==========
  Future<void> createExpenseCategory(ExpenseCategoryModel _expenseCategoryModel) async {
    final db = await dbInstance.database;
    final _expenseCategory = await db.rawQuery(
        '''select * from $tableExpenseCategory where ${ExpenseCategoryFields.expense} = "${_expenseCategoryModel.expense}" COLLATE NOCASE''');
    if (_expenseCategory.isNotEmpty) {
      log('Expense Category already exist!');
      throw Exception('Expense Category Already Exist!');
    } else {
      log('Expense Category Created!');
      final id = await db.insert(tableExpenseCategory, _expenseCategoryModel.toJson());
      log('Expense Category Id == $id');
    }
  }

  //========== Delete Expense Category ==========
  Future<void> deleteExpenseCategory(int id) async {
    final db = await dbInstance.database;
    await db.delete(tableExpenseCategory, where: '${ExpenseCategoryFields.id} = ? ', whereArgs: [id]);
    log('Expense Category $id Deleted Successfully!');
    expenseCategoryNotifier.value.removeWhere((categories) => categories.id == id);
    expenseCategoryNotifier.notifyListeners();
  }

  //========== Update Expense Category ==========
  Future<void> updateExpenseCategory({required ExpenseCategoryModel expenseCategory, required String expenseCategoryName}) async {
    final db = await dbInstance.database;
    final updatedExpenseCategory = expenseCategory.copyWith(expense: expenseCategoryName);
    await db.update(
      tableExpenseCategory,
      updatedExpenseCategory.toJson(),
      where: '${ExpenseCategoryFields.id} = ?',
      whereArgs: [expenseCategory.id],
    );
    log('Expense Category ${expenseCategory.id} Updated Successfully');
    final index = expenseCategoryNotifier.value.indexOf(expenseCategory);
    expenseCategoryNotifier.value[index] = updatedExpenseCategory;
    expenseCategoryNotifier.notifyListeners();
  }

  //========== Get Expense Categories Suggestions ==========
  Future<List<ExpenseCategoryModel>> getExpenseCategoriesSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final List<Map<String, Object?>> _res;
    if (pattern.isNotEmpty) {
      _res = await db.query(tableExpenseCategory, where: "${ExpenseCategoryFields.expense} LIKE '%$pattern%'", limit: 20);
    } else {
      _res = await db.query(tableExpenseCategory, limit: 10);
    }

    log('getExpenseCategoriesSuggestions == ' + _res.toString());

    final List<ExpenseCategoryModel> list = _res.map((c) => ExpenseCategoryModel.fromJson(c)).toList();

    return list;
  }

//========== Get All Expense Category ==========
  Future<List<ExpenseCategoryModel>> getAllExpenseCategories() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableExpenseCategory);
    log('Expense Categories === $_result');
    final _expenseCategories = _result.map((json) => ExpenseCategoryModel.fromJson(json)).toList();
    // db.delete(tableExpenseCategory);
    return _expenseCategories;
  }
}
