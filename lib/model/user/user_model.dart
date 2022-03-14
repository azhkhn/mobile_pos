const String tableUser = 'users';
const String tableLogin = 'login';

class UserFields {
  static const String id = '_id';
  static const String shopName = 'shopName';
  static const String countryName = 'countryName';
  static const String shopCategory = 'shopCategory';
  static const String mobileNumber = 'mobileNumber';
  static const String email = 'email';
  static const String password = 'password';
}

class UserModel {
  final int? id;
  final String shopName, countryName, shopCategory, mobileNumber, password;
  final String? email;

  UserModel({
    this.id,
    required this.shopName,
    required this.countryName,
    required this.shopCategory,
    required this.mobileNumber,
    required this.email,
    required this.password,
  });

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.shopName: shopName,
        UserFields.countryName: countryName,
        UserFields.shopCategory: shopCategory,
        UserFields.mobileNumber: mobileNumber,
        UserFields.email: email,
        UserFields.password: password,
      };

  UserModel copy({
    int? id,
    String? shopName,
    countryName,
    shopCategory,
    mobileNumber,
    password,
    email,
  }) =>
      UserModel(
        id: id ?? this.id,
        shopName: shopName ?? this.shopName,
        countryName: countryName ?? this.countryName,
        shopCategory: shopCategory ?? this.shopCategory,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        password: password ?? this.password,
        email: email ?? this.email,
      );

  static UserModel fromJson(Map<String, Object?> json) => UserModel(
        id: json[UserFields.id] as int,
        shopName: json[UserFields.shopName] as String,
        countryName: json[UserFields.countryName] as String,
        shopCategory: json[UserFields.shopCategory] as String,
        mobileNumber: json[UserFields.mobileNumber] as String,
        email: json[UserFields.email] as String,
        password: json[UserFields.password] as String,
      );
}
