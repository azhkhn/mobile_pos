import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';

class SalesItemsDatabase {
  static final SalesItemsDatabase instance = SalesItemsDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SalesItemsDatabase._init();

//==================== Create Sales Items ====================
  Future<void> createSalesItems(SalesItemsModel _salesItemsModel) async {
    final db = await dbInstance.database;
    final id = await db.insert(tableSalesItems, _salesItemsModel.toJson());
    log('Sales Items Created! ($id)');
  }

  //========== Get All Sales Items ==========
  Future<List<SalesItemsModel>> getSalesItemBySaleId(int saleId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableSalesItems,
      where: '${SalesItemsFields.saleId} = ? ',
      whereArgs: [saleId],
    );
    // db.delete(tableSalesItems);
    log('Fetching sales Items By SaleId $saleId from database..');
    if (_result.isNotEmpty) {
      final _salesItems = _result.map((json) => SalesItemsModel.fromJson(json)).toList();
      return _salesItems;
    } else {
      throw 'Sales Items is Empty!';
    }
  }

//========== Get All Sales Items ==========
  Future<List<SalesItemsModel?>?> getAllSalesItems() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSalesItems);
    // db.delete(tableSalesItems);
    log('Sales Items == $_result');
    if (_result.isNotEmpty) {
      final _salesItems = _result.map((json) => SalesItemsModel.fromJson(json)).toList();
      return _salesItems;
    } else {
      throw 'Sales Items is Empty!';
    }
  }
}
