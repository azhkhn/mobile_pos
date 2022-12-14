import 'dart:developer';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/purchase/purchase_items_model.dart';

class PurchaseItemsDatabase {
  static final PurchaseItemsDatabase instance = PurchaseItemsDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  PurchaseItemsDatabase._init();

//==================== Create Purchase Items ====================
  Future<void> createPurchaseItems(PurchaseItemsModel _purchaseItemsModel) async {
    final db = await dbInstance.database;
    final id = await db.insert(tablePurchaseItems, _purchaseItemsModel.toJson());
    log('Purchase Items Created! ($id)');
  }

  //========== Get All Purchase Items ==========
  Future<List<PurchaseItemsModel>> getPurchaseItemByPurchaseId(int purchaseId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tablePurchaseItems,
      where: '${PurchaseItemsFields.purchaseId} = ? ',
      whereArgs: [purchaseId],
    );
    // db.delete(tablePurchaseItems);
    log('Purchase Items By PurchaseId $purchaseId == $_result');
    if (_result.isNotEmpty) {
      final _purchaseItems = _result.map((json) => PurchaseItemsModel.fromJson(json)).toList();
      return _purchaseItems;
    } else {
      throw 'Purchase Items is Empty!';
    }
  }

//========== Get All Purchase Items ==========
  Future<List<PurchaseItemsModel>> getAllPurchaseItems() async {
    final db = await dbInstance.database;
    final _result = await db.query(tablePurchaseItems);
    // db.delete(tablePurchaseItems);
    log('Purchase Items == $_result');
    if (_result.isNotEmpty) {
      final _purchaseItems = _result.map((json) => PurchaseItemsModel.fromJson(json)).toList();
      return _purchaseItems;
    } else {
      throw 'Purchases Items is Empty!';
    }
  }
}
