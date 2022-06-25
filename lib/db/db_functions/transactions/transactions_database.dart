import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';

class TransactionDatabase {
  static final TransactionDatabase instance = TransactionDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  TransactionDatabase._init();

//==================== Create Transactions ====================
  Future<void> createTransaction(TransactionsModel _transaction) async {
    final db = await dbInstance.database;
    await db.insert(tableTransactions, _transaction.toJson());
  }

//==================== Get All Transactions ====================
  Future<List<TransactionsModel>> getAllTransactions() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions);
    log('Transactions == $_result');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();

    return _transactions;
  }

  //==================== Get All Transactions By SalesId ====================
  Future<List<TransactionsModel>> getAllTransactionsBySalesId(int salesId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.salesId} = ?', whereArgs: [salesId]);
    log('Transactions by Sales Id ($salesId) == $_result');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //==================== Get All Transactions By PurchaseId ====================
  Future<List<TransactionsModel>> getAllTransactionsByPurchaseId(int purchaseId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.purchaseId} = ?', whereArgs: [purchaseId]);
    log('Transactions by Purchase Id ($purchaseId) == $_result');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //==================== Get All Transactions By CustomerId ====================
  Future<List<TransactionsModel>> getAllTransactionsByCustomerId(int customerId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.customerId} = ?', whereArgs: [customerId]);
    log('Transactions by Customer Id ($customerId) == $_result');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //==================== Get All Transactions By SupplierId ====================
  Future<List<TransactionsModel>> getAllTransactionsBySupplierId(int supplierId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.supplierId} = ?', whereArgs: [supplierId]);
    log('Transactions by Supplier Id ($supplierId) == $_result');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //========== Get All PayBy By Query ==========
  Future<List<TransactionsModel>> getPayBySuggestions(String pattern) async {
    final db = await dbInstance.database;
    final List<Map<String, Object?>> res;
    if (pattern.isNotEmpty) {
      res = await db.rawQuery('''select * from $tableTransactions where ${TransactionsField.payBy} LIKE "%$pattern%" limit 20''');
    } else {
      res = await db.query(tableTransactions, where: '${TransactionsField.payBy} IS NOT NULL', limit: 10);
    }

    final List<TransactionsModel> list = res.map((c) => TransactionsModel.fromJson(c)).toList();

    final List<String> payers = [];
    final List<TransactionsModel> trimmedList = [];

    for (var transaction in list) {
      if (!payers.contains(transaction.payBy)) {
        payers.add(transaction.payBy!);
        trimmedList.add(transaction);
      }
    }

    return trimmedList;
  }
}
