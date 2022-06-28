import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/expense/expense_model.dart';

class ExpenseDatabase {
  static final ExpenseDatabase instance = ExpenseDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  ExpenseDatabase._init();

//========== Create Expense ==========
  Future<void> createExpense(ExpenseModel _expenseModel) async {
    final db = await dbInstance.database;
    log('Expense Added!');
    final id = await db.insert(tableExpense, _expenseModel.toJson());
    log('Expense id == $id');
  }

//========== Get All Expenses ==========
  Future<List<ExpenseModel>> getAllExpense() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableExpense);
    // db.delete(tableExpense);
    log('Expenses == $_result');
    final _expenses = _result.map((json) => ExpenseModel.fromJson(json)).toList();
    return _expenses;
  }

  //========== Get PayBy Suggestions ==========
  Future<List<ExpenseModel>> getPayBySuggestions(String pattern) async {
    final db = await dbInstance.database;
    final List<Map<String, Object?>> _res;
    if (pattern.isNotEmpty) {
      _res = await db.query(tableExpense, where: '${ExpenseFields.expenseTitle} LIKE %$pattern%', limit: 20);
    } else {
      _res = await db.query(tableExpense, limit: 10);
    }

    final List<ExpenseModel> list = _res.map((c) => ExpenseModel.fromJson(c)).toList();

    final List<String> payers = [];
    final List<ExpenseModel> trimmedList = [];

    for (var transaction in list) {
      if (!payers.contains(transaction.payBy)) {
        payers.add(transaction.payBy);
        trimmedList.add(transaction);
      }
    }

    return trimmedList;
  }
}
