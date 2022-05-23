// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/vat/vat_model.dart';

class VatDatabase {
  static final VatDatabase instance = VatDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  VatDatabase._init();

  //========== Value Notifiers ==========
  static final ValueNotifier<List<VatModel>> vatNotifer = ValueNotifier([]);

//========== Create VAT ==========
  Future<void> createVAT(VatModel _vatModel) async {
    final db = await dbInstance.database;
    final _vat = await db.rawQuery(
        '''SELECT * FROM $tableVat WHERE ${VatFields.rate} = "${_vatModel.rate}" AND ${VatFields.type} = "${_vatModel.type}" OR ${VatFields.name} = "${_vatModel.name}"''');
    if (_vat.isNotEmpty) {
      log('VAT Already Exist!');
      throw 'VAT Already Exist!';
    } else {
      log('VAT Created!');
      final id = await db.insert(tableVat, _vatModel.toJson());
      vatNotifer.value.add(_vatModel.copyWith(id: id));
      vatNotifer.notifyListeners();
      log('VAT id == $id');
    }
  }

//========== Get All VATs ==========
  Future<List<VatModel>> getAllVats() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableVat);
    log('VATs == $_result');
    // await db.delete(tableVat);
    final _vats = _result.map((json) => VatModel.fromJson(json)).toList();
    return _vats;
  }

  // //========== Get VAT by name ==========
  // Future<VatModel> getVatByName(String name) async {
  //   final db = await dbInstance.database;
  //   final _result = await db.query(tableVat, where: '${VatFields.name} = ?', whereArgs: [name]);
  //   log('VAT of $name == $_result');
  //   final _vats = _result.map((json) => VatModel.fromJson(json)).toList();
  //   return _vats.first;
  // }

  //========== Get VAT by Id ==========
  Future<VatModel> getVatById(int id) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableVat, where: '${VatFields.id} = ?', whereArgs: [id]);
    log('VAT of $id == $_result');
    final _vats = _result.map((json) => VatModel.fromJson(json)).toList();
    return _vats.first;
  }

  //========== Update VAT ==========
  Future<void> updateVAT({required VatModel vat, required String vatName, required int vatRate}) async {
    final db = await dbInstance.database;
    final updatedVat = vat.copyWith(name: vatName, rate: vatRate);
    await db.update(
      tableVat,
      updatedVat.toJson(),
      where: '${VatFields.id} = ?',
      whereArgs: [vat.id],
    );
    log('VAT ${vat.id} Updated Successfully');
    final index = vatNotifer.value.indexOf(vat);
    vatNotifer.value[index] = updatedVat;
    vatNotifer.notifyListeners();
  }

//========== Delete VAT ==========
  Future<void> deleteVAT(int id) async {
    final db = await dbInstance.database;
    final _result = await db.delete(tableVat, where: '${VatFields.id} = ?', whereArgs: [id]);
    vatNotifer.value.removeWhere((vats) => vats.id == id);
    vatNotifer.notifyListeners();
    log('VAT $id Deleted == $_result');
  }
}
