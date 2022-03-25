import 'dart:developer';
import 'package:shop_ez/db/database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';

class BusinessProfileDatabase {
  static final BusinessProfileDatabase instance =
      BusinessProfileDatabase._init();
  EzDatabase dbInstance = EzDatabase.instance;
  BusinessProfileDatabase._init();

//========== Create Business Profile ==========
  Future<void> createBusinessProfile(
      BusinessProfileModel _businessProfileModel) async {
    final db = await dbInstance.database;
    log('Business Profile Added!');
    final id =
        await db.insert(tableBusinessProfile, _businessProfileModel.toJson());
    log('Business Profile id == $id');
  }

//========== Get All Business Profiles ==========
  Future<List<BusinessProfileModel>> getAllBusinessProfiles() async {
    final db = await dbInstance.database;
    final _result = await db.query(tableBusinessProfile);
    // db.delete(tableBusinessProfile);
    log('Business ProfileS == $_result');
    final _businessProfiles =
        _result.map((json) => BusinessProfileModel.fromJson(json)).toList();
    return _businessProfiles;
  }
}
