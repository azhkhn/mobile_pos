import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'dart:developer' show log;

class CustomerDatabase {
  static final CustomerDatabase instance = CustomerDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  CustomerDatabase._init();

//========== Create Customer ==========
  Future<int> createCustomer(CustomerModel _customerModel) async {
    final db = await dbInstance.database;

    // final _company = await db.rawQuery(
    //     "select * from $tableCustomer where ${CustomerFields.company} = '${_customerModel.company}'");

    if (_customerModel.vatNumber!.toString().isNotEmpty) {
      final _vatNumber = await db.rawQuery(
          "select * from $tableCustomer where ${CustomerFields.vatNumber} = '${_customerModel.vatNumber}'");

      if (_vatNumber.isNotEmpty) {
        throw 'VAT Number already exist!';
      } else {
        final id = await db.insert(tableCustomer, _customerModel.toJson());
        log('Customer id = $id');
        return id;
      }
    } else {
      final id = await db.insert(tableCustomer, _customerModel.toJson());
      log('Customer id = $id');
      return id;
    }
  }

  //========== Get All Customers ==========
  Future<List<CustomerModel>> getAllCustomers() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableCustomer);
    log('Customers === $_result');
    final _customers =
        _result.map((json) => CustomerModel.fromJson(json)).toList();
    // db.delete(tableCustomer);
    return _customers;
  }

  //========== Get Customer By Id ==========
  Future<CustomerModel> getCustomerById(int customerId) async {
    final db = await dbInstance.database;
    final _result = await db.query(
      tableCustomer,
      where: '${CustomerFields.id} = ?',
      whereArgs: [customerId],
    );
    log('Customer === $_result');
    final _customers =
        _result.map((json) => CustomerModel.fromJson(json)).toList();

    // await db.update(tableCustomer,
    //     _customers.first.copyWith(vatNumber: '437596584523654').toJson(),
    //     where: '${CustomerFields.id} = ? ', whereArgs: [customerId]);
    return _customers.first;
  }

  //========== Get All Customers By Query ==========
  Future<List<CustomerModel>> getCustomerSuggestions(String pattern) async {
    final db = await dbInstance.database;
    final res = await db.rawQuery(
        "select * from $tableCustomer where ${CustomerFields.customer} LIKE '%$pattern%'");

    List<CustomerModel> list = res.isNotEmpty
        ? res.map((c) => CustomerModel.fromJson(c)).toList()
        : [];

    return list;
  }
}
