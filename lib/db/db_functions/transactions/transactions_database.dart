import 'dart:developer';

import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';

class TransactionDatabase {
  static final TransactionDatabase instance = TransactionDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  TransactionDatabase._init();

//======================================== Create Transactions ========================================
  Future<void> createTransaction(TransactionsModel _transaction) async {
    final db = await dbInstance.database;
    await db.insert(tableTransactions, _transaction.toJson());
  }

//======================================== Get All Transactions ========================================
  Future<List<TransactionsModel>> getAllTransactions() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions);
    log('Fetching transactions from the database', name: 'Database');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();

    return _transactions;
  }

  //======================================== Get All Sales Transactions ========================================
  Future<List<TransactionsModel>> getAllSalesTransactions() async {
    final db = await dbInstance.database;
    final _result =
        await db.query(tableTransactions, where: '${TransactionsField.salesId} IS NOT NULL AND ${TransactionsField.salesReturnId} IS NULL');
    log('Fetching sales transactions from the database', name: 'Database');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();

    return _transactions;
  }

  //======================================== Get All Purchases Transactions ========================================
  Future<List<TransactionsModel>> getAllPurchasesTransactions() async {
    final db = await dbInstance.database;
    final _result =
        await db.query(tableTransactions, where: '${TransactionsField.purchaseId} IS NOT NULL AND ${TransactionsField.purchaseReturnId} IS NULL');
    log('Fetching purchases transactions from the database', name: 'Database');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();

    return _transactions;
  }

  //======================================== Get Sales Transactions by Date ========================================
  Future<List<TransactionsModel>> getSalesTransactionsByDate({DateTime? fromDate, DateTime? toDate}) async {
    final db = await dbInstance.database;
    List _result = [];
    String? _fromDate;
    String? _toDate;
    if (fromDate != null) _fromDate = Converter.dateForDatabase.format(fromDate.subtract(const Duration(seconds: 1)));
    if (toDate != null) _toDate = Converter.dateForDatabase.format(toDate);

    if (fromDate != null && toDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) > ? AND DATE(${TransactionsField.dateTime}) < ? AND ${TransactionsField.salesId} IS NOT NULL AND ${TransactionsField.salesReturnId} IS NULL''',
          [_fromDate, _toDate]);
    } else if (fromDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) > ? AND ${TransactionsField.salesId} IS NOT NULL AND ${TransactionsField.salesReturnId} IS NULL''',
          [_fromDate]);
    } else if (toDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) < ? AND ${TransactionsField.salesId} IS NOT NULL AND ${TransactionsField.salesReturnId} IS NULL''',
          [_toDate]);
    }

    log('Fetching sales transactions by date from database...', name: 'Database');

    final _salesByDate = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _salesByDate;
  }

  //======================================== Get Purchases Transactions by Date ========================================
  Future<List<TransactionsModel>> getPurchasesTransactionsByDate({DateTime? fromDate, DateTime? toDate}) async {
    final db = await dbInstance.database;
    List _result = [];
    String? _fromDate;
    String? _toDate;
    if (fromDate != null) _fromDate = Converter.dateForDatabase.format(fromDate.subtract(const Duration(seconds: 1)));
    if (toDate != null) _toDate = Converter.dateForDatabase.format(toDate);

    if (fromDate != null && toDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) > ? AND DATE(${TransactionsField.dateTime}) < ? AND ${TransactionsField.purchaseId} IS NOT NULL AND ${TransactionsField.purchaseReturnId} IS NULL''',
          [_fromDate, _toDate]);
    } else if (fromDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) > ? AND ${TransactionsField.purchaseId} IS NOT NULL AND ${TransactionsField.purchaseReturnId} IS NULL''',
          [_fromDate]);
    } else if (toDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) < ? AND ${TransactionsField.purchaseId} IS NOT NULL AND ${TransactionsField.purchaseReturnId} IS NULL''',
          [_toDate]);
    }

    log('Fetching purchases transactions by date from database...', name: 'Database');

    final _purchasesByDate = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _purchasesByDate;
  }

  //======================================== Get Today's Sales Transactions ========================================
  Future<List<TransactionsModel>> getAllSalesTransactionsByDay(DateTime day) async {
    final String _today = Converter.dateFormatReverse.format(day);
    final db = await dbInstance.database;
    final _result = await db.rawQuery(
        '''SELECT * FROM $tableTransactions WHERE ${TransactionsField.dateTime} LIKE "$_today%" AND ${TransactionsField.salesId} IS NOT NULL AND ${TransactionsField.salesReturnId} IS NULL''');
    log('Fetching sales transactions by day..', name: 'Database');
    final List<TransactionsModel> _todaySales = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _todaySales;
  }

  //======================================== Get Cash Register Sales Transactions ========================================
  Future<List<TransactionsModel>> getCashRegisterSalesTransactions(DateTime date) async {
    final db = await dbInstance.database;
    final String _date = Converter.dateForDatabase.format(date.subtract(const Duration(days: 1)));

    final _result = await db.rawQuery(
        '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) > ? AND ${TransactionsField.salesId} IS NOT NULL AND ${TransactionsField.salesReturnId} IS NULL''',
        [_date]);
    log('Fetching Cash-Register sales transactions..', name: 'Database');
    final List<TransactionsModel> _newSales = _result.map((json) => TransactionsModel.fromJson(json)).toList();

    final List<TransactionsModel> filterdSales = [];
    for (TransactionsModel sale in _newSales) {
      final DateTime _soldDate = DateTime.parse(sale.dateTime);
      if (_soldDate.isAfter(date)) filterdSales.add(sale);
    }

    return filterdSales;
  }

  //======================================== Get Cash Register Purchases Transactions ========================================
  Future<List<TransactionsModel>> getCashRegisterPurchasesTransactions(DateTime date) async {
    final db = await dbInstance.database;
    final String _date = Converter.dateForDatabase.format(date.subtract(const Duration(days: 1)));

    final _result = await db.rawQuery(
        '''SELECT * FROM $tableTransactions WHERE DATE(${TransactionsField.dateTime}) > ? AND ${TransactionsField.purchaseId} IS NOT NULL AND ${TransactionsField.purchaseReturnId} IS NULL''',
        [_date]);
    log('Fetching Cash-Register purchases transactions..', name: 'Database');
    final List<TransactionsModel> _newPurchases = _result.map((json) => TransactionsModel.fromJson(json)).toList();

    final List<TransactionsModel> filterdPurchases = [];
    for (TransactionsModel purchase in _newPurchases) {
      final DateTime _soldDate = DateTime.parse(purchase.dateTime);
      if (_soldDate.isAfter(date)) filterdPurchases.add(purchase);
    }

    return filterdPurchases;
  }

  //======================================== Get Today's Purchases Transactions ========================================
  Future<List<TransactionsModel>> getAllPurchasesTransactionsByDay(DateTime day) async {
    final String _today = Converter.dateFormatReverse.format(day);
    final db = await dbInstance.database;
    final _result = await db.rawQuery(
        '''SELECT * FROM $tableTransactions WHERE ${TransactionsField.dateTime} LIKE "$_today%" AND ${TransactionsField.purchaseId} IS NOT NULL AND ${TransactionsField.purchaseReturnId} IS NULL''');
    log('Fetching purchases transactions by day..', name: 'Database');
    final List<TransactionsModel> _todayPurchases = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _todayPurchases;
  }

  //======================================== Get All Transactions By SalesId ========================================
  Future<List<TransactionsModel>> getAllTransactionsBySalesId(int salesId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.salesId} = ?', whereArgs: [salesId]);
    log('Fetching Transactions by Sales Id ($salesId)', name: 'Database');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //======================================== Get All Transactions By PurchaseId ========================================
  Future<List<TransactionsModel>> getAllTransactionsByPurchaseId(int purchaseId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.purchaseId} = ?', whereArgs: [purchaseId]);
    log('Fetching Transactions by Purchase Id ($purchaseId)', name: 'Database');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //======================================== Get All Transactions By CustomerId ========================================
  Future<List<TransactionsModel>> getAllTransactionsByCustomerId(int customerId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.customerId} = ?', whereArgs: [customerId]);
    log('Fetching Transactions by Customer Id ($customerId)', name: 'Database');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //======================================== Get All Transactions By SupplierId ========================================
  Future<List<TransactionsModel>> getAllTransactionsBySupplierId(int supplierId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableTransactions, where: '${TransactionsField.supplierId} = ?', whereArgs: [supplierId]);
    log('Fetching Transactions by Supplier Id ($supplierId)', name: 'Database');
    final _transactions = _result.map((json) => TransactionsModel.fromJson(json)).toList();
    return _transactions;
  }

  //======================================== Get All PayBy By Query ========================================
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
