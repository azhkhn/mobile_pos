import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_model.freezed.dart';
part 'permission_model.g.dart';

const String tablePermission = 'permission';

class PermissionFields {
  static const String id = '_id';
  static const String sale = 'sale';
  static const String purchase = 'purchase';
  static const String stock = 'stock';
  static const String expense = 'expense';
  static const String customer = 'customer';
  static const String supplier = 'supplier';
}

@freezed
class PermissionModel with _$PermissionModel {
  const factory PermissionModel({
    @JsonKey(name: '_id') int? id,
    required int groupId,
    @Default('0') String sale,
    @Default('0') String purchase,
    @Default('0') String itemMaster,
    @Default('0') String stock,
    @Default('0') String expense,
    @Default('0') String customer,
    @Default('0') String supplier,
  }) = _PermissionModel;

  factory PermissionModel.fromJson(Map<String, dynamic> json) => _$PermissionModelFromJson(json);
}
