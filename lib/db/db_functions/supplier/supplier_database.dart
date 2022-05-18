import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';

class SupplierDatabase {
  static final SupplierDatabase instance = SupplierDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  SupplierDatabase._init();

//========== Create Supplier ==========
  Future<int> createSupplier(SupplierModel _supplierModel) async {
    final db = await dbInstance.database;
    final supplier = await db.rawQuery(
        '''SELECT * FROM $tableSupplier WHERE ${SupplierFields.company} = "${_supplierModel.company}"''');
    if (supplier.isNotEmpty) {
      log('Company Already Exist!');
      throw Exception('Company Already Exist!');
    } else {
      log('Supplier Created!');
      final id = await db.insert(tableSupplier, _supplierModel.toJson());
      log('Supplier id == $id');
      return id;
    }
  }

//========== Get All Suppliers ==========
  Future<List<SupplierModel>> getAllSuppliers() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableSupplier);
    log('Suppliers === $_result');
    final _suppliers =
        _result.map((json) => SupplierModel.fromJson(json)).toList();
    return _suppliers;
  }

  //========== Get Supplier By Id ==========
  Future<SupplierModel> getSupplierById(int customerId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableSupplier,
      where: '${SupplierFields.id} = ?',
      whereArgs: [customerId],
    );
    log('Supplier === $_result');
    final _customers =
        _result.map((json) => SupplierModel.fromJson(json)).toList();
    return _customers.first;
  }

  //========== Get All Supplier By Query ==========
  Future<List<SupplierModel>> getSupplierSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final res = await db.rawQuery(
        '''select * from $tableSupplier where ${SupplierFields.supplier} LIKE "%$pattern%"''');

    List<SupplierModel> list = res.isNotEmpty
        ? res.map((c) => SupplierModel.fromJson(c)).toList()
        : [];

    return list;
  }
}
