import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:shop_ez/model/auth/user_model.dart';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/cash_register/cash_register_model.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/model/group/group_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/permission/permission_model.dart';
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
import 'package:shop_ez/model/vat/vat_model.dart';
import 'package:sqflite/sqflite.dart';

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
    return await openDatabase(path, version: 11, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    log('==================== UPGRADING DATABSE TO NEW VERSION ====================');

    const idAuto = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textNotNull = 'TEXT NOT NULL';
    // const textNull = 'TEXT';
    // const intNull = 'INTEGER';
    // const idLogin = 'INTEGER NOT NULL';
    const intNotNull = 'INTEGER NOT NULL';

//     await db.execute('DROP TABLE IF EXISTS $tableUser');
//     await db.execute('DROP TABLE IF EXISTS $tableLogin');
//     await db.execute('DROP TABLE IF EXISTS $tableGroup');
//     await db.execute('DROP TABLE IF EXISTS $tablePermission');

// //========== Table Users ==========
//     await db.execute('''CREATE TABLE $tableUser (
//       ${UserFields.id} $idAuto,
//       ${UserFields.groupId} $intNotNull,
//       ${UserFields.shopName} $textNotNull,
//       ${UserFields.countryName} $textNotNull,
//       ${UserFields.shopCategory} $textNotNull,
//       ${UserFields.name} $textNull,
//       ${UserFields.nameArabic} $textNull,
//       ${UserFields.address} $textNull,
//       ${UserFields.mobileNumber} $textNotNull,
//       ${UserFields.email} $textNull,
//       ${UserFields.username} $textNotNull,
//       ${UserFields.password} $textNotNull,
//       ${UserFields.status} $intNotNull,
//       ${UserFields.document} $textNull)''');

// //========== Table Login ==========
//     await db.execute('''CREATE TABLE $tableLogin (
//       ${UserFields.id} $idLogin,
//       ${UserFields.groupId} $intNotNull,
//       ${UserFields.shopName} $textNotNull,
//       ${UserFields.countryName} $textNotNull,
//       ${UserFields.shopCategory} $textNotNull,
//       ${UserFields.name} $textNull,
//       ${UserFields.nameArabic} $textNull,
//       ${UserFields.address} $textNull,
//       ${UserFields.mobileNumber} $textNotNull,
//       ${UserFields.email} $textNull,
//       ${UserFields.username} $textNotNull,
//       ${UserFields.password} $textNotNull,
//       ${UserFields.status} $intNotNull,
//       ${UserFields.document} $textNull)''');

// //========== Table Group ==========
//     await db.execute('''CREATE TABLE $tableGroup (
//       ${GroupFields.id} $idAuto,
//       ${GroupFields.name} $textNotNull,
//       ${GroupFields.description} $textNotNull)''');

// //========== Table Permission ==========
//     await db.execute('''CREATE TABLE $tablePermission (
//       ${PermissionFields.id} $idAuto,
//       ${PermissionFields.groupId} $intNotNull,
//       ${PermissionFields.user} $textNotNull,
//       ${PermissionFields.sale} $textNotNull,
//       ${PermissionFields.purchase} $textNotNull,
//       ${PermissionFields.returns} $textNotNull,
//       ${PermissionFields.products} $textNotNull,
//       ${PermissionFields.customer} $textNotNull,
//       ${PermissionFields.supplier} $textNotNull)''');

//     await db.execute("DROP TABLE IF EXISTS $tableSales");
//     await db.execute("DROP TABLE IF EXISTS $tableSalesItems");
//     await db.execute("DROP TABLE IF EXISTS $tablePurchase");
//     await db.execute("DROP TABLE IF EXISTS $tablePurchaseItems");
//     await db.execute("DROP TABLE IF EXISTS $tableTransactions");
//     await db.execute('drop table if exists $tableExpense');
//     await db.execute("DROP TABLE IF EXISTS $tableSalesReturn");
//     await db.execute("DROP TABLE IF EXISTS $tableSalesReturnItems");
//     await db.execute("DROP TABLE IF EXISTS $tablePurchaseReturn");
//     await db.execute("DROP TABLE IF EXISTS $tablePurchaseItemsReturn");

// //========== Table Sales ==========
//     await db.execute('''CREATE TABLE $tableSales (
//       ${SalesFields.id} $idAuto,
//       ${SalesFields.invoiceNumber} $textNotNull,
//       ${SalesFields.returnAmount} $textNull,
//       ${SalesFields.salesNote} $textNotNull,
//       ${SalesFields.dateTime} $textNotNull,
//       ${SalesFields.customerId} $intNotNull,
//       ${SalesFields.customerName} $textNotNull,
//       ${SalesFields.billerName} $textNotNull,
//       ${SalesFields.totalItems} $textNotNull,
//       ${SalesFields.vatAmount} $textNotNull,
//       ${SalesFields.subTotal} $textNotNull,
//       ${SalesFields.discount} $textNotNull,
//       ${SalesFields.grantTotal} $textNotNull,
//       ${SalesFields.paid} $textNotNull,
//       ${SalesFields.balance} $textNotNull,
//       ${SalesFields.paymentType} $textNotNull,
//       ${SalesFields.salesStatus} $textNotNull,
//       ${SalesFields.paymentStatus} $textNotNull,
//       ${SalesFields.createdBy} $textNotNull)''');

// //========== Table Sales Items ==========
//     await db.execute('''CREATE TABLE $tableSalesItems (
//       ${SalesItemsFields.id} $idAuto,
//       ${SalesItemsFields.saleId} $intNotNull,
//       ${SalesItemsFields.productId} $intNotNull,
//       ${SalesItemsFields.productType} $textNotNull,
//       ${SalesItemsFields.productName} $textNotNull,
//       ${SalesItemsFields.categoryId} $intNotNull,
//       ${SalesItemsFields.productCode} $textNotNull,
//       ${SalesItemsFields.unitPrice} $textNotNull,
//       ${SalesItemsFields.productCost} $textNotNull,
//       ${SalesItemsFields.quantity} $textNotNull,
//       ${SalesItemsFields.subTotal} $textNotNull,
//       ${SalesItemsFields.vatMethod} $textNotNull,
//       ${SalesItemsFields.vatId} $intNotNull,
//       ${SalesItemsFields.vatTotal} $textNotNull,
//       ${SalesItemsFields.unitCode} $textNotNull,
//       ${SalesItemsFields.netUnitPrice} $textNotNull,
//       ${SalesItemsFields.vatPercentage} $textNotNull,
//       ${SalesItemsFields.vatRate} $intNotNull)''');

// //========== Table Transactions ==========
//     await db.execute('''CREATE TABLE $tableTransactions (
//       ${TransactionsField.id} $idAuto,
//       ${TransactionsField.category} $textNotNull,
//       ${TransactionsField.transactionType} $textNotNull,
//       ${TransactionsField.dateTime} $textNotNull,
//       ${TransactionsField.amount} $textNotNull,
//       ${TransactionsField.status} $textNotNull,
//       ${TransactionsField.description} $textNull,
//       ${TransactionsField.salesId} $intNull,
//       ${TransactionsField.purchaseId} $intNull,
//       ${TransactionsField.salesReturnId} $intNull,
//       ${TransactionsField.purchaseReturnId} $intNull,
//       ${TransactionsField.customerId} $intNull,
//       ${TransactionsField.supplierId} $intNull,
//       ${TransactionsField.payBy} $textNull)''');

    // //========== Table Expense ==========
    // await db.execute('''CREATE TABLE $tableExpense (
    //   ${ExpenseFields.id} $idAuto,
    //   ${ExpenseFields.expenseCategory} $textNotNull,
    //   ${ExpenseFields.expenseTitle} $textNotNull,
    //   ${ExpenseFields.amount} $textNotNull,
    //   ${ExpenseFields.vatId} $intNull,
    //   ${ExpenseFields.vatMethod} $textNull,
    //   ${ExpenseFields.vatAmount} $textNull,
    //   ${ExpenseFields.dateTime} $textNotNull,
    //   ${ExpenseFields.date} $textNotNull,
    //   ${ExpenseFields.note} $textNull,
    //   ${ExpenseFields.voucherNumber} $textNull,
    //   ${ExpenseFields.payBy} $textNotNull,
    //   ${ExpenseFields.documents} $textNull)''');

// //========== Table Purchase ==========
//     await db.execute('''CREATE TABLE $tablePurchase (
//       ${PurchaseFields.id} $idAuto,
//       ${PurchaseFields.invoiceNumber} $textNotNull,
//       ${PurchaseFields.referenceNumber} $textNotNull,
//       ${PurchaseFields.purchaseNote} $textNotNull,
//       ${PurchaseFields.dateTime} $textNotNull,
//       ${PurchaseFields.supplierId} $intNotNull,
//       ${PurchaseFields.supplierName} $textNotNull,
//       ${PurchaseFields.billerName} $textNotNull,
//       ${PurchaseFields.totalItems} $textNotNull,
//       ${PurchaseFields.vatAmount} $textNotNull,
//       ${PurchaseFields.subTotal} $textNotNull,
//       ${PurchaseFields.discount} $textNotNull,
//       ${PurchaseFields.grantTotal} $textNotNull,
//       ${PurchaseFields.paid} $textNotNull,
//       ${PurchaseFields.balance} $textNotNull,
//       ${SalesFields.returnAmount} $textNull,
//       ${PurchaseFields.paymentType} $textNotNull,
//       ${PurchaseFields.purchaseStatus} $textNotNull,
//       ${PurchaseFields.paymentStatus} $textNotNull,
//       ${PurchaseFields.createdBy} $textNotNull)''');

// //========== Table Purchase Items ==========
//     await db.execute('''CREATE TABLE $tablePurchaseItems (
//       ${PurchaseItemsFields.id} $idAuto,
//       ${PurchaseItemsFields.purchaseId} $intNotNull,
//       ${PurchaseItemsFields.productId} $intNotNull,
//       ${PurchaseItemsFields.productType} $textNotNull,
//       ${PurchaseItemsFields.productName} $textNotNull,
//       ${PurchaseItemsFields.categoryId} $intNotNull,
//       ${PurchaseItemsFields.productCode} $textNotNull,
//       ${PurchaseItemsFields.unitPrice} $textNotNull,
//       ${PurchaseItemsFields.productCost} $textNotNull,
//       ${PurchaseItemsFields.quantity} $textNotNull,
//       ${PurchaseItemsFields.subTotal} $textNotNull,
//       ${PurchaseItemsFields.vatId} $intNotNull,
//       ${PurchaseItemsFields.vatMethod} $textNotNull,
//       ${PurchaseItemsFields.vatRate} $intNotNull,
//       ${PurchaseItemsFields.vatTotal} $textNotNull,
//       ${PurchaseItemsFields.unitCode} $textNotNull,
//       ${PurchaseItemsFields.netUnitPrice} $textNotNull,
//       ${PurchaseItemsFields.vatPercentage} $textNotNull)''');

// // ========== Table Sales Return ==========
//     await db.execute('''CREATE TABLE $tableSalesReturn (
//       ${SalesReturnFields.id} $idAuto,
//       ${SalesReturnFields.saleId} $intNull,
//       ${SalesReturnFields.invoiceNumber} $textNotNull,
//       ${SalesReturnFields.originalInvoiceNumber} $textNotNull,
//       ${SalesReturnFields.salesNote} $textNotNull,
//       ${SalesReturnFields.dateTime} $textNotNull,
//       ${SalesReturnFields.customerId} $intNotNull,
//       ${SalesReturnFields.customerName} $textNotNull,
//       ${SalesReturnFields.billerName} $textNotNull,
//       ${SalesReturnFields.totalItems} $textNotNull,
//       ${SalesReturnFields.vatAmount} $textNotNull,
//       ${SalesReturnFields.subTotal} $textNotNull,
//       ${SalesReturnFields.discount} $textNotNull,
//       ${SalesReturnFields.grantTotal} $textNotNull,
//       ${SalesReturnFields.paid} $textNotNull,
//       ${SalesReturnFields.balance} $textNotNull,
//       ${SalesReturnFields.paymentType} $textNotNull,
//       ${SalesReturnFields.salesStatus} $textNotNull,
//       ${SalesReturnFields.paymentStatus} $textNotNull,
//       ${SalesReturnFields.createdBy} $textNotNull)''');

// //========== Table Sales Return Items ==========
//     await db.execute('''CREATE TABLE $tableSalesReturnItems (
//       ${SalesReturnItemsFields.id} $idAuto,
//       ${SalesReturnItemsFields.saleId} $intNotNull,
//       ${SalesReturnItemsFields.saleReturnId} $intNotNull,
//       ${SalesReturnItemsFields.originalInvoiceNumber} $textNotNull,
//       ${SalesReturnItemsFields.productId} $intNotNull,
//       ${SalesReturnItemsFields.productType} $textNotNull,
//       ${SalesReturnItemsFields.productName} $textNotNull,
//       ${SalesReturnItemsFields.categoryId} $intNotNull,
//       ${SalesReturnItemsFields.productCode} $textNotNull,
//       ${SalesReturnItemsFields.unitPrice} $textNotNull,
//       ${SalesReturnItemsFields.productCost} $textNotNull,
//       ${SalesReturnItemsFields.quantity} $textNotNull,
//       ${SalesReturnItemsFields.subTotal} $textNotNull,
//       ${SalesReturnItemsFields.vatMethod} $textNotNull,
//       ${SalesReturnItemsFields.vatId} $intNotNull,
//       ${SalesReturnItemsFields.vatRate} $intNotNull,
//       ${SalesReturnItemsFields.vatTotal} $textNotNull,
//       ${SalesReturnItemsFields.unitCode} $textNotNull,
//       ${SalesReturnItemsFields.netUnitPrice} $textNotNull,
//       ${SalesReturnItemsFields.vatPercentage} $textNotNull)''');

// // ========== Table Purchase Return ==========
//     await db.execute('''CREATE TABLE $tablePurchaseReturn (
//       ${PurchaseReturnFields.id} $idAuto,
//       ${PurchaseReturnFields.purchaseId} $intNotNull,
//       ${PurchaseReturnFields.invoiceNumber} $textNotNull,
//       ${PurchaseReturnFields.referenceNumber} $textNotNull,
//       ${PurchaseReturnFields.originalInvoiceNumber} $textNull,
//       ${PurchaseReturnFields.purchaseNote} $textNotNull,
//       ${PurchaseReturnFields.dateTime} $textNotNull,
//       ${PurchaseReturnFields.supplierId} $intNotNull,
//       ${PurchaseReturnFields.supplierName} $textNotNull,
//       ${PurchaseReturnFields.billerName} $textNotNull,
//       ${PurchaseReturnFields.totalItems} $textNotNull,
//       ${PurchaseReturnFields.vatAmount} $textNotNull,
//       ${PurchaseReturnFields.subTotal} $textNotNull,
//       ${PurchaseReturnFields.discount} $textNotNull,
//       ${PurchaseReturnFields.grantTotal} $textNotNull,
//       ${PurchaseReturnFields.paid} $textNotNull,
//       ${PurchaseReturnFields.balance} $textNotNull,
//       ${PurchaseReturnFields.paymentType} $textNotNull,
//       ${PurchaseReturnFields.purchaseStatus} $textNotNull,
//       ${PurchaseReturnFields.paymentStatus} $textNotNull,
//       ${PurchaseReturnFields.createdBy} $textNotNull)''');

// //========== Table Purchase Return Items ==========
//     await db.execute('''CREATE TABLE $tablePurchaseItemsReturn (
//       ${PurchaseReturnItemsFields.id} $idAuto,
//       ${PurchaseReturnItemsFields.purchaseId} $intNotNull,
//       ${PurchaseReturnItemsFields.purchaseReturnId} $intNotNull,
//       ${PurchaseReturnItemsFields.originalInvoiceNumber} $textNull,
//       ${PurchaseReturnItemsFields.productId} $intNotNull,
//       ${PurchaseReturnItemsFields.productType} $textNotNull,
//       ${PurchaseReturnItemsFields.productName} $textNotNull,
//       ${PurchaseReturnItemsFields.categoryId} $intNotNull,
//       ${PurchaseReturnItemsFields.productCode} $textNotNull,
//       ${PurchaseReturnItemsFields.unitPrice} $textNotNull,
//       ${PurchaseReturnItemsFields.productCost} $textNotNull,
//       ${PurchaseReturnItemsFields.quantity} $textNotNull,
//       ${PurchaseReturnItemsFields.subTotal} $textNotNull,
//       ${PurchaseReturnItemsFields.vatId} $intNotNull,
//       ${PurchaseReturnItemsFields.vatTotal} $textNotNull,
//       ${PurchaseReturnItemsFields.unitCode} $textNotNull,
//       ${PurchaseReturnItemsFields.netUnitPrice} $textNotNull,
//       ${PurchaseReturnItemsFields.vatPercentage} $textNotNull)''');

    //================================================================================================================
    //================================================================================================================
    //================================================================================================================
    //================================================================================================================
    //================================================================================================================

    //========== Table Cash Register ==========
    await db.execute('''CREATE TABLE $tableCashRegister (
      ${CashRegisterFields.id} $idAuto, 
      ${CashRegisterFields.dateTime} $textNotNull,
      ${CashRegisterFields.amount} $textNotNull,
      ${CashRegisterFields.userId} $intNotNull,
      ${CashRegisterFields.action} $textNotNull)''');

    // final _sales = await db.query(tableSales, where: '${SalesFields.paymentType} = ?', whereArgs: ['Card']);

    // final List<SalesModel> sales = _sales.map((json) => SalesModel.fromJson(json)).toList();

    // for (SalesModel sale in sales) {
    //   final newSale = sale.copyWith(paymentType: 'Bank');
    //   await db.update(tableSales, newSale.toJson(), where: '${SalesFields.id} = ?', whereArgs: [sale.id]);
    // }

    //**
    //    await db.execute(
    //    "ALTER TABLE TABLE_NAME ADD COLUMN COLUMN_NAME $textNotNull DEFAULT ''");
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
    const textNotNull = 'TEXT NOT NULL';
    const intNotNull = 'INTEGER NOT NULL';
    const textNull = 'TEXT';
    const intNull = 'INTEGER';

//========== Table Users ==========
    await db.execute('''CREATE TABLE $tableUser (
      ${UserFields.id} $idAuto,
      ${UserFields.groupId} $intNotNull,
      ${UserFields.shopName} $textNotNull,
      ${UserFields.countryName} $textNotNull,
      ${UserFields.shopCategory} $textNotNull,
      ${UserFields.name} $textNull,
      ${UserFields.nameArabic} $textNull,
      ${UserFields.address} $textNull,
      ${UserFields.mobileNumber} $textNotNull,
      ${UserFields.email} $textNull,
      ${UserFields.username} $textNotNull,
      ${UserFields.password} $textNotNull,
      ${UserFields.status} $intNotNull,
      ${UserFields.document} $textNull)''');

//========== Table Login ==========
    await db.execute('''CREATE TABLE $tableLogin (
      ${UserFields.id} $idLogin,
      ${UserFields.groupId} $intNotNull,
      ${UserFields.shopName} $textNotNull,
      ${UserFields.countryName} $textNotNull,
      ${UserFields.shopCategory} $textNotNull,
      ${UserFields.name} $textNull,
      ${UserFields.nameArabic} $textNull,
      ${UserFields.address} $textNull,
      ${UserFields.mobileNumber} $textNotNull,
      ${UserFields.email} $textNull,
      ${UserFields.username} $textNotNull,
      ${UserFields.password} $textNotNull,
      ${UserFields.status} $intNotNull,
      ${UserFields.document} $textNull)''');

//========== Table Group ==========
    await db.execute('''CREATE TABLE $tableGroup (
      ${GroupFields.id} $idAuto,
      ${GroupFields.name} $textNotNull,
      ${GroupFields.description} $textNotNull)''');

    //========== Table Permission ==========
    await db.execute('''CREATE TABLE $tablePermission (
      ${PermissionFields.id} $idAuto,
      ${PermissionFields.groupId} $intNotNull,
      ${PermissionFields.user} $textNotNull,
      ${PermissionFields.sale} $textNotNull,
      ${PermissionFields.purchase} $textNotNull,
      ${PermissionFields.returns} $textNotNull,
      ${PermissionFields.products} $textNotNull,
      ${PermissionFields.customer} $textNotNull,
      ${PermissionFields.supplier} $textNotNull)''');

//========== Table Category ==========
    await db.execute('''CREATE TABLE $tableCategory (
      ${CategoryFields.id} $idAuto,
      ${CategoryFields.category} $textNotNull)''');

//========== Table Sub-Category ==========
    await db.execute('''CREATE TABLE $tableSubCategory (
      ${SubCategoryFields.id} $idAuto, 
      ${SubCategoryFields.category} $textNotNull,
      ${SubCategoryFields.categoryId} $intNotNull,
      ${SubCategoryFields.subCategory} $textNotNull)''');

//========== Table Brand ==========
    await db.execute('''CREATE TABLE $tableBrand (
      ${BrandFields.id} $idAuto,
      ${BrandFields.brand} $textNotNull)''');

//========== Table Unit ==========
    await db.execute('''CREATE TABLE $tableUnit (
      ${UnitFields.id} $idAuto,
      ${UnitFields.unit} $textNotNull)''');

//========== Table Supplier ==========
    await db.execute('''CREATE TABLE $tableSupplier (
      ${SupplierFields.id} $idAuto, 
      ${SupplierFields.supplierName} $textNotNull,
      ${SupplierFields.supplierNameArabic} $textNotNull, 
      ${SupplierFields.contactName} $textNotNull,
      ${SupplierFields.contactNumber} $textNotNull,
      ${SupplierFields.vatNumber} $textNotNull,
      ${SupplierFields.email} $textNotNull,
      ${SupplierFields.address} $textNotNull,
      ${SupplierFields.addressArabic} $textNotNull,
      ${SupplierFields.city} $textNotNull,
      ${SupplierFields.cityArabic} $textNotNull,
      ${SupplierFields.state} $textNotNull,
      ${SupplierFields.stateArabic} $textNotNull,
      ${SupplierFields.country} $textNotNull,
      ${SupplierFields.countryArabic} $textNotNull,
      ${SupplierFields.poBox} $textNotNull)''');

//========== Table Customer ==========
    await db.execute('''CREATE TABLE $tableCustomer (
      ${CustomerFields.id} $idAuto,
      ${CustomerFields.customerType} $textNotNull,
      ${CustomerFields.company} $textNotNull,
      ${CustomerFields.companyArabic} $textNotNull, 
      ${CustomerFields.customer} $textNotNull,
      ${CustomerFields.customerArabic} $textNotNull,
      ${CustomerFields.contactNumber} $textNotNull,
      ${CustomerFields.vatNumber} $textNotNull,
      ${CustomerFields.email} $textNotNull,
      ${CustomerFields.address} $textNotNull,
      ${CustomerFields.addressArabic} $textNotNull,
      ${CustomerFields.city} $textNotNull,
      ${CustomerFields.cityArabic} $textNotNull,
      ${CustomerFields.state} $textNotNull,
      ${CustomerFields.stateArabic} $textNotNull,
      ${CustomerFields.country} $textNotNull,
      ${CustomerFields.countryArabic} $textNotNull,
      ${CustomerFields.poBox} $textNotNull)''');

//========== Table Item-Master ==========
    await db.execute('''CREATE TABLE $tableItemMaster (
      ${ItemMasterFields.id} $idAuto,
      ${ItemMasterFields.productType} $textNotNull,
      ${ItemMasterFields.itemName} $textNotNull,
      ${ItemMasterFields.itemNameArabic} $textNotNull, 
      ${ItemMasterFields.itemCode} $textNotNull,
      ${ItemMasterFields.itemCategoryId} $intNotNull,
      ${ItemMasterFields.itemSubCategoryId} $intNull,
      ${ItemMasterFields.itemBrandId} $intNull,
      ${ItemMasterFields.itemCost} $textNotNull,
      ${ItemMasterFields.sellingPrice} $textNotNull,
      ${ItemMasterFields.secondarySellingPrice} $textNotNull,
      ${ItemMasterFields.vatId} $intNotNull,
      ${ItemMasterFields.vatRate} $intNotNull,
      ${ItemMasterFields.productVAT} $textNotNull,
      ${ItemMasterFields.unit} $textNotNull,
      ${ItemMasterFields.expiryDate} $textNotNull,
      ${ItemMasterFields.openingStock} $textNotNull,
      ${ItemMasterFields.vatMethod} $textNotNull,
      ${ItemMasterFields.alertQuantity} $textNotNull,
      ${ItemMasterFields.itemImage} $textNotNull)''');

    //========== Table Expense ==========
    await db.execute('''CREATE TABLE $tableExpense (
      ${ExpenseFields.id} $idAuto,
      ${ExpenseFields.expenseCategory} $textNotNull,
      ${ExpenseFields.expenseTitle} $textNotNull,
      ${ExpenseFields.amount} $textNotNull,
      ${ExpenseFields.vatId} $intNull,
      ${ExpenseFields.vatMethod} $textNull,
      ${ExpenseFields.vatAmount} $textNull,
      ${ExpenseFields.dateTime} $textNotNull,
      ${ExpenseFields.date} $textNotNull,
      ${ExpenseFields.note} $textNull,
      ${ExpenseFields.voucherNumber} $textNull,
      ${ExpenseFields.payBy} $textNotNull,
      ${ExpenseFields.documents} $textNull)''');

//========== Table Business Profile ==========
    await db.execute('''CREATE TABLE $tableBusinessProfile (
      ${BusinessProfileFields.id} $idNotNull,
      ${BusinessProfileFields.business} $textNotNull,
      ${BusinessProfileFields.businessArabic} $textNotNull,
      ${BusinessProfileFields.billerName} $textNotNull,
      ${BusinessProfileFields.address} $textNotNull, 
      ${BusinessProfileFields.addressArabic} $textNotNull,
      ${BusinessProfileFields.city} $textNotNull,
      ${BusinessProfileFields.cityArabic} $textNotNull,
      ${BusinessProfileFields.state} $textNotNull,
      ${BusinessProfileFields.stateArabic} $textNotNull,
      ${BusinessProfileFields.country} $textNotNull,
      ${BusinessProfileFields.countryArabic} $textNotNull,
      ${BusinessProfileFields.vatNumber} $textNotNull,
      ${BusinessProfileFields.phoneNumber} $textNotNull,
      ${BusinessProfileFields.email} $textNotNull,
      ${BusinessProfileFields.logo} $textNotNull)''');

//========== Table VAT ==========
    await db.execute('''CREATE TABLE $tableVat (
      ${VatFields.id} $idAuto, 
      ${VatFields.name} $textNotNull,
      ${VatFields.code} $textNotNull,
      ${VatFields.rate} $intNotNull,
      ${VatFields.type} $textNotNull)''');

//========== Table Expense ==========
    await db.execute('''CREATE TABLE $tableExpenseCategory (
      ${ExpenseCategoryFields.id} $idAuto,
      ${ExpenseCategoryFields.expense} $textNotNull)''');

//========== Table Sales ==========
    await db.execute('''CREATE TABLE $tableSales (
      ${SalesFields.id} $idAuto,
      ${SalesFields.invoiceNumber} $textNotNull,
      ${SalesFields.returnAmount} $textNull,
      ${SalesFields.salesNote} $textNotNull,
      ${SalesFields.dateTime} $textNotNull,
      ${SalesFields.customerId} $intNotNull, 
      ${SalesFields.customerName} $textNotNull,
      ${SalesFields.billerName} $textNotNull,
      ${SalesFields.totalItems} $textNotNull,
      ${SalesFields.vatAmount} $textNotNull,
      ${SalesFields.subTotal} $textNotNull,
      ${SalesFields.discount} $textNotNull,
      ${SalesFields.grantTotal} $textNotNull,
      ${SalesFields.paid} $textNotNull,
      ${SalesFields.balance} $textNotNull,
      ${SalesFields.paymentType} $textNotNull,
      ${SalesFields.salesStatus} $textNotNull,
      ${SalesFields.paymentStatus} $textNotNull,
      ${SalesFields.createdBy} $textNotNull)''');

//========== Table Sales Items ==========
    await db.execute('''CREATE TABLE $tableSalesItems (
      ${SalesItemsFields.id} $idAuto,
      ${SalesItemsFields.saleId} $intNotNull,
      ${SalesItemsFields.productId} $intNotNull,
      ${SalesItemsFields.productType} $textNotNull,
      ${SalesItemsFields.productName} $textNotNull,
      ${SalesItemsFields.categoryId} $intNotNull,
      ${SalesItemsFields.productCode} $textNotNull,
      ${SalesItemsFields.unitPrice} $textNotNull,
      ${SalesItemsFields.productCost} $textNotNull,
      ${SalesItemsFields.quantity} $textNotNull,
      ${SalesItemsFields.subTotal} $textNotNull,
      ${SalesItemsFields.vatMethod} $textNotNull,
      ${SalesItemsFields.vatId} $intNotNull,
      ${SalesItemsFields.vatTotal} $textNotNull,
      ${SalesItemsFields.unitCode} $textNotNull,
      ${SalesItemsFields.netUnitPrice} $textNotNull,
      ${SalesItemsFields.vatPercentage} $textNotNull,
      ${SalesItemsFields.vatRate} $intNotNull)''');

//========== Table Transactions ==========
    await db.execute('''CREATE TABLE $tableTransactions (
      ${TransactionsField.id} $idAuto,
      ${TransactionsField.category} $textNotNull,
      ${TransactionsField.transactionType} $textNotNull,
      ${TransactionsField.dateTime} $textNotNull,
      ${TransactionsField.amount} $textNotNull,
      ${TransactionsField.status} $textNotNull,
      ${TransactionsField.description} $textNull,
      ${TransactionsField.salesId} $intNull,
      ${TransactionsField.purchaseId} $intNull,
      ${TransactionsField.salesReturnId} $intNull,
      ${TransactionsField.purchaseReturnId} $intNull,
      ${TransactionsField.customerId} $intNull,
      ${TransactionsField.supplierId} $intNull,
      ${TransactionsField.payBy} $textNull)''');

//========== Table Purchase ==========
    await db.execute('''CREATE TABLE $tablePurchase (
      ${PurchaseFields.id} $idAuto,
      ${PurchaseFields.invoiceNumber} $textNotNull,
      ${PurchaseFields.referenceNumber} $textNotNull,
      ${PurchaseFields.purchaseNote} $textNotNull,
      ${PurchaseFields.dateTime} $textNotNull,
      ${PurchaseFields.supplierId} $intNotNull, 
      ${PurchaseFields.supplierName} $textNotNull,
      ${PurchaseFields.billerName} $textNotNull,
      ${PurchaseFields.totalItems} $textNotNull,
      ${PurchaseFields.vatAmount} $textNotNull,
      ${PurchaseFields.subTotal} $textNotNull,
      ${PurchaseFields.discount} $textNotNull,
      ${PurchaseFields.grantTotal} $textNotNull,
      ${PurchaseFields.paid} $textNotNull,
      ${PurchaseFields.balance} $textNotNull,
      ${SalesFields.returnAmount} $textNull,
      ${PurchaseFields.paymentType} $textNotNull,
      ${PurchaseFields.purchaseStatus} $textNotNull,
      ${PurchaseFields.paymentStatus} $textNotNull,
      ${PurchaseFields.createdBy} $textNotNull)''');

//========== Table Purchase Items ==========
    await db.execute('''CREATE TABLE $tablePurchaseItems (
      ${PurchaseItemsFields.id} $idAuto,
      ${PurchaseItemsFields.purchaseId} $intNotNull,
      ${PurchaseItemsFields.productId} $intNotNull,
      ${PurchaseItemsFields.productType} $textNotNull,
      ${PurchaseItemsFields.productName} $textNotNull,
      ${PurchaseItemsFields.categoryId} $intNotNull,
      ${PurchaseItemsFields.productCode} $textNotNull,
      ${PurchaseItemsFields.unitPrice} $textNotNull,
      ${PurchaseItemsFields.productCost} $textNotNull,
      ${PurchaseItemsFields.quantity} $textNotNull,
      ${PurchaseItemsFields.subTotal} $textNotNull,
      ${PurchaseItemsFields.vatId} $intNotNull,
      ${PurchaseItemsFields.vatMethod} $textNotNull,
      ${PurchaseItemsFields.vatRate} $intNotNull,
      ${PurchaseItemsFields.vatTotal} $textNotNull,
      ${PurchaseItemsFields.unitCode} $textNotNull,
      ${PurchaseItemsFields.netUnitPrice} $textNotNull,
      ${PurchaseItemsFields.vatPercentage} $textNotNull)''');

// ========== Table Sales Return ==========
    await db.execute('''CREATE TABLE $tableSalesReturn (
      ${SalesReturnFields.id} $idAuto,
      ${SalesReturnFields.saleId} $intNull,
      ${SalesReturnFields.invoiceNumber} $textNotNull,
      ${SalesReturnFields.originalInvoiceNumber} $textNotNull,
      ${SalesReturnFields.salesNote} $textNotNull,
      ${SalesReturnFields.dateTime} $textNotNull,
      ${SalesReturnFields.customerId} $intNotNull,
      ${SalesReturnFields.customerName} $textNotNull,
      ${SalesReturnFields.billerName} $textNotNull,
      ${SalesReturnFields.totalItems} $textNotNull,
      ${SalesReturnFields.vatAmount} $textNotNull,
      ${SalesReturnFields.subTotal} $textNotNull,
      ${SalesReturnFields.discount} $textNotNull,
      ${SalesReturnFields.grantTotal} $textNotNull,
      ${SalesReturnFields.paid} $textNotNull,
      ${SalesReturnFields.balance} $textNotNull,
      ${SalesReturnFields.paymentType} $textNotNull,
      ${SalesReturnFields.salesStatus} $textNotNull,
      ${SalesReturnFields.paymentStatus} $textNotNull,
      ${SalesReturnFields.createdBy} $textNotNull)''');

//========== Table Sales Return Items ==========
    await db.execute('''CREATE TABLE $tableSalesReturnItems (
      ${SalesReturnItemsFields.id} $idAuto,
      ${SalesReturnItemsFields.saleId} $intNotNull,
      ${SalesReturnItemsFields.saleReturnId} $intNotNull,
      ${SalesReturnItemsFields.originalInvoiceNumber} $textNotNull,
      ${SalesReturnItemsFields.productId} $intNotNull,
      ${SalesReturnItemsFields.productType} $textNotNull,
      ${SalesReturnItemsFields.productName} $textNotNull,
      ${SalesReturnItemsFields.categoryId} $intNotNull,
      ${SalesReturnItemsFields.productCode} $textNotNull,
      ${SalesReturnItemsFields.unitPrice} $textNotNull,
      ${SalesReturnItemsFields.productCost} $textNotNull,
      ${SalesReturnItemsFields.quantity} $textNotNull,
      ${SalesReturnItemsFields.subTotal} $textNotNull,
      ${SalesReturnItemsFields.vatMethod} $textNotNull,
      ${SalesReturnItemsFields.vatId} $intNotNull,
      ${SalesReturnItemsFields.vatRate} $intNotNull,
      ${SalesReturnItemsFields.vatTotal} $textNotNull,
      ${SalesReturnItemsFields.unitCode} $textNotNull,
      ${SalesReturnItemsFields.netUnitPrice} $textNotNull,
      ${SalesReturnItemsFields.vatPercentage} $textNotNull)''');

// ========== Table Purchase Return ==========
    await db.execute('''CREATE TABLE $tablePurchaseReturn (
      ${PurchaseReturnFields.id} $idAuto,
      ${PurchaseReturnFields.purchaseId} $intNotNull,
      ${PurchaseReturnFields.invoiceNumber} $textNotNull,
      ${PurchaseReturnFields.referenceNumber} $textNotNull,
      ${PurchaseReturnFields.originalInvoiceNumber} $textNull,
      ${PurchaseReturnFields.purchaseNote} $textNotNull,
      ${PurchaseReturnFields.dateTime} $textNotNull,
      ${PurchaseReturnFields.supplierId} $intNotNull,
      ${PurchaseReturnFields.supplierName} $textNotNull,
      ${PurchaseReturnFields.billerName} $textNotNull,
      ${PurchaseReturnFields.totalItems} $textNotNull,
      ${PurchaseReturnFields.vatAmount} $textNotNull,
      ${PurchaseReturnFields.subTotal} $textNotNull,
      ${PurchaseReturnFields.discount} $textNotNull,
      ${PurchaseReturnFields.grantTotal} $textNotNull,
      ${PurchaseReturnFields.paid} $textNotNull,
      ${PurchaseReturnFields.balance} $textNotNull,
      ${PurchaseReturnFields.paymentType} $textNotNull,
      ${PurchaseReturnFields.purchaseStatus} $textNotNull,
      ${PurchaseReturnFields.paymentStatus} $textNotNull,
      ${PurchaseReturnFields.createdBy} $textNotNull)''');

//========== Table Purchase Return Items ==========
    await db.execute('''CREATE TABLE $tablePurchaseItemsReturn (
      ${PurchaseReturnItemsFields.id} $idAuto,
      ${PurchaseReturnItemsFields.purchaseId} $intNotNull,
      ${PurchaseReturnItemsFields.purchaseReturnId} $intNotNull,
      ${PurchaseReturnItemsFields.originalInvoiceNumber} $textNull,
      ${PurchaseReturnItemsFields.productId} $intNotNull,
      ${PurchaseReturnItemsFields.productType} $textNotNull,
      ${PurchaseReturnItemsFields.productName} $textNotNull,
      ${PurchaseReturnItemsFields.categoryId} $intNotNull,
      ${PurchaseReturnItemsFields.productCode} $textNotNull,
      ${PurchaseReturnItemsFields.unitPrice} $textNotNull,
      ${PurchaseReturnItemsFields.productCost} $textNotNull,
      ${PurchaseReturnItemsFields.quantity} $textNotNull,
      ${PurchaseReturnItemsFields.subTotal} $textNotNull,
      ${PurchaseReturnItemsFields.vatId} $intNotNull,
      ${PurchaseReturnItemsFields.vatTotal} $textNotNull,
      ${PurchaseReturnItemsFields.unitCode} $textNotNull,
      ${PurchaseReturnItemsFields.netUnitPrice} $textNotNull,
      ${PurchaseReturnItemsFields.vatPercentage} $textNotNull)''');

//========== Table Cash Register ==========
    await db.execute('''CREATE TABLE $tableCashRegister (
      ${CashRegisterFields.id} $idAuto, 
      ${CashRegisterFields.dateTime} $textNotNull,
      ${CashRegisterFields.amount} $textNotNull,
      ${CashRegisterFields.userId} $intNotNull,
      ${CashRegisterFields.action} $textNotNull)''');
  }
}
