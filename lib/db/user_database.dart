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

    _database = await _initDB('user.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
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

//========== Table for Users ==========
    await db.execute('''CREATE TABLE $tableUser (
  ${UserFeilds.id} $idType,
  ${UserFeilds.username} $textType,
  ${UserFeilds.email} $textType,
  ${UserFeilds.password} $textType)''');

//========== Table for Login ==========
    await db.execute('''CREATE TABLE $tableLogin (
  ${UserFeilds.id} $idLogin,
  ${UserFeilds.username} $textType,
  ${UserFeilds.email} $textType,
  ${UserFeilds.password} $textType)''');
  }

  Future<UserModel> createUser(UserModel userModel, String username) async {
    final db = await instance.database;
    final user = await db
        .rawQuery("select * from $tableUser where username = '$username'");
    if (user.isNotEmpty) {
      log('user already exist!');
      throw Exception('User Already Exist!');
    } else {
      log('user registered!');
      final id = await db.insert(tableUser, userModel.toJson());
      return userModel.copy(id: id);
    }
  }

  Future<UserModel?> loginUser(String username, String password) async {
    final db = await instance.database;
    final response = await db.rawQuery(
        "select * from $tableUser where username = '$username' and password = '$password'");
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

  Future isLogin() async {
    final db = await instance.database;
    final login = await db.rawQuery('select * from $tableLogin');

    return login.length;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await instance.database;
    final _result = await db.query(tableUser);
    log('results === $_result');
    return _result.map((json) => UserModel.fromJson(json)).toList();
  }
}
