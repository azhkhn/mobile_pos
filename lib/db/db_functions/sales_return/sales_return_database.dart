import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sales_return/sales_return_model.dart';

class SalesReturnDatabase {
  static final SalesReturnDatabase instance = SalesReturnDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SalesReturnDatabase._init();

//==================== Create Sales Return ====================
  Future<int> createSalesReturn(SalesReturnModal _salesReturnModel) async {
    final db = await dbInstance.database;

    final _saleReturn = await db.rawQuery(
        "select * from $tableSalesReturn where ${SalesReturnFields.invoiceNumber} = '${_salesReturnModel.invoiceNumber}'");

    if (_saleReturn.isNotEmpty) {
      throw 'Invoice Number Already Exist!';
    } else {
      final _sales = await db.query(tableSalesReturn);

      if (_sales.isNotEmpty) {
        final _recentSale = SalesReturnModal.fromJson(_sales.last);

        final int? _recentSaleId = _recentSale.id;
        log('Recent id == $_recentSaleId');

        final String _invoiceNumber = 'SR-${_recentSaleId! + 1}';
        final _newSale =
            _salesReturnModel.copyWith(invoiceNumber: _invoiceNumber);
        log('New Invoice Number == $_invoiceNumber');

        final id = await db.insert(tableSalesReturn, _newSale.toJson());
        log('Sale Returned! ($id)');
        return id;
      } else {
        final _newSale = _salesReturnModel.copyWith(invoiceNumber: 'SR-1');

        log('New Invoice Number == ' + _newSale.invoiceNumber!);
        final id = await db.insert(tableSalesReturn, _newSale.toJson());
        log('Sale Returned! ($id)');
        return id;
      }
    }
  }

//========== Get Today's Sales ==========
  // Future<List<SalesReturnModal>> getTodaySales(String today) async {
  //   final db = await dbInstance.database;
  //   final _result = await db.rawQuery(
  //       "SELECT * FROM $tableSalesReturn WHERE ${SalesReturnFields.dateTime} LIKE '%$today%'");
  //   log('Sales of Today === $_result');
  //   if (_result.isNotEmpty) {
  //     final _todaySales =
  //         _result.map((json) => SalesReturnModal.fromJson(json)).toList();
  //     return _todaySales;
  //   } else {
  //     throw 'Sales of Today is Empty!';
  //   }
  // }

  //========== Get All Sales By Query ==========
  // Future<List<SalesReturnModal>> getSalesByInvoiceSuggestions(
  //     String pattern) async {
  //   final db = await dbInstance.database;
  //   final res = await db.rawQuery(
  //       "select * from $tableSalesReturn where ${SalesReturnFields.invoiceNumber} LIKE '%$pattern%'");

  //   List<SalesReturnModal> list = res.isNotEmpty
  //       ? res.map((c) => SalesReturnModal.fromJson(c)).toList()
  //       : [];

  //   return list;
  // }

  //========== Get All Sales By Query ==========
  // Future<List<SalesReturnModal>> getSalesByCustomerId(String id) async {
  //   final db = await dbInstance.database;
  //   final res = await db.query(
  //     tableSalesReturn,
  //     where: '${SalesReturnFields.customerId} = ?',
  //     whereArgs: [id],
  //   );

  //   List<SalesReturnModal> list = res.isNotEmpty
  //       ? res.map((c) => SalesReturnModal.fromJson(c)).toList()
  //       : [];

  //   return list;
  // }

//========== Get All Sales ==========
  Future<List<SalesReturnModal>> getAllSalesReturns() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSalesReturn);
    // db.delete(tableSalesReturnReturn);
    log('Sales Returns == $_result');
    if (_result.isNotEmpty) {
      final _salesReturn =
          _result.map((json) => SalesReturnModal.fromJson(json)).toList();
      return _salesReturn;
    } else {
      throw 'Sales is Empty!';
    }
  }
}
