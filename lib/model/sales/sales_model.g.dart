// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SalesModel _$$_SalesModelFromJson(Map<String, dynamic> json) =>
    _$_SalesModel(
      id: json['_id'] as int?,
      invoiceNumber: json['invoiceNumber'] as String?,
      customerId: json['customerId'] as int,
      dateTime: json['dateTime'] as String,
      customerName: json['customerName'] as String,
      billerName: json['billerName'] as String,
      salesNote: json['salesNote'] as String,
      totalItems: json['totalItems'] as String,
      vatAmount: json['vatAmount'] as String,
      subTotal: json['subTotal'] as String,
      discount: json['discount'] as String,
      grantTotal: json['grantTotal'] as String,
      paid: json['paid'] as String,
      balance: json['balance'] as String,
      paymentType: json['paymentType'] as String,
      salesStatus: json['salesStatus'] as String,
      paymentStatus: json['paymentStatus'] as String,
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$$_SalesModelToJson(_$_SalesModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'customerId': instance.customerId,
      'dateTime': instance.dateTime,
      'customerName': instance.customerName,
      'billerName': instance.billerName,
      'salesNote': instance.salesNote,
      'totalItems': instance.totalItems,
      'vatAmount': instance.vatAmount,
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'grantTotal': instance.grantTotal,
      'paid': instance.paid,
      'balance': instance.balance,
      'paymentType': instance.paymentType,
      'salesStatus': instance.salesStatus,
      'paymentStatus': instance.paymentStatus,
      'createdBy': instance.createdBy,
    };
