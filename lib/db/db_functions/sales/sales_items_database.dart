import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

class SalesItemsDatabase {
  static final SalesItemsDatabase instance = SalesItemsDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SalesItemsDatabase._init();

//==================== Create Sales Items ====================
  Future<void> createSalesItems(SalesItemsModel _salesItemsModel) async {
    final db = await dbInstance.database;

    final _sales = await db.query(tableSales);

    final _recentSale = SalesModel.fromJson(_sales.last);

    final int? _recentSaleId = _recentSale.id;
    log('Recent Sales id == $_recentSaleId');

    final _newSaleItem = _salesItemsModel.copyWith(salesId: _recentSaleId);

    final id = await db.insert(tableSalesItems, _newSaleItem.toJson());
    log('Sales Items id == $id');
    log('Sales Items Created!');
  }

//========== Get All Sales Items ==========
  Future<List<SalesItemsModel?>?> getAllSalesItems() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSalesItems);
    // db.delete(tableSalesItems);
    log('Sales Items == $_result');
    if (_result.isNotEmpty) {
      final _salesItems =
          _result.map((json) => SalesItemsModel.fromJson(json)).toList();
      return _salesItems;
    } else {
      throw 'Sales Items is Empty!';
    }
  }
}
