import 'dart:developer' show log;

import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/cash_register/cash_register_model.dart';
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
  Future<CashRegisterModel?> getLastRegister() async {
    final Database db = await dbInstance.database;
    final _result = await db.query(tableCashRegister, orderBy: '${CashRegisterFields.id} DESC', limit: 1);
    log('CashRegister === $_result');
    if (_result.isNotEmpty) {
      final _cashRegisters = CashRegisterModel.fromJson(_result.first);
      return _cashRegisters;
    } else {
      return null;
    }
  }

//========== Get All CashRegisters ==========
  Future<List<CashRegisterModel>> getAllCashRegisters() async {
    final Database db = await dbInstance.database;
    final _result = await db.query(tableCashRegister);
    log('CashRegisters === $_result');
    final _cashRegisters = _result.map((json) => CashRegisterModel.fromJson(json)).toList();
    // db.delete(tableCashRegister);
    return _cashRegisters;
  }
}
