import 'dart:async';
import 'dart:developer';
import 'package:shop_ez/core/utils/user/logged_user.dart';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/user/user_model.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  final dbInstance = EzDatabase.instance;
  UserDatabase._init();

//========== SignUp ==========
  Future<UserModel> createUser(UserModel userModel, String username) async {
    final db = await dbInstance.database;
    final user = await db.rawQuery(
        "select * from $tableUser where ${UserFields.mobileNumber} = '$username'");
    if (user.isNotEmpty) {
      log('user already exist!');
      throw Exception('User Already Exist!');
    } else {
      log('User registered!');
      final id = await db.insert(tableUser, userModel.toJson());
      final newUser = await db.rawQuery(
          "select * from $tableUser where ${UserFields.mobileNumber} = '$username'");
      final userCred = UserModel.fromJson(newUser.first);
      db.insert(tableLogin, userCred.toJson());
      return userModel.copy(id: id);
    }
  }

//========== Login ==========
  Future<UserModel?> loginUser(String username, String password) async {
    final db = await dbInstance.database;
    final response = await db.rawQuery(
        "select * from $tableUser where ${UserFields.mobileNumber} = '$username' and ${UserFields.password} = '$password' or  ${UserFields.email} = '$username' and ${UserFields.password} = '$password'");
    if (response.isNotEmpty) {
      final user = UserModel.fromJson(response.first);
      log('user == $user');
      await db.insert(tableLogin, user.toJson());
      return user;
    } else {
      throw Exception('User Not Found!');
    }
  }

//========== Login Status ==========
  Future isLogin() async {
    final db = await dbInstance.database;
    final login = await db.rawQuery('select * from $tableLogin');
    return login.length;
  }

//========== Get User Details ==========
  Future<UserModel> getUser() async {
    final db = await dbInstance.database;
    final _userList = await db.query(tableLogin);
    log('User ==  $_userList');
    final _user = _userList.map((json) => UserModel.fromJson(json)).toList();
    return _user.first;
  }

//========== Logout ==========
  Future logout() async {
    final db = await dbInstance.database;
    db.delete(tableLogin);
  }

//========== Get All User Details ==========
  Future getAllUsers() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableUser);
    log('results === $_result');
    // db.delete(tableUser);
    return _result.map((json) => UserModel.fromJson(json)).toList();
  }
}
