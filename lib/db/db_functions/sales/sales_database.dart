import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

class SalesDatabase {
  static final SalesDatabase instance = SalesDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SalesDatabase._init();

//==================== Create Sales ====================
  Future<int> createSales(SalesModel _salesModel) async {
    final db = await dbInstance.database;

    final _sale = await db.rawQuery(
        "select * from $tableSales where ${SalesFields.invoiceNumber} = '${_salesModel.invoiceNumber}'");

    if (_sale.isNotEmpty) {
      throw 'Invoice Number Already Exist!';
    } else {
      final _sales = await db.query(tableSales);

      if (_sales.isNotEmpty) {
        final _recentSale = SalesModel.fromJson(_sales.last);

        final int? _recentSaleId = _recentSale.id;
        log('Recent id == $_recentSaleId');

        final String _invoiceNumber = 'SA-${_recentSaleId! + 1}';
        final _newSale = _salesModel.copyWith(invoiceNumber: _invoiceNumber);
        log('New Invoice Number == $_invoiceNumber');

        final id = await db.insert(tableSales, _newSale.toJson());
        log('Sale Created! ($id)');
        return id;
      } else {
        final _newSale = _salesModel.copyWith(invoiceNumber: 'SA-1');

        log('New Invoice Number == ' + _newSale.invoiceNumber!);
        final id = await db.insert(tableSales, _newSale.toJson());
        log('Sale Created! ($id)');
        return id;
      }
    }
  }

//========== Get All Sales ==========
  Future<List<SalesModel>> getAllSales() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSales);
    // db.delete(tableSales);
    log('Sales == $_result');
    if (_result.isNotEmpty) {
      final _sales = _result.map((json) => SalesModel.fromJson(json)).toList();
      return _sales;
    } else {
      throw 'Sales is Empty!';
    }
  }
}
