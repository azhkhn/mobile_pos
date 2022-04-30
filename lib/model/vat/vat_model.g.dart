// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_VatModel _$$_VatModelFromJson(Map<String, dynamic> json) => _$_VatModel(
      id: json['_id'] as int?,
      name: json['name'] as String,
      code: json['code'] as String,
      rate: json['rate'] as int,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$_VatModelToJson(_$_VatModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'rate': instance.rate,
      'type': instance.type,
    };
