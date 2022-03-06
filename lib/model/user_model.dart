const String tableUser = 'users';
const String tableLogin = 'login';

class UserFeilds {
  static const String id = '_id';
  static const String username = 'username';
  static const String email = 'email';
  static const String password = 'password';
}

class UserModel {
  final int? id;
  final String username;
  final String password;
  final String email;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.email,
  });

  Map<String, Object?> toJson() => {
        UserFeilds.id: id,
        UserFeilds.username: username,
        UserFeilds.email: email,
        UserFeilds.password: password,
      };

  UserModel copy({
    int? id,
    String? username,
    String? password,
    String? email,
  }) =>
      UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        email: email ?? this.email,
      );

  static UserModel fromJson(Map<String, Object?> json) => UserModel(
        id: json[UserFeilds.id] as int,
        username: json[UserFeilds.username] as String,
        email: json[UserFeilds.email] as String,
        password: json[UserFeilds.password] as String,
      );
}
