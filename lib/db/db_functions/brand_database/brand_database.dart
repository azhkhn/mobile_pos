import 'dart:developer' show log;
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/brand/brand_model.dart';

class BrandDatabase {
  static final BrandDatabase instance = BrandDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  BrandDatabase._init();

//========== Create Brand ==========
  Future<void> createBrand(BrandModel _brandModel) async {
    final db = await dbInstance.database;
    final brand = await db.rawQuery(
        "select * from $tableBrand where ${BrandFields.brand} = '${_brandModel.brand}'");
    if (brand.isNotEmpty) {
      log('Brand already exist!');
      throw Exception('Brand Already Exist!');
    } else {
      log('Brand Created!');
      final id = await db.insert(tableBrand, _brandModel.toJson());
      log('Brand Id == $id');
    }
  }

//========== Get All Brands ==========
  Future<List<BrandModel>> getAllBrands() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableBrand);
    log('Brands === $_result');
    final _brands = _result.map((json) => BrandModel.fromJson(json)).toList();
    // db.delete(tableBrand);
    return _brands;
  }
}
