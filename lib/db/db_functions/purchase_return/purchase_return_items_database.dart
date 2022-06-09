import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_items_modal.dart';

class PurchaseReturnItemsDatabase {
  static final PurchaseReturnItemsDatabase instance = PurchaseReturnItemsDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  PurchaseReturnItemsDatabase._init();

//==================== Create Purchase Items ====================
  Future<void> createPurchaseReturnItems(PurchaseItemsReturnModel _purchaseReturnItemsModel) async {
    final db = await dbInstance.database;
    final id = await db.insert(tablePurchaseItemsReturn, _purchaseReturnItemsModel.toJson());
    log('Purchase Return Items Created! ($id)');
  }

//========== Get All Purchase Items ==========
  Future<List<PurchaseItemsReturnModel?>?> getAllPurchaseReuturnItems() async {
    final db = await dbInstance.database;
    final _result = await db.query(tablePurchaseItemsReturn);
    // db.delete(tablePurchaseItemsReturn);
    log('Purchase Return Items == $_result');
    if (_result.isNotEmpty) {
      final _purchaseReturnItems = _result.map((json) => PurchaseItemsReturnModel.fromJson(json)).toList();
      return _purchaseReturnItems;
    } else {
      throw 'Purchase Return Items is Empty!';
    }
  }

  //========== Get All Purchase Return Items By Purchase Id ==========
  Future<List<PurchaseItemsReturnModel>> getPurchaseReturnItemByPurchaseId(int purchaseId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tablePurchaseItemsReturn,
      where: '${PurchaseReturnItemsFields.purchaseId} = ? ',
      whereArgs: [purchaseId],
    );
    // db.delete(tablePurchaseItemsReturn);
    log('Purchase Return Items By Purchase Id $purchaseId == $_result');
    if (_result.isNotEmpty) {
      final _purchaseReturnItems = _result.map((json) => PurchaseItemsReturnModel.fromJson(json)).toList();
      return _purchaseReturnItems;
    } else {
      // throw 'Purchase Return Items is Empty!';
      return [];
    }
  }
}
