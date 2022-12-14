import 'dart:developer';

import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/expense/expense_model.dart';

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
    log('Fetching expenses from the database...');
    final _expenses = _result.map((json) => ExpenseModel.fromJson(json)).toList();
    return _expenses;
  }

  //========== Get Today's Expense ==========
  Future<List<ExpenseModel>> getExpensesByDay(DateTime day) async {
    final String _today = Converter.dateFormatReverse.format(day);
    final db = await dbInstance.database;
    final _result = await db.rawQuery('''SELECT * FROM $tableExpense WHERE ${ExpenseFields.dateTime} LIKE "$_today%"''');
    log('Expense of Today === $_result');

    final _todayExpense = _result.map((json) => ExpenseModel.fromJson(json)).toList();
    return _todayExpense;
  }

  //========== Get New Expense ==========
  Future<List<ExpenseModel>> getNewExpense(DateTime date) async {
    final db = await dbInstance.database;
    final String _date = Converter.dateForDatabase.format(date.subtract(const Duration(days: 1)));
    final _result = await db.rawQuery('''SELECT * FROM $tableExpense WHERE DATE(${ExpenseFields.dateTime}) > ?''', [_date]);
    log('Expense of $date === $_result');

    final _todayExpenses = _result.map((json) => ExpenseModel.fromJson(json)).toList();

    final List<ExpenseModel> filterdExpenses = [];
    for (ExpenseModel expense in _todayExpenses) {
      final DateTime expenseDate = DateTime.parse(expense.dateTime);
      if (expenseDate.isAfter(date)) filterdExpenses.add(expense);
    }

    return filterdExpenses;
  }

  //========== Get Expenses Date ==========
  Future<List<ExpenseModel>> getExpensesByDate({DateTime? fromDate, DateTime? toDate}) async {
    final db = await dbInstance.database;
    List _result = [];
    String? _fromDate;
    String? _toDate;
    if (fromDate != null) _fromDate = Converter.dateForDatabase.format(fromDate.subtract(const Duration(seconds: 1)));
    if (toDate != null) _toDate = Converter.dateForDatabase.format(toDate);

    if (fromDate != null && toDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tableExpense WHERE DATE(${ExpenseFields.dateTime}) > ? AND DATE(${ExpenseFields.dateTime}) < ?''', [_fromDate, _toDate]);
    } else if (fromDate != null) {
      _result = await db.rawQuery('''SELECT * FROM $tableExpense WHERE DATE(${ExpenseFields.dateTime}) > ?''', [_fromDate]);
    } else if (toDate != null) {
      _result = await db.rawQuery('''SELECT * FROM $tableExpense''');
    }

    log('Expenses By Date === $_result');

    final _expensesByDate = _result.map((json) => ExpenseModel.fromJson(json)).toList();
    return _expensesByDate;
  }

  //========== Get PayBy Suggestions ==========
  Future<List<ExpenseModel>> getPayBySuggestions(String pattern) async {
    final db = await dbInstance.database;
    final List<Map<String, Object?>> _res;
    if (pattern.isNotEmpty) {
      _res = await db.query(tableExpense, where: "${ExpenseFields.payBy} LIKE '%$pattern%'", limit: 20);
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
