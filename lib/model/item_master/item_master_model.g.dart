// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_master_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ItemMasterModel _$$_ItemMasterModelFromJson(Map<String, dynamic> json) =>
    _$_ItemMasterModel(
      id: json['_id'] as int?,
      productType: json['productType'] as String,
      itemName: json['itemName'] as String,
      itemNameArabic: json['itemNameArabic'] as String,
      itemCode: json['itemCode'] as String,
      itemCategory: json['itemCategory'] as String,
      itemCost: json['itemCost'] as String,
      sellingPrice: json['sellingPrice'] as String,
      vatId: json['vatId'] as String,
      productVAT: json['productVAT'] as String,
      unit: json['unit'] as String,
      vatMethod: json['vatMethod'] as String,
      itemSubCategory: json['itemSubCategory'] as String,
      itemBrand: json['itemBrand'] as String,
      secondarySellingPrice: json['secondarySellingPrice'] as String,
      openingStock: json['openingStock'] as String,
      alertQuantity: json['alertQuantity'] as String,
      itemImage: json['itemImage'] as String,
    );

Map<String, dynamic> _$$_ItemMasterModelToJson(_$_ItemMasterModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'productType': instance.productType,
      'itemName': instance.itemName,
      'itemNameArabic': instance.itemNameArabic,
      'itemCode': instance.itemCode,
      'itemCategory': instance.itemCategory,
      'itemCost': instance.itemCost,
      'sellingPrice': instance.sellingPrice,
      'vatId': instance.vatId,
      'productVAT': instance.productVAT,
      'unit': instance.unit,
      'vatMethod': instance.vatMethod,
      'itemSubCategory': instance.itemSubCategory,
      'itemBrand': instance.itemBrand,
      'secondarySellingPrice': instance.secondarySellingPrice,
      'openingStock': instance.openingStock,
      'alertQuantity': instance.alertQuantity,
      'itemImage': instance.itemImage,
    };
