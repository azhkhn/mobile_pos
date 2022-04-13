import 'dart:async';
import 'dart:developer';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/model/unit/unit_model.dart';
import 'package:shop_ez/model/user/user_model.dart';
import 'package:shop_ez/model/vat/vat_model.dart';
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
    return await openDatabase(path,
        version: 3, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    log('==================== UPGRADING DATABSE TO NEW VERSION ====================');
    const idAuto = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.rawQuery('DROP TABLE $tableSales');

    //========== Table Sales ==========
    await db.execute('''CREATE TABLE $tableSales (
      ${SalesFields.id} $idAuto,
      ${SalesFields.salesId} $textType,
      ${SalesFields.salesNote} $textType,
      ${SalesFields.dateTime} $textType,
      ${SalesFields.cusomerId} $textType, 
      ${SalesFields.customerName} $textType,
      ${SalesFields.billerName} $textType,
      ${SalesFields.totalItems} $textType,
      ${SalesFields.vatAmount} $textType,
      ${SalesFields.subTotal} $textType,
      ${SalesFields.discount} $textType,
      ${SalesFields.grantTotal} $textType,
      ${SalesFields.paid} $textType,
      ${SalesFields.balance} $textType,
      ${SalesFields.paymentType} $textType,
      ${SalesFields.salesStatus} $textType,
      ${SalesFields.paymentStatus} $textType,
      ${SalesFields.createdBy} $textType)''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future _createDB(Database db, int version) async {
    const idAuto = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const idNotNull = 'INTEGER NOT NULL';
    const idLogin = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

//========== Table Users ==========
    await db.execute('''CREATE TABLE $tableUser (
      ${UserFields.id} $idAuto,
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
      ${CategoryFields.id} $idAuto,
      ${CategoryFields.category} $textType)''');

//========== Table Sub-Category ==========
    await db.execute('''CREATE TABLE $tableSubCategory (
      ${SubCategoryFields.id} $idAuto, 
      ${SubCategoryFields.category} $textType, 
      ${SubCategoryFields.subCategory} $textType)''');

//========== Table Brand ==========
    await db.execute('''CREATE TABLE $tableBrand (
      ${BrandFields.id} $idAuto,
      ${BrandFields.brand} $textType)''');

//========== Table Unit ==========
    await db.execute('''CREATE TABLE $tableUnit (
      ${UnitFields.id} $idAuto,
      ${UnitFields.unit} $textType)''');

//========== Table Supplier ==========
    await db.execute('''CREATE TABLE $tableSupplier (
      ${SupplierFields.id} $idAuto, 
      ${SupplierFields.company} $textType,
      ${SupplierFields.companyArabic} $textType, 
      ${SupplierFields.supplier} $textType,
      ${SupplierFields.supplierArabic} $textType,
      ${SupplierFields.vatNumber} $textType,
      ${SupplierFields.email} $textType,
      ${SupplierFields.address} $textType,
      ${SupplierFields.addressArabic} $textType,
      ${SupplierFields.city} $textType,
      ${SupplierFields.cityArabic} $textType,
      ${SupplierFields.state} $textType,
      ${SupplierFields.stateArabic} $textType,
      ${SupplierFields.country} $textType,
      ${SupplierFields.countryArabic} $textType,
      ${SupplierFields.poBox} $textType)''');

//========== Table Customer ==========
    await db.execute('''CREATE TABLE $tableCustomer (
      ${CustomerFields.id} $idAuto,
      ${CustomerFields.customerType} $textType,
      ${CustomerFields.company} $textType,
      ${CustomerFields.companyArabic} $textType, 
      ${CustomerFields.customer} $textType,
      ${CustomerFields.customerArabic} $textType,
      ${CustomerFields.vatNumber} $textType,
      ${CustomerFields.email} $textType,
      ${CustomerFields.address} $textType,
      ${CustomerFields.addressArabic} $textType,
      ${CustomerFields.city} $textType,
      ${CustomerFields.cityArabic} $textType,
      ${CustomerFields.state} $textType,
      ${CustomerFields.stateArabic} $textType,
      ${CustomerFields.country} $textType,
      ${CustomerFields.countryArabic} $textType,
      ${CustomerFields.poBox} $textType)''');

//========== Table Item-Master ==========
    await db.execute('''CREATE TABLE $tableItemMaster (
      ${ItemMasterFields.id} $idAuto,
      ${ItemMasterFields.productType} $textType,
      ${ItemMasterFields.itemName} $textType,
      ${ItemMasterFields.itemNameArabic} $textType, 
      ${ItemMasterFields.itemCode} $textType,
      ${ItemMasterFields.itemCategory} $textType,
      ${ItemMasterFields.itemSubCategory} $textType,
      ${ItemMasterFields.itemBrand} $textType,
      ${ItemMasterFields.itemCost} $textType,
      ${ItemMasterFields.sellingPrice} $textType,
      ${ItemMasterFields.secondarySellingPrice} $textType,
      ${ItemMasterFields.productVAT} $textType,
      ${ItemMasterFields.unit} $textType,
      ${ItemMasterFields.openingStock} $textType,
      ${ItemMasterFields.vatMethod} $textType,
      ${ItemMasterFields.alertQuantity} $textType,
      ${ItemMasterFields.itemImage} $textType)''');

//========== Table Expense ==========
    await db.execute('''CREATE TABLE $tableExpense (
      ${ExpenseFields.id} $idAuto,
      ${ExpenseFields.expenseCategory} $textType,
      ${ExpenseFields.expenseTitle} $textType,
      ${ExpenseFields.paidBy} $textType,
      ${ExpenseFields.date} $textType,
      ${ExpenseFields.note} $textType,
      ${ExpenseFields.voucherNumber} $textType,
      ${ExpenseFields.documents} $textType)''');

//========== Table Business Profile ==========
    await db.execute('''CREATE TABLE $tableBusinessProfile (
      ${BusinessProfileFields.id} $idNotNull,
      ${BusinessProfileFields.business} $textType,
      ${BusinessProfileFields.businessArabic} $textType,
      ${BusinessProfileFields.billerName} $textType,
      ${BusinessProfileFields.address} $textType, 
      ${BusinessProfileFields.addressArabic} $textType,
      ${BusinessProfileFields.city} $textType,
      ${BusinessProfileFields.cityArabic} $textType,
      ${BusinessProfileFields.state} $textType,
      ${BusinessProfileFields.stateArabic} $textType,
      ${BusinessProfileFields.country} $textType,
      ${BusinessProfileFields.countryArabic} $textType,
      ${BusinessProfileFields.vatNumber} $textType,
      ${BusinessProfileFields.phoneNumber} $textType,
      ${BusinessProfileFields.email} $textType,
      ${BusinessProfileFields.logo} $textType)''');

//========== Table VAT ==========
    await db.execute('''CREATE TABLE $tableVat (
      ${VatFields.id} $idAuto, 
      ${VatFields.name} $textType,
      ${VatFields.code} $textType,
      ${VatFields.rate} $textType,
      ${VatFields.type} $textType)''');

//========== Table Expense ==========
    await db.execute('''CREATE TABLE $tableExpenseCategory (
      ${ExpenseCategoryFields.id} $idAuto,
      ${ExpenseCategoryFields.expense} $textType)''');

//========== Table Sales ==========
    await db.execute('''CREATE TABLE $tableSales (
      ${SalesFields.id} $idAuto,
      ${SalesFields.salesId} $textType,
      ${SalesFields.salesNote} $textType,
      ${SalesFields.dateTime} $textType,
      ${SalesFields.cusomerId} $textType, 
      ${SalesFields.customerName} $textType,
      ${SalesFields.billerName} $textType,
      ${SalesFields.totalItems} $textType,
      ${SalesFields.vatAmount} $textType,
      ${SalesFields.subTotal} $textType,
      ${SalesFields.discount} $textType,
      ${SalesFields.grantTotal} $textType,
      ${SalesFields.paid} $textType,
      ${SalesFields.balance} $textType,
      ${SalesFields.paymentType} $textType,
      ${SalesFields.salesStatus} $textType,
      ${SalesFields.paymentStatus} $textType,
      ${SalesFields.createdBy} $textType)''');
  }
}
