import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';

class BusinessProfileDatabase {
  static final BusinessProfileDatabase instance = BusinessProfileDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  BusinessProfileDatabase._init();

//========== Create Business Profile ==========
  Future<void> createBusinessProfile(BusinessProfileModel _businessProfileModel) async {
    final db = await dbInstance.database;
    final _result = await db.query(tableBusinessProfile);
    if (_result.isNotEmpty) {
      updateBusinessProfile(_businessProfileModel);
    } else {
      final id = await db.insert(tableBusinessProfile, _businessProfileModel.toJson());
      log('Business Profile id == $id');
    }
  }

  //========== Update Business Profile ==========
  Future<void> updateBusinessProfile(BusinessProfileModel _businessProfileModel) async {
    final db = await dbInstance.database;
    final id = await db.update(tableBusinessProfile, _businessProfileModel.toJson(),
        where: '${BusinessProfileFields.id} = ?', whereArgs: [_businessProfileModel.id]);
    log('Business Profile id == $id');
  }

//========== Get Business Profile ==========
  Future<BusinessProfileModel?> getBusinessProfile() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableBusinessProfile);
    // db.delete(tableBusinessProfile);
    log('Fetching Business Profile details..');
    if (_result.isNotEmpty) {
      final _businessProfiles = _result.map((json) => BusinessProfileModel.fromJson(json)).toList();
      return _businessProfiles.first;
    } else {
      return null;
    }
  }
}
