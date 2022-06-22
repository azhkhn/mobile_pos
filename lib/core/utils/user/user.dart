import 'dart:developer' show log;
import 'package:shop_ez/db/db_functions/busiess_profile/business_profile_database.dart';
import 'package:shop_ez/db/db_functions/auth/user_db.dart';
import 'package:shop_ez/db/db_functions/group/group_database.dart';
import 'package:shop_ez/db/db_functions/permission/permission_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/group/group_model.dart';
import 'package:shop_ez/model/permission/permission_model.dart';
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

//========== Load all User Details ==========
  Future<void> fetchUserDetails() async {
    await loggedUser;
    await businessProfile;
    await group;
    await permission;
  }

  //========== Unload all User Details ==========
  Future<void> cleanUserDetails() async {
    log('Cleaning saved user details..');
    userModel = null;
    businessProfileModel = null;
    groupModel = null;
    permissionModel = null;
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
  Future<GroupModel> get group async {
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

    await group;
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

//Business Profile details (Access User details all over the Application)
  Future<void> getBusinessProfile() async {
    log('Fetching Business Profile details..');
    final BusinessProfileDatabase businessProfileDB = BusinessProfileDatabase.instance;
    final _businessProfile = await businessProfileDB.getBusinessProfile();
    businessProfileModel = _businessProfile;
    log('Done!');
  }

//Logged user details (Access User details all over the Application)
  Future<void> getUser() async {
    log('Fetching Logged User details..');
    final UserDatabase userDB = UserDatabase.instance;
    final _user = await userDB.getUser();
    userModel = _user;
    log('Done!');
  }

  //Logged user group details (Access User details all over the Application)
  Future<void> getGroup() async {
    log('Fetching Group details..');
    final GroupDatabase groupDB = GroupDatabase.instance;

    //get user details for groupId
    await loggedUser;

    final _group = await groupDB.getGroupById(userModel!.groupId);
    groupModel = _group;
    log('Done!');
  }

  //Logged user group details (Access User details all over the Application)
  Future<void> getPermissions() async {
    log('Fetching Permissions details..');
    final PermissionDatabase permissionDB = PermissionDatabase.instance;

    //get user details for groupId
    await loggedUser;

    final _permission = await permissionDB.getPermissionByGroupId(userModel!.groupId);
    permissionModel = _permission;
    log('Done!');
  }
}
