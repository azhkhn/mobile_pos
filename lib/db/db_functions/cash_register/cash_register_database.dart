import 'dart:developer' show log;

import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/db/database.dart';
import 'package:mobile_pos/model/cash_register/cash_register_model.dart';
import 'package:sqflite/sqflite.dart';

class CashRegisterDatabase {
  static final CashRegisterDatabase instance = CashRegisterDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  CashRegisterDatabase._init();

//========== Create CashRegister ==========
  Future<void> createCashRegister(CashRegisterModel _cashModel) async {
    final db = await dbInstance.database;
    final id = await db.insert(tableCashRegister, _cashModel.toJson());

    UserUtils.instance.cashRegisterModel = _cashModel.copyWith(id: id);
    log('CashRegister ($id) Created!');
  }

  //========== Get Latest CashRegister ==========
  Future<CashRegisterModel?> getLatestRegister() async {
    final Database db = await dbInstance.database;
    final _result = await db.query(tableCashRegister, orderBy: '${CashRegisterFields.id} DESC', limit: 1);
    log('Fetching latest CashRegister details..');
    if (_result.isNotEmpty) {
      final CashRegisterModel _cashRegisters = CashRegisterModel.fromJson(_result.first);
      return _cashRegisters;
    } else {
      return null;
    }
  }

//========== Get All CashRegisters ==========
  Future<List<CashRegisterModel>> getAllCashRegisters() async {
    final Database db = await dbInstance.database;
    final _result = await db.query(tableCashRegister);
    log('Fetching CashRegisters from Database..');
    final _cashRegisters = _result.map((json) => CashRegisterModel.fromJson(json)).toList();
    // db.delete(tableCashRegister);
    return _cashRegisters;
  }
}
