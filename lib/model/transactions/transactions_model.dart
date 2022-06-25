import 'package:freezed_annotation/freezed_annotation.dart';

part 'transactions_model.freezed.dart';
part 'transactions_model.g.dart';

const String tableTransactions = 'transactions';

class TransactionsField {
  static const id = '_id';
  static const category = 'category';
  static const transactionType = 'transactionType';
  static const dateTime = 'dateTime';
  static const amount = 'amount';
  static const status = 'status';
  static const description = 'description';
  static const salesId = 'salesId';
  static const purchaseId = 'purchaseId';
  static const salesReturnId = 'salesReturnId';
  static const purchaseReturnId = 'purchaseReturnId';
  static const customerId = 'customerId';
  static const supplierId = 'supplierId';
  static const payBy = 'payBy';
}

@freezed
class TransactionsModel with _$TransactionsModel {
  const factory TransactionsModel({
    @JsonKey(name: '_id') int? id,
    required String category,
    required String transactionType,
    required String dateTime,
    required String amount,
    required String status,
    String? description,
    int? salesId,
    int? purchaseId,
    int? salesReturnId,
    int? purchaseReturnId,
    int? customerId,
    int? supplierId,
    String? payBy,
  }) = _TransactionsModel;

  factory TransactionsModel.fromJson(Map<String, dynamic> json) => _$TransactionsModelFromJson(json);
}
