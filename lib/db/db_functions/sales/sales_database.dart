import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

class SalesDatabase {
  static final SalesDatabase instance = SalesDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SalesDatabase._init();

//========== Create Sales ==========
  Future<void> createSales(SalesModel _salesModel) async {
    final db = await dbInstance.database;

    final _sale = await db.rawQuery(
        "select * from $tableSales where ${SalesFields.salesId} = '${_salesModel.salesId}'");

    if (_sale.isNotEmpty) {
      throw 'SalesId Already Exist!';
    } else {
      log('Sale Created!');
      final id = await db.insert(tableSales, _salesModel.toJson());
      log('Sale id = $id');
    }
  }

//========== Get All Sales ==========
  Future<SalesModel?> getAllSales() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSales);
    // db.delete(tableSales);
    log('Sales == $_result');
    if (_result.isNotEmpty) {
      final _sales = _result.map((json) => SalesModel.fromJson(json)).toList();
      return _sales.first;
    } else {
      return null;
    }
  }
}
