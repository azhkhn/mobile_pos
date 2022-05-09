import 'dart:async';
import 'dart:developer';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/purchase/purchase_items_model.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_items_modal.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_modal.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/sales_return/sales_return_items_model.dart';
import 'package:shop_ez/model/sales_return/sales_return_model.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/model/unit/unit_model.dart';
import 'package:shop_ez/model/auth/user_model.dart';
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
        version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    log('==================== UPGRADING DATABSE TO NEW VERSION ====================');

    // const idAuto = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // const textType = 'TEXT NOT NULL';
    // const textNull = 'TEXT';
    // const intNull = 'INTEGER';
    // const intType = 'INTEGER NOT NULL';

    // await db.execute("DROP TABLE IF EXISTS $tableSales");
    // await db.execute("DROP TABLE IF EXISTS $tableSalesItems");
    // await db.execute("DROP TABLE IF EXISTS $tableTransactions");
    // await db.execute("DROP TABLE IF EXISTS $tableSalesReturn");
    // await db.execute("DROP TABLE IF EXISTS $tableSalesReturnItems");
    // await db.execute("DROP TABLE IF EXISTS $tablePurchaseReturn");
    // await db.execute("DROP TABLE IF EXISTS $tablePurchaseItemsReturn");

    //**
    //    await db.execute(
    //    "ALTER TABLE TABLE_NAME ADD COLUMN COLUMN_NAME $textType DEFAULT ''");
    //
    //    await db.rawQuery('DROP TABLE IF EXISTS TABLE_NAME');
    //
    // */
    // if (oldVersion == 6) {
    //   await db.execute(
    //       "ALTER TABLE TABLE_NAME RENAME COLUMN COLUMN_NAME TO NEW_COLUMN_NAME");
    // }
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
    const intType = 'INTEGER NOT NULL';
    const textNull = 'TEXT';
    const intNull = 'INTEGER';

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
      ${ItemMasterFields.vatId} $textType,
      ${ItemMasterFields.vatRate} $textType,
      ${ItemMasterFields.productVAT} $textType,
      ${ItemMasterFields.unit} $textType,
      ${ItemMasterFields.expiryDate} $textType,
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
      ${VatFields.rate} $intType,
      ${VatFields.type} $textType)''');

//========== Table Expense ==========
    await db.execute('''CREATE TABLE $tableExpenseCategory (
      ${ExpenseCategoryFields.id} $idAuto,
      ${ExpenseCategoryFields.expense} $textType)''');

//========== Table Sales ==========
    await db.execute('''CREATE TABLE $tableSales (
      ${SalesFields.id} $idAuto,
      ${SalesFields.invoiceNumber} $textType,
      ${SalesFields.salesNote} $textType,
      ${SalesFields.dateTime} $textType,
      ${SalesFields.customerId} $intType, 
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

//========== Table Sales Items ==========
    await db.execute('''CREATE TABLE $tableSalesItems (
      ${SalesItemsFields.id} $idAuto,
      ${SalesItemsFields.salesId} $intType,
      ${SalesItemsFields.productId} $textType,
      ${SalesItemsFields.productType} $textType,
      ${SalesItemsFields.productName} $textType, 
      ${SalesItemsFields.category} $textType,
      ${SalesItemsFields.productCode} $textType,
      ${SalesItemsFields.unitPrice} $textType,
      ${SalesItemsFields.productCost} $textType,
      ${SalesItemsFields.quantity} $textType,
      ${SalesItemsFields.subTotal} $textType,
      ${SalesItemsFields.vatId} $textType,
      ${SalesItemsFields.vatTotal} $textType,
      ${SalesItemsFields.unitCode} $textType,
      ${SalesItemsFields.netUnitPrice} $textType,
      ${SalesItemsFields.vatPercentage} $textType)''');

//========== Table Transactions ==========
    await db.execute('''CREATE TABLE $tableTransactions (
      ${TransactionsField.id} $idAuto,
      ${TransactionsField.category} $textType,
      ${TransactionsField.transactionType} $textType,
      ${TransactionsField.dateTime} $textType,
      ${TransactionsField.amount} $textType,
      ${TransactionsField.status} $textType,
      ${TransactionsField.description} $textType,
      ${TransactionsField.salesId} $intNull,
      ${TransactionsField.purchaseId} $intNull,
      ${TransactionsField.salesReturnId} $intNull,
      ${TransactionsField.purchaseReturnId} $intNull)''');

//========== Table Purchase ==========
    await db.execute('''CREATE TABLE $tablePurchase (
      ${PurchaseFields.id} $idAuto,
      ${PurchaseFields.invoiceNumber} $textType,
      ${PurchaseFields.referenceNumber} $textType,
      ${PurchaseFields.purchaseNote} $textType,
      ${PurchaseFields.dateTime} $textType,
      ${PurchaseFields.supplierId} $intType, 
      ${PurchaseFields.supplierName} $textType,
      ${PurchaseFields.billerName} $textType,
      ${PurchaseFields.totalItems} $textType,
      ${PurchaseFields.vatAmount} $textType,
      ${PurchaseFields.subTotal} $textType,
      ${PurchaseFields.discount} $textType,
      ${PurchaseFields.grantTotal} $textType,
      ${PurchaseFields.paid} $textType,
      ${PurchaseFields.balance} $textType,
      ${PurchaseFields.paymentType} $textType,
      ${PurchaseFields.purchaseStatus} $textType,
      ${PurchaseFields.paymentStatus} $textType,
      ${PurchaseFields.createdBy} $textType)''');

//========== Table Purchase Items ==========
    await db.execute('''CREATE TABLE $tablePurchaseItems (
      ${PurchaseItemsFields.id} $idAuto,
      ${PurchaseItemsFields.purchaseId} $intType,
      ${PurchaseItemsFields.productId} $textType,
      ${PurchaseItemsFields.productType} $textType,
      ${PurchaseItemsFields.productName} $textType, 
      ${PurchaseItemsFields.category} $textType,
      ${PurchaseItemsFields.productCode} $textType,
      ${PurchaseItemsFields.unitPrice} $textType,
      ${PurchaseItemsFields.productCost} $textType,
      ${PurchaseItemsFields.quantity} $textType,
      ${PurchaseItemsFields.subTotal} $textType,
      ${PurchaseItemsFields.vatId} $textType,
      ${PurchaseItemsFields.vatTotal} $textType,
      ${PurchaseItemsFields.unitCode} $textType,
      ${PurchaseItemsFields.netUnitPrice} $textType,
      ${PurchaseItemsFields.vatPercentage} $textType)''');

// ========== Table Sales Return ==========
    await db.execute('''CREATE TABLE $tableSalesReturn (
      ${SalesReturnFields.id} $idAuto,
      ${SalesReturnFields.saleId} $intNull,
      ${SalesReturnFields.invoiceNumber} $textType,
      ${SalesReturnFields.originalInvoiceNumber} $textType,
      ${SalesReturnFields.salesNote} $textType,
      ${SalesReturnFields.dateTime} $textType,
      ${SalesReturnFields.customerId} $intType,
      ${SalesReturnFields.customerName} $textType,
      ${SalesReturnFields.billerName} $textType,
      ${SalesReturnFields.totalItems} $textType,
      ${SalesReturnFields.vatAmount} $textType,
      ${SalesReturnFields.subTotal} $textType,
      ${SalesReturnFields.discount} $textType,
      ${SalesReturnFields.grantTotal} $textType,
      ${SalesReturnFields.paid} $textType,
      ${SalesReturnFields.balance} $textType,
      ${SalesReturnFields.paymentType} $textType,
      ${SalesReturnFields.salesStatus} $textType,
      ${SalesReturnFields.paymentStatus} $textType,
      ${SalesReturnFields.createdBy} $textType)''');

//========== Table Sales Return Items ==========
    await db.execute('''CREATE TABLE $tableSalesReturnItems (
      ${SalesReturnItemsFields.id} $idAuto,
      ${SalesReturnItemsFields.saleId} $intNull,
      ${SalesReturnItemsFields.saleReturnId} $intType,
      ${SalesReturnItemsFields.originalInvoiceNumber} $textType,
      ${SalesReturnItemsFields.productId} $textType,
      ${SalesReturnItemsFields.productType} $textType,
      ${SalesReturnItemsFields.productName} $textType,
      ${SalesReturnItemsFields.category} $textType,
      ${SalesReturnItemsFields.productCode} $textType,
      ${SalesReturnItemsFields.unitPrice} $textType,
      ${SalesReturnItemsFields.productCost} $textType,
      ${SalesReturnItemsFields.quantity} $textType,
      ${SalesReturnItemsFields.subTotal} $textType,
      ${SalesReturnItemsFields.vatId} $textType,
      ${SalesReturnItemsFields.vatTotal} $textType,
      ${SalesReturnItemsFields.unitCode} $textType,
      ${SalesReturnItemsFields.netUnitPrice} $textType,
      ${SalesReturnItemsFields.vatPercentage} $textType)''');

// ========== Table Purchase Return ==========
    await db.execute('''CREATE TABLE $tablePurchaseReturn (
      ${PurchaseReturnFields.id} $idAuto,
      ${PurchaseReturnFields.purchaseId} $intNull,
      ${PurchaseReturnFields.invoiceNumber} $textType,
      ${PurchaseReturnFields.referenceNumber} $textType,
      ${PurchaseReturnFields.originalInvoiceNumber} $textNull,
      ${PurchaseReturnFields.purchaseNote} $textType,
      ${PurchaseReturnFields.dateTime} $textType,
      ${PurchaseReturnFields.supplierId} $intType,
      ${PurchaseReturnFields.supplierName} $textType,
      ${PurchaseReturnFields.billerName} $textType,
      ${PurchaseReturnFields.totalItems} $textType,
      ${PurchaseReturnFields.vatAmount} $textType,
      ${PurchaseReturnFields.subTotal} $textType,
      ${PurchaseReturnFields.discount} $textType,
      ${PurchaseReturnFields.grantTotal} $textType,
      ${PurchaseReturnFields.paid} $textType,
      ${PurchaseReturnFields.balance} $textType,
      ${PurchaseReturnFields.paymentType} $textType,
      ${PurchaseReturnFields.purchaseStatus} $textType,
      ${PurchaseReturnFields.paymentStatus} $textType,
      ${PurchaseReturnFields.createdBy} $textType)''');

//========== Table Purchase Return Items ==========
    await db.execute('''CREATE TABLE $tablePurchaseItemsReturn (
      ${PurchaseItemsReturnFields.id} $idAuto,
      ${PurchaseItemsReturnFields.purchaseId} $intNull,
      ${PurchaseItemsReturnFields.purchaseReturnId} $intType,
      ${PurchaseItemsReturnFields.originalInvoiceNumber} $textNull,
      ${PurchaseItemsReturnFields.productId} $textType,
      ${PurchaseItemsReturnFields.productType} $textType,
      ${PurchaseItemsReturnFields.productName} $textType,
      ${PurchaseItemsReturnFields.category} $textType,
      ${PurchaseItemsReturnFields.productCode} $textType,
      ${PurchaseItemsReturnFields.unitPrice} $textType,
      ${PurchaseItemsReturnFields.productCost} $textType,
      ${PurchaseItemsReturnFields.quantity} $textType,
      ${PurchaseItemsReturnFields.subTotal} $textType,
      ${PurchaseItemsReturnFields.vatId} $textType,
      ${PurchaseItemsReturnFields.vatTotal} $textType,
      ${PurchaseItemsReturnFields.unitCode} $textType,
      ${PurchaseItemsReturnFields.netUnitPrice} $textType,
      ${PurchaseItemsReturnFields.vatPercentage} $textType)''');
  }
}
