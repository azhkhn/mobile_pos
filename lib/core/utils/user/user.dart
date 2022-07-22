import 'dart:developer' show log;
import 'package:shop_ez/db/db_functions/busiess_profile/business_profile_database.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/db/db_functions/cash_register/cash_register_database.dart';
import 'package:shop_ez/db/db_functions/group/group_database.dart';
import 'package:shop_ez/db/db_functions/permission/permission_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/cash_register/cash_register_model.dart';
import 'package:shop_ez/model/group/group_model.dart';
import 'package:shop_ez/model/permission/permission_model.dart';
import 'package:shop_ez/screens/home/home_screen.dart';
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
  GroupModel? groupModel;
  PermissionModel? permissionModel;
  CashRegisterModel? cashRegisterModel;

//========== Load all User Details ==========
  Future<void> fetchUserDetails() async {
    await loggedUser;
    await userGroup;
    await permission;
    await businessProfile;
    await cashRegister;
  }

  //========== Unload all User Details ==========
  void cleanUserDetails() {
    log('Cleaning saved user details..');
    userModel = null;
    businessProfileModel = null;
    groupModel = null;
    permissionModel = null;
    cashRegisterModel = null;
  }

  //========== Reload all User Details ==========
  Future<void> reloadUserDetails() async {
    cleanUserDetails();
    await fetchUserDetails();
  }

//========== Get User Details ==========
  Future<UserModel> get loggedUser async {
    if (userModel != null) return userModel!;
    await getUser();
    return userModel!;
  }

  //========== Update User Details ==========
  Future<void> get updateUser async {
    log('Updating saved User details..');
    userModel = null;
    await loggedUser;
  }

  //========== Get User-Group Details ==========
  Future<GroupModel> get userGroup async {
    if (groupModel != null) return groupModel!;
    await getGroup();
    return groupModel!;
  }

  //========== Get Group-Permission Details ==========
  Future<PermissionModel> get permission async {
    if (permissionModel != null) return permissionModel!;
    await getPermissions();
    return permissionModel!;
  }

  //========== Update Group and Permission Details ==========
  Future<void> get updateGroupAndPermission async {
    log('Updating saved Group & Permission details..');

    groupModel = null;
    permissionModel = null;

    await userGroup;
    await permission;
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

  //========== Update Business Profile Details ==========
  Future<void> get updateBusinessProfile async {
    log('Updating saved Group & Permission details..');

    businessProfileModel = null;

    await businessProfile;
  }

  //========== Get User Details ==========
  Future<CashRegisterModel?> get cashRegister async {
    if (cashRegisterModel != null) return cashRegisterModel!;
    await getLastCashRegister();
    return cashRegisterModel;
  }

//Business Profile details (Access User details all over the Application)
  Future<void> getBusinessProfile() async {
    final BusinessProfileDatabase businessProfileDB = BusinessProfileDatabase.instance;
    final _businessProfile = await businessProfileDB.getBusinessProfile();
    businessProfileModel = _businessProfile;
    ScreenHome.businessNotifier.value = businessProfileModel;
  }

//Logged user details (Access User details all over the Application)
  Future<void> getUser() async {
    final UserDatabase userDB = UserDatabase.instance;
    final _user = await userDB.getUser();
    userModel = _user;
  }

  //Logged user group details (Access User details all over the Application)
  Future<void> getGroup() async {
    final GroupDatabase groupDB = GroupDatabase.instance;
    //get user details for groupId
    await loggedUser;
    final _group = await groupDB.getGroupById(userModel!.groupId);
    groupModel = _group;
  }

  //Logged user group details (Access User details all over the Application)
  Future<void> getPermissions() async {
    final PermissionDatabase permissionDB = PermissionDatabase.instance;

    //get user details for groupId
    await loggedUser;

    final _permission = await permissionDB.getPermissionByGroupId(userModel!.groupId);
    permissionModel = _permission;
  }

  //Latest Cash Register details (Access User details all over the Application)
  Future<void> getLastCashRegister() async {
    final CashRegisterDatabase cashDatabase = CashRegisterDatabase.instance;
    final _cashRegister = await cashDatabase.getLatestRegister();
    cashRegisterModel = _cashRegister;
  }
}
