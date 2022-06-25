import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_modal.dart';

class PurchaseReturnDatabase {
  static final PurchaseReturnDatabase instance = PurchaseReturnDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  PurchaseReturnDatabase._init();

//==================== Create Purchase Return ====================
  Future<List> createPurchaseReturn(PurchaseReturnModel _purchaseReturnModel) async {
    final db = await dbInstance.database;

    final _purchaseReturn = await db
        .rawQuery('''select * from $tablePurchaseReturn where ${PurchaseReturnFields.invoiceNumber} = "${_purchaseReturnModel.invoiceNumber}"''');

    if (_purchaseReturn.isNotEmpty) {
      throw 'Invoice Number Already Exist!';
    } else {
      final _purchase = await db.query(tablePurchaseReturn);

      if (_purchase.isNotEmpty) {
        final _recentPurchase = PurchaseReturnModel.fromJson(_purchase.last);

        final int? _recentPurchaseId = _recentPurchase.id;
        log('Recent id == $_recentPurchaseId');

        final String _invoiceNumber = 'PN-${_recentPurchaseId! + 1}';
        final _newPurchase = _purchaseReturnModel.copyWith(invoiceNumber: _invoiceNumber);
        log('New Invoice Number == $_invoiceNumber');

        final id = await db.insert(tablePurchaseReturn, _newPurchase.toJson());
        log('Purchase Returned! ($id)');
        return [id, _invoiceNumber];
      } else {
        final _newPurchase = _purchaseReturnModel.copyWith(invoiceNumber: 'PN-1');

        log('New Invoice Number == ' + _newPurchase.invoiceNumber!);
        final id = await db.insert(tablePurchaseReturn, _newPurchase.toJson());
        log('Purchase Returned! ($id)');
        return [id, 'PN-1'];
      }
    }
  }

//========== Get Today's Purchases ==========
  // Future<List<PurchaseReturnModel>> getTodayPurchases(String today) async {
  //   final db = await dbInstance.database;
  //   final _result = await db.rawQuery(
  //       '''SELECT * FROM $tablePurchaseReturn WHERE ${PurchaseReturnFields.dateTime} LIKE "%$today%"''');
  //   log('Purchases of Today === $_result');
  //   if (_result.isNotEmpty) {
  //     final _todayPurchases =
  //         _result.map((json) => PurchaseReturnModel.fromJson(json)).toList();
  //     return _todayPurchases;
  //   } else {
  //     throw 'Purchases of Today is Empty!';
  //   }
  // }

  // ========== Get All Purchases By Query ==========
  Future<List<PurchaseReturnModel>> getPurchasesByInvoiceSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final List<Map<String, Object?>> res;

    if (pattern.isNotEmpty) {
      res = await db.rawQuery(
          '''select * from $tablePurchaseReturn where ${PurchaseReturnFields.invoiceNumber} LIKE "%$pattern%" ORDER BY _id DESC limit 20''');
    } else {
      res = await db.query(tablePurchaseReturn, orderBy: '_id DESC', limit: 10);
    }

    List<PurchaseReturnModel> list = res.isNotEmpty ? res.map((c) => PurchaseReturnModel.fromJson(c)).toList() : [];

    return list;
  }

  // ========== Get All Purchases By Query ==========
  Future<List<PurchaseReturnModel>> getPurchasesBySupplierId(String supplierId) async {
    final db = await dbInstance.database;
    final res = await db.query(
      tablePurchaseReturn,
      where: '${PurchaseReturnFields.supplierId} = ?',
      whereArgs: [supplierId],
    );

    List<PurchaseReturnModel> list = res.isNotEmpty ? res.map((c) => PurchaseReturnModel.fromJson(c)).toList() : [];

    return list;
  }

//========== Get All Purchases ==========
  Future<List<PurchaseReturnModel>> getAllPurchasesReturns() async {
    final db = await dbInstance.database;
    final _result = await db.query(tablePurchaseReturn);
    // db.delete(tablePurchaseReturnReturn);
    log('Purchases Returns == $_result');
    if (_result.isNotEmpty) {
      final _purchaseReturn = _result.map((json) => PurchaseReturnModel.fromJson(json)).toList();
      return _purchaseReturn;
    } else {
      throw 'Purchases Return is Empty!';
    }
  }
}
