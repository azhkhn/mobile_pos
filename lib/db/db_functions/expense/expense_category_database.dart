import 'dart:developer' show log;
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';

class ExpenseCategoryDatabase {
  static final ExpenseCategoryDatabase instance =
      ExpenseCategoryDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  ExpenseCategoryDatabase._init();

//========== Create Expense Category ==========
  Future<void> createExpenseCategory(
      ExpenseCategoryModel _expenseCategoryModel) async {
    final db = await dbInstance.database;
    final _expenseCategory = await db.rawQuery(
        "select * from $tableExpenseCategory where ${ExpenseCategoryFields.expense} = '${_expenseCategoryModel.expense}'");
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
