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
      throw 'Item name already exist';
    } else if (_itemCode.isNotEmpty) {
      throw 'Item code already exist';
    } else {
      final id = await db.insert(tableItemMaster, _itemMasterModel.toJson());
      log('Item id = $id');
    }
  }

  //========== Update Product ==========
  Future<ItemMasterModel> updateProduct(ItemMasterModel itemMasterModel) async {
    final db = await dbInstance.database;
    final _id = await db.update(
      tableItemMaster,
      itemMasterModel.toJson(),
      where: '${ItemMasterFields.id} = ?',
      whereArgs: [itemMasterModel.id],
    );
    log('Products ($_id) updated successfully');
    return itemMasterModel;
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
    final List<Map<String, Object?>> res;
    if (pattern.isNotEmpty) {
      res = await db.rawQuery(
          '''select * from $tableItemMaster where ${ItemMasterFields.itemName} LIKE "%$pattern%" OR ${ItemMasterFields.itemCode} LIKE "%$pattern%" limit 20''');
    } else {
      res = await db.query(tableItemMaster, limit: 10);
    }

    List<ItemMasterModel> list = res.isNotEmpty ? res.map((c) => ItemMasterModel.fromJson(c)).toList() : [];

    return list;
  }

  //========== Increase Item Quantity ==========
  Future<void> additionItemQty({required int itemId, required num purchasedQty}) async {
    final db = await dbInstance.database;

    final _result = await db.query(tableItemMaster, where: '${ItemMasterFields.id} = ?', whereArgs: [itemId]);
    final _item = ItemMasterModel.fromJson(_result.first);

    final num currentQty = num.parse(_item.openingStock);
    log('Current Quantity == $currentQty');
    final num newQty = currentQty + purchasedQty;
    log('New Item Quantity == $newQty');
    final newModel = _item.copyWith(openingStock: '$newQty');

    await db.update(
      tableItemMaster,
      newModel.toJson(),
      where: '${ItemMasterFields.id} = ?',
      whereArgs: [newModel.id],
    );
    log('Item Quantity Updated!');
  }

  //========== Decrease Item Quantity ==========
  Future<void> subtractItemQty({required int itemId, required num soldQty}) async {
    final db = await dbInstance.database;

    final _result = await db.query(tableItemMaster, where: '${ItemMasterFields.id} = ?', whereArgs: [itemId]);
    final _item = ItemMasterModel.fromJson(_result.first);

    final num currentQty = num.parse(_item.openingStock);
    log('Current Quantity == $currentQty');
    final num newQty = currentQty - soldQty;
    log('New Item Quantity == $newQty');

    final newModel = _item.copyWith(openingStock: '$newQty');

    await db.update(
      tableItemMaster,
      newModel.toJson(),
      where: '${ItemMasterFields.id} = ?',
      whereArgs: [newModel.id],
    );
    log('Item Quantity Updated!');
  }

  //========== Update Item Cost and Quantity ==========
  Future<void> updateItemCostAndQty({required ItemMasterModel itemMaster, required num purchasedQty}) async {
    final db = await dbInstance.database;

    final num currentQty = num.parse(itemMaster.openingStock);
    log('Current Quantity == $currentQty');
    final num newQty = currentQty + purchasedQty;
    log('New Item Quantity == $newQty');
    final newModel = itemMaster.copyWith(openingStock: '$newQty');

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
    log('Items from Database  === $_result');
    // db.delete(tableItemMaster);
    final _items = _result.map((json) => ItemMasterModel.fromJson(json)).toList();
    return _items;
  }
}
