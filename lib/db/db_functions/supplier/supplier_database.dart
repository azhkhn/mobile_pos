import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';

class SupplierDatabase {
  static final SupplierDatabase instance = SupplierDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SupplierDatabase._init();

//========== Create Supplier ==========
  Future<SupplierModel> createSupplier(SupplierModel _supplierModel) async {
    final db = await dbInstance.database;
    final supplier = await db.rawQuery('''SELECT * FROM $tableSupplier WHERE ${SupplierFields.supplierName} = "${_supplierModel.supplierName}"''');
    if (supplier.isNotEmpty) {
      log('Supplier Already Exist!');
      throw Exception('Company Already Exist!');
    } else {
      log('Supplier Created!');
      final id = await db.insert(tableSupplier, _supplierModel.toJson());
      log('Supplier ($id) updated successfully');

      return _supplierModel.copyWith(id: id);
    }
  }

  //========== Update Supplier ==========
  Future<SupplierModel> updateSupplier(SupplierModel supplierModel) async {
    final db = await dbInstance.database;
    final _result = await db.update(
      tableSupplier,
      supplierModel.toJson(),
      where: '${SupplierFields.id} = ?',
      whereArgs: [supplierModel.id],
    );
    log('Supplier ($_result) updated successfully');
    return supplierModel;
  }

//========== Get All Suppliers ==========
  Future<List<SupplierModel>> getAllSuppliers() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSupplier);
    log('Suppliers === $_result');
    final _suppliers = _result.map((json) => SupplierModel.fromJson(json)).toList();
    return _suppliers;
  }

  //========== Get Supplier By Id ==========
  Future<SupplierModel> getSupplierById(int supplierId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableSupplier,
      where: '${SupplierFields.id} = ?',
      whereArgs: [supplierId],
    );
    log('Supplier ($supplierId) === $_result');
    final _suppliers = SupplierModel.fromJson(_result.first);
    return _suppliers;
  }

  //========== Get All Supplier By Query ==========
  Future<List<SupplierModel>> getSupplierSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final List<Map<String, Object?>> res;

    if (pattern.isNotEmpty) {
      res = await db.rawQuery('''select * from $tableSupplier where ${SupplierFields.supplierName} LIKE "%$pattern%" limit 20''');
    } else {
      res = await db.query(tableSupplier, limit: 10);
    }

    List<SupplierModel> list = res.isNotEmpty ? res.map((c) => SupplierModel.fromJson(c)).toList() : [];

    return list;
  }
}
