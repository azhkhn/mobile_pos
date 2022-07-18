import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

const String tableExpense = 'expense';

class ExpenseFields {
  static const String id = '_id';
  static const String expenseCategory = 'expenseCategory';
  static const String expenseTitle = 'expenseTitle';
  static const String amount = 'amount';
  static const String vatId = 'vatId';
  static const String vatMethod = 'vatMethod';
  static const String vatAmount = 'vatAmount';
  static const String dateTime = 'dateTime';
  static const String date = 'date';
  static const String note = 'note';
  static const String voucherNumber = 'voucherNumber';
  static const String payBy = 'payBy';
  static const String documents = 'documents';
}

@freezed
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    @JsonKey(name: '_id') int? id,
    required String expenseCategory,
    required String expenseTitle,
    required String amount,
    required String date,
    required String dateTime,
    required String payBy,
    String? note,
    String? vatMethod,
    String? vatAmount,
    int? vatId,
    String? voucherNumber,
    String? documents,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => _$ExpenseModelFromJson(json);
}
