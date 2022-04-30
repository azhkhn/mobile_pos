import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_model.freezed.dart';
part 'purchase_model.g.dart';

const String tablePurchase = 'purchase';

class PurchaseFields {
  static const id = '_id';
  static const invoiceNumber = 'invoiceNumber';
  static const referenceNumber = 'referenceNumber';
  static const purchaseNote = 'purchaseNote';
  static const dateTime = 'dateTime';
  static const supplierId = 'supplierId';
  static const supplierName = 'supplierName';
  static const billerName = 'billerName';
  static const totalItems = 'totalItems';
  static const vatAmount = 'vatAmount';
  static const subTotal = 'subTotal';
  static const discount = 'discount';
  static const grantTotal = 'grantTotal';
  static const paid = 'paid';
  static const balance = 'balance';
  static const paymentType = 'paymentType';
  static const purchaseStatus = 'purchaseStatus';
  static const paymentStatus = 'paymentStatus';
  static const createdBy = 'createdBy';
}

@freezed
class PurchaseModel with _$PurchaseModel {
  const factory PurchaseModel({
    @JsonKey(name: '_id') int? id,
    String? invoiceNumber,
    required String referenceNumber,
    required String dateTime,
    required int supplierId,
    required String supplierName,
    required String billerName,
    required String purchaseNote,
    required String totalItems,
    required String vatAmount,
    required String subTotal,
    required String discount,
    required String grantTotal,
    required String paid,
    required String balance,
    required String paymentType,
    required String purchaseStatus,
    required String paymentStatus,
    required String createdBy,
  }) = _PurchaseModel;

  factory PurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseModelFromJson(json);
}
