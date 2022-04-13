import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/vat/vat_model.dart';

class VatDatabase {
  static final VatDatabase instance = VatDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  VatDatabase._init();

//========== Create VAT ==========
  Future<void> createVAT(VatModel _vatModel) async {
    final db = await dbInstance.database;
    final _vat = await db.rawQuery(
        "SELECT * FROM $tableVat WHERE ${VatFields.rate} = '${_vatModel.rate}' AND ${VatFields.type} = '${_vatModel.type}'");
    if (_vat.isNotEmpty) {
      log('VAT Already Exist!');
      throw 'VAT Already Exist!';
    } else {
      log('VAT Created!');
      final id = await db.insert(tableVat, _vatModel.toJson());
      log('VAT id == $id');
    }
  }

//========== Get All VATs ==========
  Future<List<VatModel>> getAllVats() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableVat);
    log('VATs == $_result');
    final _vats = _result.map((json) => VatModel.fromJson(json)).toList();
    return _vats;
  }

//========== Delete VAT ==========
  Future<void> deleteVAT(int id) async {
    final db = await dbInstance.database;
    final _result = await db
        .delete(tableVat, where: '${VatFields.id} = ?', whereArgs: [id]);
    log('VAT $id Deleted == $_result');
  }
}
