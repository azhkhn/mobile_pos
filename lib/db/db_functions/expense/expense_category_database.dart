// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';

class ExpenseCategoryDatabase {
  static final ExpenseCategoryDatabase instance =
      ExpenseCategoryDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  ExpenseCategoryDatabase._init();

  //========== Value Notifiers ==========
  static final ValueNotifier<List<ExpenseCategoryModel>>
      expenseCategoryNotifiers = ValueNotifier([]);

//========== Create Expense Category ==========
  Future<void> createExpenseCategory(
      ExpenseCategoryModel _expenseCategoryModel) async {
    final db = await dbInstance.database;
    final _expenseCategory = await db.rawQuery(
        '''select * from $tableExpenseCategory where ${ExpenseCategoryFields.expense} = "${_expenseCategoryModel.expense}" COLLATE NOCASE''');
    if (_expenseCategory.isNotEmpty) {
      log('Expense Category already exist!');
      throw Exception('Expense Category Already Exist!');
    } else {
      log('Expense Category Created!');
      final id =
          await db.insert(tableExpenseCategory, _expenseCategoryModel.toJson());
      log('Expense Category Id == $id');
    }
  }

  //========== Delete Expense Category ==========
  Future<void> deleteExpenseCategory(int id) async {
    final db = await dbInstance.database;
    await db.delete(tableExpenseCategory,
        where: '${ExpenseCategoryFields.id} = ? ', whereArgs: [id]);
    log('Expense Category $id Deleted Successfully!');
    expenseCategoryNotifiers.value
        .removeWhere((categories) => categories.id == id);
    expenseCategoryNotifiers.notifyListeners();
  }

//========== Get All Expense Category ==========
  Future<List<ExpenseCategoryModel>> getAllExpenseCategories() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableExpenseCategory);
    log('Expense Categories === $_result');
    final _expenseCategories =
        _result.map((json) => ExpenseCategoryModel.fromJson(json)).toList();
    // db.delete(tableExpenseCategory);
    return _expenseCategories;
  }
}
