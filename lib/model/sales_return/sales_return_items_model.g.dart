// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_return_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SalesReturnItemsModel _$$_SalesReturnItemsModelFromJson(
        Map<String, dynamic> json) =>
    _$_SalesReturnItemsModel(
      id: json['_id'] as int?,
      saleId: json['saleId'] as int?,
      originalInvoiceNumber: json['originalInvoiceNumber'] as String?,
      saleReturnId: json['saleReturnId'] as int,
      productId: json['productId'] as String,
      productType: json['productType'] as String,
      productCode: json['productCode'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String,
      productCost: json['productCost'] as String,
      netUnitPrice: json['netUnitPrice'] as String,
      unitPrice: json['unitPrice'] as String,
      quantity: json['quantity'] as String,
      unitCode: json['unitCode'] as String,
      subTotal: json['subTotal'] as String,
      vatMethod: json['vatMethod'] as String,
      vatId: json['vatId'] as String,
      vatPercentage: json['vatPercentage'] as String,
      vatRate: json['vatRate'] as int,
      vatTotal: json['vatTotal'] as String,
    );

Map<String, dynamic> _$$_SalesReturnItemsModelToJson(
        _$_SalesReturnItemsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'saleId': instance.saleId,
      'originalInvoiceNumber': instance.originalInvoiceNumber,
      'saleReturnId': instance.saleReturnId,
      'productId': instance.productId,
      'productType': instance.productType,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'category': instance.category,
      'productCost': instance.productCost,
      'netUnitPrice': instance.netUnitPrice,
      'unitPrice': instance.unitPrice,
      'quantity': instance.quantity,
      'unitCode': instance.unitCode,
      'subTotal': instance.subTotal,
      'vatMethod': instance.vatMethod,
      'vatId': instance.vatId,
      'vatPercentage': instance.vatPercentage,
      'vatRate': instance.vatRate,
      'vatTotal': instance.vatTotal,
    };
