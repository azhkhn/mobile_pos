import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/biller/biller_model.dart';

class BillerDatabase {
  static final BillerDatabase instance = BillerDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  BillerDatabase._init();

//========== Create Biller ==========
  Future<void> createBiller(BillerModel _billerModel) async {
    final db = await dbInstance.database;

    final _company = await db.rawQuery(
        "select * from $tableBiller where ${BillerFields.company} = '${_billerModel.company}'");

    if (_company.isNotEmpty) {
      throw 'Company Already Exist!';
    } else {
      if (_billerModel.vatNumber.toString().isNotEmpty) {
        final _vatNumber = await db.rawQuery(
            "select * from $tableBiller where ${BillerFields.vatNumber} = '${_billerModel.vatNumber}'");

        if (_vatNumber.isNotEmpty) {
          throw 'VAT Number already exist!';
        } else {
          final id = await db.insert(tableBiller, _billerModel.toJson());
          log('Biller id = $id');
        }
      } else {
        final id = await db.insert(tableBiller, _billerModel.toJson());
        log('Biller id = $id');
      }
    }
  }

//========== Get All Billers ==========
  Future<BillerModel?> getAllBillers() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableBiller);
    // db.delete(tableBiller);
    log('Billers == $_result');
    if (_result.isNotEmpty) {
      final _billers =
          _result.map((json) => BillerModel.fromJson(json)).toList();
      return _billers.first;
    } else {
      return null;
    }
  }
}
