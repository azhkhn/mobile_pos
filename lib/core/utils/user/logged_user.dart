import 'dart:developer' show log;
import 'package:shop_ez/db/db_functions/user_database/user_db.dart';
import '../../../model/user/user_model.dart';

class LoggedUser {
//========== Singleton ==========
  LoggedUser._();
  static final LoggedUser instance = LoggedUser._();
  factory LoggedUser() {
    return instance;
  }

//Checking Logged user already Assigned to ValueNotifier (Access User details all over the Application)
  Future<UserModel?> get currentUser async {
    if (userModel != null) return userModel;

    await getUser();
    return userModel;
  }

  static UserModel? userModel;

  final UserDatabase userDB = UserDatabase.instance;
  Future<void> getUser() async {
    final _user = await userDB.getUser();
    log('getting user');
    userModel = _user;
  }
}
