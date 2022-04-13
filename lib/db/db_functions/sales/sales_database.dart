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
      final _sales = await db.query(tableSales);

      if (_sales.isNotEmpty) {
        final _recentSale = SalesModel.fromJson(_sales.last);

        final int? _recentSaleId = _recentSale.id;
        log('Recent id == $_recentSaleId');

        final String _salesId = 'SA-${_recentSaleId! + 1}';
        final _newSale = _salesModel.copyWith(salesId: _salesId);
        log('New Sale id == $_salesId');

        final id = await db.insert(tableSales, _newSale.toJson());
        log('New id == $id');
        log('Sale Created!');
      } else {
        final _newSale = _salesModel.copyWith(salesId: 'SA-1');
        log('Sales Model Id === ${_newSale.billerName}');

        log('Sales Model Sales Id === ' + _newSale.salesId!);
        final id = await db.insert(tableSales, _newSale.toJson());
        log('Sale Created!');
        log('id == $id');
      }
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
