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

    final _item = await db.rawQuery('''select * from $tableItemMaster where ${ItemMasterFields.itemName} = "${_itemMasterModel.itemName}"''');
    final _itemCode = await db.rawQuery('''select * from $tableItemMaster where ${ItemMasterFields.itemCode} = "${_itemMasterModel.itemCode}"''');

    if (_item.isNotEmpty) {
      throw 'Item Already Exist!';
    } else if (_itemCode.isNotEmpty) {
      throw 'ItemCode Already Exist!';
    } else {
      final id = await db.insert(tableItemMaster, _itemMasterModel.toJson());
      log('Item id = $id');
    }
  }

  //========== Get Products By Brand Id ==========
  Future<List<ItemMasterModel>> getProductByBrandId(int brandId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.itemBrandId} = ?',
      whereArgs: [brandId],
    );
    log('Products by $brandId === $_result');

    final _items = _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get Products By Category Id ==========
  Future<List<ItemMasterModel>> getProductByCategoryId(int categoryId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.itemCategoryId} = ?',
      whereArgs: [categoryId],
    );
    log('Products by $categoryId === $_result');
    final _items = _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get Products By Sub-Category Id ==========
  Future<List<ItemMasterModel>> getProductBySubCategoryId(int subCategoryId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.itemSubCategoryId} = ?',
      whereArgs: [subCategoryId],
    );
    log('Products by $subCategoryId === $_result');
    final _items = _result.map((json) => ItemMasterModel.fromJson(json)).toList();
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
    final _items = _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get Product By ItemCode ==========
  Future<List<ItemMasterModel>> getProductByItemCode(String itemCode) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableItemMaster,
      where: '${ItemMasterFields.itemCode} = ?',
      whereArgs: [itemCode],
    );
    log('Product by $itemCode === $_result');
    final _items = _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }

  //========== Get All Products By Query ==========
  Future<List<ItemMasterModel>> getProductSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final res = await db.rawQuery(
        '''select * from $tableItemMaster where ${ItemMasterFields.itemName} LIKE "%$pattern%" OR ${ItemMasterFields.itemCode} LIKE "%$pattern%"''');

    List<ItemMasterModel> list = res.isNotEmpty ? res.map((c) => ItemMasterModel.fromJson(c)).toList() : [];

    return list;
  }

  //========== Increase Item Quantity ==========
  Future<void> additionItemQty(ItemMasterModel itemMasterModel, num purchasedQty) async {
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
  Future<void> subtractItemQty(ItemMasterModel itemMasterModel, num soldQty) async {
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
    final _items = _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }
}
