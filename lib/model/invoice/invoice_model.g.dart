// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InvoiceItem _$$_InvoiceItemFromJson(Map<String, dynamic> json) =>
    _$_InvoiceItem(
      no: json['no'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as String,
      unitPrice: json['unitPrice'] as String,
      subTotal: json['subTotal'] as String,
      vatPercentage: json['vatPercentage'] as String,
      vatAmount: json['vatAmount'] as String,
      totalAmount: json['totalAmount'] as String,
    );

Map<String, dynamic> _$$_InvoiceItemToJson(_$_InvoiceItem instance) =>
    <String, dynamic>{
      'no': instance.no,
      'description': instance.description,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'subTotal': instance.subTotal,
      'vatPercentage': instance.vatPercentage,
      'vatAmount': instance.vatAmount,
      'totalAmount': instance.totalAmount,
    };
