import 'dart:developer';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';

class PurchaseDatabase {
  static final PurchaseDatabase instance = PurchaseDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  PurchaseDatabase._init();

//==================== Create Purchase ====================
  Future<int> createPurchase(PurchaseModel _purchaseModel) async {
    final db = await dbInstance.database;

    final _purchase = await db.rawQuery('''select * from $tablePurchase where ${PurchaseFields.invoiceNumber} = "${_purchaseModel.invoiceNumber}"''');

    if (_purchase.isNotEmpty) {
      throw 'Invoice Number Already Exist!';
    } else {
      final _purchases = await db.query(tablePurchase);

      if (_purchases.isNotEmpty) {
        final _recentPurchase = PurchaseModel.fromJson(_purchases.last);

        final int? _recentPurchaseId = _recentPurchase.id;
        log('Recent id == $_recentPurchaseId');

        final String _invoiceNumber = 'PR-${_recentPurchaseId! + 1}';
        final _newPurchase = _purchaseModel.copyWith(invoiceNumber: _invoiceNumber);
        log('New Invoice Number == $_invoiceNumber');

        final id = await db.insert(tablePurchase, _newPurchase.toJson());
        log('Purchase Created! ($id)');
        return id;
      } else {
        final _newPurchase = _purchaseModel.copyWith(invoiceNumber: 'PR-1');

        log('New Invoice Number == ' + _newPurchase.invoiceNumber!);
        final id = await db.insert(tablePurchase, _newPurchase.toJson());
        log('Purchase Created! ($id)');
        return id;
      }
    }
  }

  //========== Get All Purchases By Query ==========
  Future<List<PurchaseModel>> getPurchaseByInvoiceSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final List<Map<String, Object?>> res;
    if (pattern.isNotEmpty) {
      res = await db.rawQuery(
          '''select * from $tablePurchase where ${PurchaseFields.invoiceNumber} LIKE "%$pattern%" OR ${PurchaseFields.referenceNumber} LIKE "%$pattern%" ORDER BY _id DESC limit 20''');
    } else {
      res = await db.query(tablePurchase, limit: 10, orderBy: '_id DESC');
    }

    List<PurchaseModel> list = res.isNotEmpty ? res.map((c) => PurchaseModel.fromJson(c)).toList() : [];

    return list;
  }

  //========== Get All Purchases By Query ==========
  Future<List<PurchaseModel>> getPurchasesBySupplierId(String id) async {
    final db = await dbInstance.database;
    final res = await db.query(
      tablePurchase,
      where: '${PurchaseFields.supplierId} = ?',
      whereArgs: [id],
    );

    List<PurchaseModel> list = res.isNotEmpty ? res.map((c) => PurchaseModel.fromJson(c)).toList() : [];

    return list;
  }

  //========== Update Purchase By PurchaseId ==========
  Future<void> updatePurchaseByPurchaseId({required final PurchaseModel purchase}) async {
    final db = await dbInstance.database;
    await db.update(tablePurchase, purchase.toJson(), where: '${PurchaseFields.id} = ?', whereArgs: [purchase.id]);
    log('Purchase (${purchase.id}) Updated Successfully!');
  }

  //========== Get Today's Purchase ==========
  Future<List<PurchaseModel>> getPurchasesByDay(DateTime day) async {
    final String _today = Converter.dateFormatReverse.format(day);
    final db = await dbInstance.database;
    final _result = await db.rawQuery('''SELECT * FROM $tablePurchase WHERE ${PurchaseFields.dateTime} LIKE "$_today%"''');
    log('Purchase of Today === $_result');

    final _todayPurchase = _result.map((json) => PurchaseModel.fromJson(json)).toList();
    return _todayPurchase;
  }

  //========== Get New Purchase ==========
  Future<List<PurchaseModel>> getNewPurchases(DateTime date) async {
    final db = await dbInstance.database;
    final String _date = Converter.dateForDatabase.format(date.subtract(const Duration(days: 1)));
    final _result = await db.rawQuery('''SELECT * FROM $tablePurchase WHERE DATE(${PurchaseFields.dateTime}) > ?''', [_date]);
    log('Purchase of $date === $_result');

    final _todayPurchase = _result.map((json) => PurchaseModel.fromJson(json)).toList();

    final List<PurchaseModel> filterdPurchases = [];
    for (PurchaseModel purchase in _todayPurchase) {
      final DateTime _purchasedDate = DateTime.parse(purchase.dateTime);
      if (_purchasedDate.isAfter(date)) filterdPurchases.add(purchase);
    }

    return filterdPurchases;
  }

//========== Get All Purchases ==========
  Future<List<PurchaseModel>> getAllPurchases() async {
    final db = await dbInstance.database;
    final _result = await db.query(tablePurchase);
    // db.delete(tablePurchase);
    log('Fetching purchases from the database');
    final _purchases = _result.map((json) => PurchaseModel.fromJson(json)).toList();
    return _purchases;
  }

  //========== Get Purchases Date ==========
  Future<List<PurchaseModel>> getPurchasesByDate({DateTime? fromDate, DateTime? toDate}) async {
    final db = await dbInstance.database;
    List _result = [];
    String? _fromDate;
    String? _toDate;
    if (fromDate != null) _fromDate = Converter.dateForDatabase.format(fromDate.subtract(const Duration(seconds: 1)));
    if (toDate != null) _toDate = Converter.dateForDatabase.format(toDate);

    if (fromDate != null && toDate != null) {
      _result = await db.rawQuery(
          '''SELECT * FROM $tablePurchase WHERE DATE(${PurchaseFields.dateTime}) > ? AND DATE(${PurchaseFields.dateTime}) < ?''',
          [_fromDate, _toDate]);
    } else if (fromDate != null) {
      _result = await db.rawQuery('''SELECT * FROM $tablePurchase WHERE DATE(${PurchaseFields.dateTime}) > ?''', [_fromDate]);
    } else if (toDate != null) {
      _result = await db.rawQuery('''SELECT * FROM $tablePurchase WHERE DATE(${PurchaseFields.dateTime}) < ?''', [_toDate]);
    }

    log('Purchases By Date === $_result');

    final _todayPurchases = _result.map((json) => PurchaseModel.fromJson(json)).toList();
    return _todayPurchases;
  }

  //========== Get Pending Payment Purchase ==========
  Future<List<PurchaseModel>> getPendingPurchases() async {
    final db = await dbInstance.database;
    final res = await db.query(
      tablePurchase,
      where: "${PurchaseFields.paymentStatus} NOT IN('Paid','Returned')",
    );

    log('Purchase with pending amount == $res');

    List<PurchaseModel> list = res.map((c) => PurchaseModel.fromJson(c)).toList();

    return list;
  }
}
