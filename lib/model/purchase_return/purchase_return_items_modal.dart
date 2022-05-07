import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_return_items_modal.freezed.dart';
part 'purchase_return_items_modal.g.dart';

const String tablePurchaseItemsReturn = 'purchase_items_return';

class PurchaseItemsReturnFields {
  static const id = '_id';
  static const purchaseId = 'purchaseId';
  static const purchaseReturnId = 'purchaseReturnId';
  static const originalInvoiceNumber = 'originalInvoiceNumber';
  static const productId = 'productId';
  static const productType = 'productType';
  static const productCode = 'productCode';
  static const productName = 'productName';
  static const category = 'category';
  static const productCost = 'productCost';
  static const netUnitPrice = 'netUnitPrice';
  static const unitPrice = 'unitPrice';
  static const quantity = 'quantity';
  static const unitCode = 'unitCode';
  static const subTotal = 'subTotal';
  static const vatId = 'vatId';
  static const vatPercentage = 'vatPercentage';
  static const vatTotal = 'vatTotal';
}

@freezed
class PurchaseItemsReturnModel with _$PurchaseItemsReturnModel {
  const factory PurchaseItemsReturnModel({
    @JsonKey(name: '_id') int? id,
    required int? purchaseId,
    required int purchaseReturnId,
    required String? originalInvoiceNumber,
    required String productId,
    required String productType,
    required String productCode,
    required String productName,
    required String category,
    required String productCost,
    required String netUnitPrice,
    required String unitPrice,
    required String quantity,
    required String unitCode,
    required String subTotal,
    required String vatId,
    required String vatPercentage,
    required String vatTotal,
  }) = _PurchaseItemsReturnModel;

  factory PurchaseItemsReturnModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemsReturnModelFromJson(json);
}
