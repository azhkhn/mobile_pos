import 'dart:developer' show log;
import 'package:shop_ez/db/db_functions/busiess_profile/business_profile_database.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import '../../../model/auth/user_model.dart';

class UserUtils {
//========== Singleton Instance ==========
  UserUtils._();
  static final UserUtils instance = UserUtils._();
  factory UserUtils() {
    return instance;
  }

//========== Model Classes ==========
  UserModel? userModel;
  BusinessProfileModel? businessProfileModel;

//========== Get Logged User Details ==========
  Future<UserModel> get loggedUser async {
    if (userModel != null) return userModel!;
    await getUser();
    return userModel!;
  }

//========== Get Business Profile Details ==========
  Future<BusinessProfileModel> get businessProfile async {
    if (businessProfileModel != null) return businessProfileModel!;
    await getBusinessProfile();
    if (businessProfileModel == null) {
      throw 'Business Profile is Empty';
    }
    return businessProfileModel!;
  }

//Checking Business Profile details already Assigned (Access User details all over the Application)
  Future<void> getBusinessProfile() async {
    log('Fetching Business Profile details..');
    final BusinessProfileDatabase businessProfileDB = BusinessProfileDatabase.instance;
    final _businessProfile = await businessProfileDB.getBusinessProfile();
    businessProfileModel = _businessProfile;
    log('Done!');
  }

//Checking Logged user details already Assigned (Access User details all over the Application)
  Future<void> getUser() async {
    log('Fetching Logged User details..');
    final UserDatabase userDB = UserDatabase.instance;
    final _user = await userDB.getUser();
    userModel = _user;
    log('Done!');
  }
}
