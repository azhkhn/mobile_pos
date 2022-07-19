import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_register_model.freezed.dart';
part 'cash_register_model.g.dart';

const String tableCashRegister = 'cash_register';

class CashRegisterFields {
  static const String id = '_id';
  static const String dateTime = 'dateTime';
  static const String amount = 'amount';
  static const String userId = 'userId';
  static const String action = 'action';
}

@freezed
class CashRegisterModel with _$CashRegisterModel {
  const factory CashRegisterModel({
    @JsonKey(name: '_id') int? id,
    required String dateTime,
    required String amount,
    required int userId,
    required String action,
  }) = _CashRegisterModel;

  factory CashRegisterModel.fromJson(Map<String, dynamic> json) => _$CashRegisterModelFromJson(json);
}
