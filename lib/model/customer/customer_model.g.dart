// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CustomerModel _$$_CustomerModelFromJson(Map<String, dynamic> json) =>
    _$_CustomerModel(
      id: json['_id'] as int?,
      customerType: json['customerType'] as String,
      company: json['company'],
      companyArabic: json['companyArabic'],
      customer: json['customer'],
      customerArabic: json['customerArabic'],
      vatNumber: json['vatNumber'] as String?,
      email: json['email'],
      address: json['address'],
      addressArabic: json['addressArabic'],
      city: json['city'],
      cityArabic: json['cityArabic'],
      state: json['state'],
      stateArabic: json['stateArabic'],
      country: json['country'],
      countryArabic: json['countryArabic'],
      poBox: json['poBox'],
    );

Map<String, dynamic> _$$_CustomerModelToJson(_$_CustomerModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'customerType': instance.customerType,
      'company': instance.company,
      'companyArabic': instance.companyArabic,
      'customer': instance.customer,
      'customerArabic': instance.customerArabic,
      'vatNumber': instance.vatNumber,
      'email': instance.email,
      'address': instance.address,
      'addressArabic': instance.addressArabic,
      'city': instance.city,
      'cityArabic': instance.cityArabic,
      'state': instance.state,
      'stateArabic': instance.stateArabic,
      'country': instance.country,
      'countryArabic': instance.countryArabic,
      'poBox': instance.poBox,
    };
