import 'dart:async';
import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/auth/user_model.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  final dbInstance = EzDatabase.instance;
  UserDatabase._init();

//========== SignUp ==========
  Future<UserModel> createUser(UserModel userModel) async {
    final db = await dbInstance.database;
    final user = await db.rawQuery(
        '''select * from $tableUser where ${UserFields.mobileNumber} = "${userModel.mobileNumber}" or ${UserFields.username} = "${userModel.username}" or ${UserFields.email} = "${userModel.email}"''');
    if (user.isNotEmpty) {
      final _user = UserModel.fromJson(user.first);

      if (_user.username == userModel.username) {
        throw 'Username number already exist';
      } else if (_user.mobileNumber == userModel.mobileNumber) {
        throw 'Mobile number already exist';
      } else if (_user.email == userModel.email) {
        throw 'Email number already exist';
      }

      log('User already exist!');
      throw Exception('User Already Exist!');
    } else {
      log('User registered!');
      final id = await db.insert(tableUser, userModel.toJson());
      // final newUser = await db.rawQuery('''select * from $tableUser where ${UserFields.mobileNumber} = "${userModel.username}"''');
      // final UserModel userCred = UserModel.fromJson(newUser.first);
      db.insert(tableLogin, userModel.copyWith(id: id).toJson());
      return userModel.copyWith(id: id);
    }
  }

//========== Login ==========
  Future<UserModel?> loginUser(String username, String password) async {
    final db = await dbInstance.database;
    final response = await db.rawQuery(
        '''select * from $tableUser where ${UserFields.username} = "$username" and ${UserFields.password} = "$password" or ${UserFields.mobileNumber} = "$username" and ${UserFields.password} = "$password" or  ${UserFields.email} = "$username" and ${UserFields.password} = "$password"''');
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
