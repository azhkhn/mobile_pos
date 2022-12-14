// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/unit/unit_model.dart';

class UnitDatabase {
  static final UnitDatabase instance = UnitDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  UnitDatabase._init();

  //========== Value Notifiers ==========
  static final ValueNotifier<List<UnitModel>> unitNotifiers = ValueNotifier([]);

//========== Create Unit ==========
  Future<void> createUnit(UnitModel _unitModel) async {
    final db = await dbInstance.database;
    final unit = await db.rawQuery('''select * from $tableUnit where ${UnitFields.unit} = "${_unitModel.unit}" COLLATE NOCASE''');
    if (unit.isNotEmpty) {
      log('Unit already exist!');
      throw Exception('Unit Already Exist!');
    } else {
      log('Unit Created!');
      final id = await db.insert(tableUnit, _unitModel.toJson());
      unitNotifiers.value.add(_unitModel.copyWith(id: id));
      unitNotifiers.notifyListeners();
      log('Unit Id == $id');
    }
  }

  //========== Update Unit ==========
  Future<void> updateUnit({required UnitModel unit, required String unitName}) async {
    final db = await dbInstance.database;

    final _result = await db.rawQuery('''select * from $tableUnit where ${UnitFields.unit} = "$unitName" COLLATE NOCASE''');

    if (_result.isNotEmpty && unit.unit != unitName) throw 'Unit Name Already Exist!';

    final updatedUnit = unit.copyWith(unit: unitName);
    await db.update(
      tableUnit,
      updatedUnit.toJson(),
      where: '${UnitFields.id} = ?',
      whereArgs: [unit.id],
    );
    log('Unit ${unit.id} Updated Successfully');
    final index = unitNotifiers.value.indexOf(unit);
    unitNotifiers.value[index] = updatedUnit;
    unitNotifiers.notifyListeners();
  }

  //========== Delete Unit ==========
  Future<void> deleteUnit(int id) async {
    final db = await dbInstance.database;
    await db.delete(tableUnit, where: '${UnitFields.id} = ? ', whereArgs: [id]);
    log('Unit $id Deleted Successfully!');
    unitNotifiers.value.removeWhere((categories) => categories.id == id);
    unitNotifiers.notifyListeners();
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
