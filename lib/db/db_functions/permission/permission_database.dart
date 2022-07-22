import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/permission/permission_model.dart';

class PermissionDatabase {
  static final PermissionDatabase instance = PermissionDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  PermissionDatabase._init();

//========== Create Permission ==========
  Future<void> createPermission(PermissionModel _permissionModel) async {
    final db = await dbInstance.database;
    final id = await db.insert(tablePermission, _permissionModel.toJson());
    log('Permission ($id) Created!');
  }

//========== Update Permission ==========
  Future<PermissionModel> updatePermissionByGroupId(PermissionModel _permModel) async {
    final db = await dbInstance.database;
    final _id = await db.update(
      tablePermission,
      _permModel.toJson(),
      where: '${PermissionFields.groupId} = ?',
      whereArgs: [_permModel.groupId],
    );
    log('Permission ($_id) updated successfully');
    return _permModel;
  }

//========== Get Permission By GroupId ==========
  Future<PermissionModel> getPermissionByGroupId(int groupId) async {
    final db = await dbInstance.database;
    final _result = await db.query(tablePermission, where: '${PermissionFields.groupId} = ?', whereArgs: [groupId]);
    log('Fetching Permissions by GroupId($groupId) details..');

    final _permission = PermissionModel.fromJson(_result.first);
    return _permission;
  }

//========== Get All Permissions ==========
  Future<List<PermissionModel>> getAllPermissions() async {
    final db = await dbInstance.database;
    final _result = await db.query(tablePermission);
    log('Permissions === $_result');
    final _permissions = _result.map((json) => PermissionModel.fromJson(json)).toList();
    // db.delete(tablePermission);
    return _permissions;
  }
}
