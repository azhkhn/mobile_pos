import 'dart:async';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';
import 'package:shop_ez/model/unit/unit_model.dart';
import 'package:shop_ez/model/user/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EzDatabase {
  static final EzDatabase instance = EzDatabase._init();
  static Database? _database;
  EzDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    const filePath = 'user.db';
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const idLogin = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

//========== Table Users ==========
    await db.execute('''CREATE TABLE $tableUser (
  ${UserFields.id} $idType,
  ${UserFields.shopName} $textType,
  ${UserFields.countryName} $textType,
  ${UserFields.shopCategory} $textType,
  ${UserFields.mobileNumber} $textType,
  ${UserFields.email} $textType,
  ${UserFields.password} $textType)''');

//========== Table Login ==========
    await db.execute('''CREATE TABLE $tableLogin (
  ${UserFields.id} $idLogin,
  ${UserFields.shopName} $textType,
  ${UserFields.countryName} $textType,
  ${UserFields.shopCategory} $textType,
  ${UserFields.mobileNumber} $textType,
  ${UserFields.email} $textType,
  ${UserFields.password} $textType)''');

//========== Table Category ==========
    await db.execute('''CREATE TABLE $tableCategory (
  ${CategoryFields.id} $idType,
  ${CategoryFields.category} $textType)''');

//========== Table Sub-Category ==========
    await db.execute('''CREATE TABLE $tableSubCategory (
   ${SubCategoryFields.id} $idType, 
   ${SubCategoryFields.category} $textType, 
   ${SubCategoryFields.subCategory} $textType)''');

//========== Table Brand ==========
    await db.execute('''CREATE TABLE $tableBrand (
  ${BrandFields.id} $idType,
  ${BrandFields.brand} $textType)''');

//========== Table Unit ==========
    await db.execute('''CREATE TABLE $tableUnit (
  ${UnitFields.id} $idType,
  ${UnitFields.unit} $textType)''');
  }
}
