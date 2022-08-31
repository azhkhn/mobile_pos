import 'dart:developer';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/sales_return/sales_return_items_model.dart';

class SalesReturnItemsDatabase {
  static final SalesReturnItemsDatabase instance = SalesReturnItemsDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SalesReturnItemsDatabase._init();

//==================== Create Sales Items ====================
  Future<void> createSalesReturnItems(SalesReturnItemsModel _salesReturnItemsModel) async {
    final db = await dbInstance.database;
    final id = await db.insert(tableSalesReturnItems, _salesReturnItemsModel.toJson());
    log('Sales Return Items Created! ($id)');
  }

  //========== Get All Sales Return Items By Sale Return Id ==========
  Future<List<SalesReturnItemsModel>> getSalesReturnItemBySaleReturnId(int salesReturnId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableSalesReturnItems,
      where: '${SalesReturnItemsFields.saleReturnId} = ? ',
      whereArgs: [salesReturnId],
    );
    // db.delete(tableSalesItems);
    log('Sales Return Items By SaleReturnId $salesReturnId == $_result');
    if (_result.isNotEmpty) {
      final _salesReturnItems = _result.map((json) => SalesReturnItemsModel.fromJson(json)).toList();
      return _salesReturnItems;
    } else {
      throw 'Sales Return Items is Empty!';
    }
  }

  //========== Get All Sales Return Items By Sales Id ==========
  Future<List<SalesReturnItemsModel>> getSalesReturnItemBySalesId(int salesId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableSalesReturnItems,
      where: '${SalesReturnItemsFields.saleId} = ? ',
      whereArgs: [salesId],
    );
    // db.delete(tableSalesItems);
    log('Sales Return Items By Sales Id $salesId == $_result');
    if (_result.isNotEmpty) {
      final _salesReturnItems = _result.map((json) => SalesReturnItemsModel.fromJson(json)).toList();
      return _salesReturnItems;
    } else {
      // throw 'Sales Return Items is Empty!';
      return [];
    }
  }

//========== Get All Sales Items ==========
  Future<List<SalesReturnItemsModel?>?> getAllSalesReuturnItems() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSalesReturnItems);
    // db.delete(tableSalesReturnItems);
    log('Sales Return Items == $_result');
    if (_result.isNotEmpty) {
      final _salesReturnItems = _result.map((json) => SalesReturnItemsModel.fromJson(json)).toList();
      return _salesReturnItems;
    } else {
      throw 'Sales Return Items is Empty!';
    }
  }
}
