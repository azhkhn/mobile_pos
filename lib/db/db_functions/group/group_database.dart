import 'dart:developer';

import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/group/group_model.dart';

class GroupDatabase {
  static final GroupDatabase instance = GroupDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  GroupDatabase._init();

//========== Create Group ==========
  Future<int> createGroup(GroupModel _groupModel) async {
    final db = await dbInstance.database;
    final group = await db.rawQuery('''select * from $tableGroup where ${GroupFields.name} = "${_groupModel.name}" COLLATE NOCASE''');

    if (group.isNotEmpty) {
      log('Group already exist!');
      throw 'Group name already exist!';
    } else {
      final id = await db.insert(tableGroup, _groupModel.toJson());
      log('Group ($id) Created!');
      return id;
    }
  }

  //========== Update Group ==========
  Future<GroupModel> updateGroup(GroupModel groupModel) async {
    final db = await dbInstance.database;
    final _id = await db.update(
      tableGroup,
      groupModel.toJson(),
      where: '${GroupFields.id} = ?',
      whereArgs: [groupModel.id],
    );
    log('Group ($_id) updated successfully');
    return groupModel;
  }

  //========== Get Group By Id ==========
  Future<GroupModel> getGroupById(int id) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableGroup, where: '${GroupFields.id} = ?', whereArgs: [id]);
    log('Fetching Group($id) details..');
    final GroupModel _groups = GroupModel.fromJson(_result.first);
    // db.delete(tableGroup);
    return _groups;
  }

  //========== Get All Groups ==========
  Future<List<GroupModel>> getAllGroups() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableGroup);
    log('Groups === $_result');
    final _groups = _result.map((json) => GroupModel.fromJson(json)).toList();
    // db.delete(tableGroup);
    return _groups;
  }
}
