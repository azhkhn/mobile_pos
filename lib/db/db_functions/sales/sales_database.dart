import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

class SalesDatabase {
  static final SalesDatabase instance = SalesDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SalesDatabase._init();

//==================== Create Sales ====================
  Future<SalesModel> createSales(SalesModel _salesModel) async {
    final db = await dbInstance.database;

    final _sale = await db.rawQuery('''select * from $tableSales where ${SalesFields.invoiceNumber} = "${_salesModel.invoiceNumber}"''');

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
        return _newSale.copyWith(id: id);
      } else {
        final _newSale = _salesModel.copyWith(invoiceNumber: 'SA-1');

        log('New Invoice Number == ' + _newSale.invoiceNumber!);
        final id = await db.insert(tableSales, _newSale.toJson());
        log('Sale Created! ($id)');
        return _newSale.copyWith(id: id);
      }
    }
  }

//========== Get Today's Sales ==========
  Future<List<SalesModel>> getTodaySales(String today) async {
    final db = await dbInstance.database;
    final _result = await db.rawQuery('''SELECT * FROM $tableSales WHERE ${SalesFields.dateTime} LIKE "%$today%"''');
    log('Sales of Today === $_result');
    if (_result.isNotEmpty) {
      final _todaySales = _result.map((json) => SalesModel.fromJson(json)).toList();
      return _todaySales;
    } else {
      throw 'Sales of Today is Empty!';
    }
  }

  //========== Get All Sales By Query ==========
  Future<List<SalesModel>> getSalesByInvoiceSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final res = await db.rawQuery('''select * from $tableSales where ${SalesFields.invoiceNumber} LIKE "%$pattern%"''');

    List<SalesModel> list = res.isNotEmpty ? res.map((c) => SalesModel.fromJson(c)).toList() : [];

    return list;
  }

  //========== Get Sales By Customer Id ==========
  Future<List<SalesModel>> getSalesByCustomerId(String id) async {
    final db = await dbInstance.database;
    final res = await db.query(
      tableSales,
      where: '${SalesFields.customerId} = ?',
      whereArgs: [id],
    );

    List<SalesModel> list = res.isNotEmpty ? res.map((c) => SalesModel.fromJson(c)).toList() : [];

    return list;
  }

// //========== Update Sales When get Returned ==========
//   Future<void> updateReturnedSale(
//       {required int saleId,
//       required int salesReturnId,
//       required String salesReturnInvoice}) async {
//     final db = await dbInstance.database;
//     final _sale = await db
//         .query(tableSales, where: '${SalesFields.id} =? ', whereArgs: [saleId]);
//     final updatedSale = SalesModel.fromJson(_sale.first).copyWith(
//         salesReturnId: salesReturnId,
//         salesReturnInvoiceNumber: salesReturnInvoice);

//     final id = await db.update(tableSales, updatedSale.toJson(),
//         where: '${SalesFields.id} = ? ', whereArgs: [saleId]);

//     log('Sale Updated Successfully! $id');
//   }

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
