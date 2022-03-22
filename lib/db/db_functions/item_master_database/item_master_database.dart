import 'package:shop_ez/db/database.dart';
import 'dart:developer' show log;

import 'package:shop_ez/model/item_master/item_master_model.dart';

class ItemMasterDatabase {
  static final ItemMasterDatabase instance = ItemMasterDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  ItemMasterDatabase._init();

//========== Create Item ==========
  Future<void> createItem(ItemMasterModel _itemMasterModel) async {
    final db = await dbInstance.database;

    final _item = await db.rawQuery(
        "select * from $tableItemMaster where ${ItemMasterFields.itemName} = '${_itemMasterModel.itemName}'");

    if (_item.isNotEmpty) {
      throw 'Item Already Exist!';
    } else {
      final id = await db.insert(tableItemMaster, _itemMasterModel.toJson());
      log('Item id = $id');
    }
  }

  //========== Get All Items ==========
  Future<List<ItemMasterModel>> getAllItems() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableItemMaster);
    log('Items === $_result');
    // db.delete(tableItemMaster);
    final _items =
        _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }
}
