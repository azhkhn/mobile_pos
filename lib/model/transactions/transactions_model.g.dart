// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TransactionsModel _$$_TransactionsModelFromJson(Map<String, dynamic> json) =>
    _$_TransactionsModel(
      id: json['_id'] as int?,
      category: json['category'] as String,
      transactionType: json['transactionType'] as String,
      dateTime: json['dateTime'] as String,
      amount: json['amount'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      salesId: json['salesId'] as int?,
      purchaseId: json['purchaseId'] as int?,
      salesReturnId: json['salesReturnId'] as int?,
      purchaseReturnId: json['purchaseReturnId'] as int?,
    );

Map<String, dynamic> _$$_TransactionsModelToJson(
        _$_TransactionsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'category': instance.category,
      'transactionType': instance.transactionType,
      'dateTime': instance.dateTime,
      'amount': instance.amount,
      'status': instance.status,
      'description': instance.description,
      'salesId': instance.salesId,
      'purchaseId': instance.purchaseId,
      'salesReturnId': instance.salesReturnId,
      'purchaseReturnId': instance.purchaseReturnId,
    };
