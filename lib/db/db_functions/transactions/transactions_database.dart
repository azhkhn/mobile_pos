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
}
