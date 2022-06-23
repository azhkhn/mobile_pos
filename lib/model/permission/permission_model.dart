import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_model.freezed.dart';
part 'permission_model.g.dart';

const String tablePermission = 'permission';

class PermissionFields {
  static const String id = '_id';
  static const String groupId = 'groupId';
  static const String user = 'user';
  static const String sale = 'sale';
  static const String purchase = 'purchase';
  static const String products = 'products';
  static const String customer = 'customer';
  static const String supplier = 'supplier';
  static const String returns = 'returns';
}

@freezed
class PermissionModel with _$PermissionModel {
  const factory PermissionModel({
    @JsonKey(name: '_id') int? id,
    int? groupId,
    @Default('0') String user,
    @Default('0') String sale,
    @Default('0') String purchase,
    @Default('0') String returns,
    @Default('0') String products,
    @Default('0') String customer,
    @Default('0') String supplier,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) => _$PermissionModelFromJson(json);
}
