import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_items_model.freezed.dart';
part 'purchase_items_model.g.dart';

const String tablePurchaseItems = 'purchase_items';

class PurchaseItemsFields {
  static const id = '_id';
  static const purchaseId = 'purchaseId';
  static const productId = 'productId';
  static const productType = 'productType';
  static const productCode = 'productCode';
  static const productName = 'productName';
  static const categoryId = 'categoryId';
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
class PurchaseItemsModel with _$PurchaseItemsModel {
  const factory PurchaseItemsModel({
    @JsonKey(name: '_id') int? id,
    required int purchaseId,
    required int productId,
    required String productType,
    required String productCode,
    required String productName,
    required int categoryId,
    required String productCost,
    required String netUnitPrice,
    required String unitPrice,
    required String quantity,
    required String unitCode,
    required String subTotal,
    required int vatId,
    required String vatPercentage,
    required String vatTotal,
  }) = _PurchaseItemsModel;

  factory PurchaseItemsModel.fromJson(Map<String, dynamic> json) => _$PurchaseItemsModelFromJson(json);
}
