import 'dart:async';
import 'dart:developer';
import 'package:shop_ez/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;
  UserDatabase._init();

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
  ${UserFeilds.id} $idType,
  ${UserFeilds.shopName} $textType,
  ${UserFeilds.countryName} $textType,
  ${UserFeilds.shopCategory} $textType,
  ${UserFeilds.mobileNumber} $textType,
  ${UserFeilds.email} $textType,
  ${UserFeilds.password} $textType)''');

//========== Table Login ==========
    await db.execute('''CREATE TABLE $tableLogin (
  ${UserFeilds.id} $idLogin,
  ${UserFeilds.shopName} $textType,
  ${UserFeilds.countryName} $textType,
  ${UserFeilds.shopCategory} $textType,
  ${UserFeilds.mobileNumber} $textType,
  ${UserFeilds.email} $textType,
  ${UserFeilds.password} $textType)''');

    //========== Table Category ==========
    await db.execute('''CREATE TABLE 'category' (
  '_id' $idType,
  'category' $textType)''');
  }

//========== Create Category ==========
  Future<void> createCategory(String newCategory) async {
    const tableCategory = 'category';
    final db = await instance.database;
    final category = await db.rawQuery(
        "select * from $tableCategory where category = '$newCategory'");
    if (category.isNotEmpty) {
      log('Category already exist!');
      throw Exception('Category Already Exist!');
    } else {
      log('Category Created!');
      final cat = await db.rawInsert(
          'INSERT INTO $tableCategory(category) VALUES(?)', [newCategory]);
      log('id == $cat');
    }
  }

//========== SignUp ==========
  Future<UserModel> createUser(UserModel userModel, String username) async {
    final db = await instance.database;
    final user = await db.rawQuery(
        "select * from $tableUser where ${UserFeilds.mobileNumber} = '$username'");
    if (user.isNotEmpty) {
      log('user already exist!');
      throw Exception('User Already Exist!');
    } else {
      log('User registered!');
      final id = await db.insert(tableUser, userModel.toJson());
      final newUser = await db.rawQuery(
          "select * from $tableUser where ${UserFeilds.mobileNumber} = '$username'");
      final userCred = UserModel.fromJson(newUser.first);
      db.insert(tableLogin, userCred.toJson());
      return userModel.copy(id: id);
    }
  }

//========== Login ==========
  Future<UserModel?> loginUser(String username, String password) async {
    final db = await instance.database;
    final response = await db.rawQuery(
        "select * from $tableUser where ${UserFeilds.mobileNumber} = '$username' and ${UserFeilds.password} = '$password' or  ${UserFeilds.email} = '$username' and ${UserFeilds.password} = '$password'");
    if (response.isNotEmpty) {
      final user = UserModel.fromJson(response.first);
      log('user== $user');
      db.insert(tableLogin, user.toJson());
      return user;
      // List list = response.toList().map((c) => UserModel.fromJson(c)).toList();
      // log('list response == ${list.toString()}');
      // return list[0];
    } else {
      throw Exception('User Not Found!');
    }
  }

//========== Login Status ==========
  Future isLogin() async {
    final db = await instance.database;
    final login = await db.rawQuery('select * from $tableLogin');

    return login.length;
  }

//========== Get User Details ==========
  Future<UserModel> getUser() async {
    final db = await instance.database;
    final _userList = await db.query(tableLogin);
    log('userList =  $_userList');
    final _user = _userList.map((json) => UserModel.fromJson(json)).toList();
    return _user[0];
  }

//========== Logout ==========
  Future logout() async {
    final db = await instance.database;
    db.delete(tableLogin);
  }

//========== Get All User Details ==========
  Future getAllUsers() async {
    final db = await instance.database;
    final _result = await db.query(tableUser);
    log('results === $_result');
    return _result.map((json) => UserModel.fromJson(json)).toList();
    // db.delete(tableLogin);
  }

  Future<List<dynamic>> getAllCategories() async {
    final db = await instance.database;
    final _result = await db.query('category');
    log('results === $_result');
    return _result;
  }

  Future<List<dynamic>> getcategories() async {
    final db = await instance.database;
    final _result = await db.query('category');
    final List<dynamic> list = await _result;
    log('results === $list');
    return list.toList();
  }
}
