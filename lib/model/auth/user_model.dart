import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

const String tableUser = 'users';
const String tableLogin = 'login';

class UserFields {
  static const String id = '_id';
  static const String userGroup = 'userGroup';
  static const String shopName = 'shopName';
  static const String countryName = 'countryName';
  static const String shopCategory = 'shopCategory';
  static const String name = 'name';
  static const String nameArabic = 'nameArabic';
  static const String address = 'address';
  static const String mobileNumber = 'mobileNumber';
  static const String email = 'email';
  static const String username = 'username';
  static const String password = 'password';
  static const String document = 'document';
  static const String status = 'status';
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') int? id,
    required String userGroup,
    required String shopName,
    required String countryName,
    required String shopCategory,
    required String mobileNumber,
    required String username,
    required String password,
    required int status,
    String? email,
    String? name,
    String? nameArabic,
    String? address,
    String? document,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
