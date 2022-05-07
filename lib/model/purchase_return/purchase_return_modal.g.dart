// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_return_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PurchaseReturnModel _$$_PurchaseReturnModelFromJson(
        Map<String, dynamic> json) =>
    _$_PurchaseReturnModel(
      id: json['_id'] as int?,
      invoiceNumber: json['invoiceNumber'] as String?,
      purchaseid: json['purchaseid'] as int?,
      originalInvoiceNumber: json['originalInvoiceNumber'] as String?,
      referenceNumber: json['referenceNumber'] as String,
      dateTime: json['dateTime'] as String,
      supplierId: json['supplierId'] as int,
      supplierName: json['supplierName'] as String,
      billerName: json['billerName'] as String,
      purchaseNote: json['purchaseNote'] as String,
      totalItems: json['totalItems'] as String,
      vatAmount: json['vatAmount'] as String,
      subTotal: json['subTotal'] as String,
      discount: json['discount'] as String,
      grantTotal: json['grantTotal'] as String,
      paid: json['paid'] as String,
      balance: json['balance'] as String,
      paymentType: json['paymentType'] as String,
      purchaseStatus: json['purchaseStatus'] as String,
      paymentStatus: json['paymentStatus'] as String,
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$$_PurchaseReturnModelToJson(
        _$_PurchaseReturnModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'purchaseid': instance.purchaseid,
      'originalInvoiceNumber': instance.originalInvoiceNumber,
      'referenceNumber': instance.referenceNumber,
      'dateTime': instance.dateTime,
      'supplierId': instance.supplierId,
      'supplierName': instance.supplierName,
      'billerName': instance.billerName,
      'purchaseNote': instance.purchaseNote,
      'totalItems': instance.totalItems,
      'vatAmount': instance.vatAmount,
      'subTotal': instance.subTotal,
      'discount': instance.discount,
      'grantTotal': instance.grantTotal,
      'paid': instance.paid,
      'balance': instance.balance,
      'paymentType': instance.paymentType,
      'purchaseStatus': instance.purchaseStatus,
      'paymentStatus': instance.paymentStatus,
      'createdBy': instance.createdBy,
    };
