import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'dart:developer' show log;

class CustomerDatabase {
  static final CustomerDatabase instance = CustomerDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  CustomerDatabase._init();

//========== Create Supplier ==========
  Future<void> createCustomer(CustomerModel _customerModel) async {
    final db = await dbInstance.database;

    final _company = await db.rawQuery(
        "select * from $tableCustomer where ${CustomerFields.company} = '${_customerModel.company}'");

    if (_company.isNotEmpty) {
      throw 'Company Already Exist!';
    } else {
      if (_customerModel.vatNumber!.toString().isNotEmpty) {
        final _vatNumber = await db.rawQuery(
            "select * from $tableCustomer where ${CustomerFields.vatNumber} = '${_customerModel.vatNumber}'");

        if (_vatNumber.isNotEmpty) {
          throw 'VAT Number already exist!';
        } else {
          final id = await db.insert(tableCustomer, _customerModel.toJson());
          log('Customer id = $id');
        }
      } else {
        final id = await db.insert(tableCustomer, _customerModel.toJson());
        log('Customer id = $id');
      }
    }
  }

  //========== Get All Customers ==========
  Future<List<CustomerModel>> getAllSuppliers() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableCustomer);
    log('Customers === $_result');
    final _customers =
        _result.map((json) => CustomerModel.fromJson(json)).toList();
    // db.delete(tableCustomer);
    return _customers;
  }
}
