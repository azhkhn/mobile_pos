import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';

class CustomerDatabase {
  static final CustomerDatabase instance = CustomerDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  CustomerDatabase._init();

//========== Create Supplier ==========
  Future<void> createCustomer(CustomerModel _customerModel) async {
    final db = await dbInstance.database;
    final _customer = await db.rawQuery(
        "select * from $tableCustomer where ${CustomerFields.vatNumber} = '${_customerModel.vatNumber}'");
  }
}
