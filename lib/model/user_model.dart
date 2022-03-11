const String tableUser = 'users';
const String tableLogin = 'login';

class UserFeilds {
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
        UserFeilds.id: id,
        UserFeilds.shopName: shopName,
        UserFeilds.countryName: countryName,
        UserFeilds.shopCategory: shopCategory,
        UserFeilds.mobileNumber: mobileNumber,
        UserFeilds.email: email,
        UserFeilds.password: password,
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
        id: json[UserFeilds.id] as int,
        shopName: json[UserFeilds.shopName] as String,
        countryName: json[UserFeilds.countryName] as String,
        shopCategory: json[UserFeilds.shopCategory] as String,
        mobileNumber: json[UserFeilds.mobileNumber] as String,
        email: json[UserFeilds.email] as String,
        password: json[UserFeilds.password] as String,
      );
}
