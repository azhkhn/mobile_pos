import 'dart:developer' show log;
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/unit/unit_model.dart';

class UnitDatabase {
  static final UnitDatabase instance = UnitDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  UnitDatabase._init();

//========== Create Unit ==========
  Future<void> createUnit(UnitModel _unitModel) async {
    final db = await dbInstance.database;
    final unit = await db.rawQuery(
        "select * from $tableUnit where ${UnitFields.unit} = '${_unitModel.unit}'");
    if (unit.isNotEmpty) {
      log('Unit already exist!');
      throw Exception('Unit Already Exist!');
    } else {
      log('Unit Created!');
      final id = await db.insert(tableUnit, _unitModel.toJson());
      log('Unit Id == $id');
    }
  }

//========== Get All Units ==========
  Future<List<UnitModel>> getAllUnits() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableUnit);
    log('Units === $_result');
    final _units = _result.map((json) => UnitModel.fromJson(json)).toList();
    // db.delete(tableUnit);
    return _units;
  }
}
