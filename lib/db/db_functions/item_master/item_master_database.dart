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
    final _itemCode = await db.rawQuery(
        "select * from $tableItemMaster where ${ItemMasterFields.itemCode} = '${_itemMasterModel.itemCode}'");

    if (_item.isNotEmpty) {
      throw 'Item Already Exist!';
    } else if (_itemCode.isNotEmpty) {
      throw 'ItemCode Already Exist!';
    } else {
      final id = await db.insert(tableItemMaster, _itemMasterModel.toJson());
      log('Item id = $id');
    }
  }

  //========== Get Products By Brand ==========
  Future<List<ItemMasterModel>> getProductByBrand(String brand) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.itemBrand} = ?',
      whereArgs: [brand],
    );
    log('Products by $brand === $_result');

    final _items =
        _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get Products By Category ==========
  Future<List<ItemMasterModel>> getProductByCategory(String category) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.itemCategory} = ?',
      whereArgs: [category],
    );
    log('Products by $category === $_result');
    final _items =
        _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get Products By Sub-Category ==========
  Future<List<ItemMasterModel>> getProductBySubCategory(
      String subCategory) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.itemSubCategory} = ?',
      whereArgs: [subCategory],
    );
    log('Products by $subCategory === $_result');
    final _items =
        _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get Product By Id ==========
  Future<List<ItemMasterModel>> getProductById(int id) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.id} = ?',
      whereArgs: [id],
    );
    log('Products by $id === $_result');
    final _items =
        _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get All Products By Query ==========
  Future<List<ItemMasterModel>> getProductSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final res = await db.rawQuery(
        "select * from $tableItemMaster where ${ItemMasterFields.itemName} LIKE '%$pattern%' OR ${ItemMasterFields.itemCode} LIKE '%$pattern%'");

    List<ItemMasterModel> list = res.isNotEmpty
        ? res.map((c) => ItemMasterModel.fromJson(c)).toList()
        : [];

    return list;
  }

  //========== Increase Item Quantity ==========
  Future<void> additionItemQty(
      ItemMasterModel itemMasterModel, num purchasedQty) async {
    final db = await dbInstance.database;
    final num currentQty = num.parse(itemMasterModel.openingStock);
    log('Current Quantity == $currentQty');
    final num newQty = currentQty + purchasedQty;
    log('New Item Quantity == $newQty');
    final newModel = itemMasterModel.copyWith(openingStock: '$newQty');
    await db.update(
      tableItemMaster,
      newModel.toJson(),
      where: '${ItemMasterFields.id} = ?',
      whereArgs: [newModel.id],
    );
    log('Item Quantity Updated!');
  }

  //========== Decrease Item Quantity ==========
  Future<void> subtractItemQty(
      ItemMasterModel itemMasterModel, num soldQty) async {
    final db = await dbInstance.database;
    final num currentQty = num.parse(itemMasterModel.openingStock);
    log('Current Quantity == $currentQty');
    final num newQty = currentQty - soldQty;
    log('New Item Quantity == $newQty');
    final newModel = itemMasterModel.copyWith(openingStock: '$newQty');
    await db.update(
      tableItemMaster,
      newModel.toJson(),
      where: '${ItemMasterFields.id} = ?',
      whereArgs: [newModel.id],
    );
    log('Item Quantity Updated!');
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
