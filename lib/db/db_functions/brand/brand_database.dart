// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/brand/brand_model.dart';

class BrandDatabase {
  static final BrandDatabase instance = BrandDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  BrandDatabase._init();

//========== Value Notifiers ==========
  static final ValueNotifier<List<BrandModel>> brandNotifier =
      ValueNotifier([]);

//========== Create Brand ==========
  Future<void> createBrand(BrandModel _brandModel) async {
    final db = await dbInstance.database;
    final brand = await db.rawQuery(
        '''select * from $tableBrand where ${BrandFields.brand} = "${_brandModel.brand}" COLLATE NOCASE''');
    if (brand.isNotEmpty) {
      log('Brand already exist!');
      throw Exception('Brand Already Exist!');
    } else {
      log('Brand Created!');
      final id = await db.insert(tableBrand, _brandModel.toJson());

      brandNotifier.value.add(_brandModel.copyWith(id: id));
      brandNotifier.notifyListeners();
      log('Brand Id == $id');
    }
  }

//========== Update Brand ==========
  Future<void> updateBrand(
      {required BrandModel brand, required String brandName}) async {
    final db = await dbInstance.database;
    final updatedBrand = brand.copyWith(brand: brandName);
    await db.update(
      tableBrand,
      updatedBrand.toJson(),
      where: '${BrandFields.id} = ?',
      whereArgs: [brand.id],
    );
    log('Brand ${brand.id} Updated Successfully');
    final index = brandNotifier.value.indexOf(brand);
    brandNotifier.value[index] = updatedBrand;
    brandNotifier.notifyListeners();
  }

//========== Delete Brand ==========
  Future<void> deleteBrand(int id) async {
    final db = await dbInstance.database;
    await db
        .delete(tableBrand, where: '${BrandFields.id} = ? ', whereArgs: [id]);
    log('Brand $id Deleted Successfully!');
    brandNotifier.value.removeWhere((brands) => brands.id == id);
    brandNotifier.notifyListeners();
  }

//========== Get All Brands ==========
  Future<List<BrandModel>> getAllBrands() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableBrand);
    log('Brands === $_result');
    final _brands = _result.map((json) => BrandModel.fromJson(json)).toList();
    // db.delete(tableBrand);
    return _brands;
  }
}
