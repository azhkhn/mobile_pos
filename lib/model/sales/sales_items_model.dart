import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_items_model.freezed.dart';
part 'sales_items_model.g.dart';

@freezed
class SalesItemsModel with _$SalesItemsModel {
  const factory SalesItemsModel({
    @JsonKey(name: '_id') int? id,
    required int saleId,
    required int productId,
    required String productType,
    required String productCode,
    required String productName,
    required String productNameArabic,
    required int categoryId,
    required String productCost,
    required String netUnitPrice,
    required String unitPrice,
    required String quantity,
    required String unitCode,
    required String subTotal,
    required String vatMethod,
    required int vatId,
    required String vatPercentage,
    required int vatRate,
    required String vatTotal,
  }) = _SalesItemsModel;

  factory SalesItemsModel.fromJson(Map<String, dynamic> json) => _$SalesItemsModelFromJson(json);
}

const String tableSalesItems = 'sales_items';

class SalesItemsFields {
  static const id = '_id';
  static const saleId = 'saleId';
  static const productId = 'productId';
  static const productType = 'productType';
  static const productCode = 'productCode';
  static const productName = 'productName';
  static const productNameArabic = 'productNameArabic';
  static const categoryId = 'categoryId';
  static const productCost = 'productCost';
  static const netUnitPrice = 'netUnitPrice';
  static const unitPrice = 'unitPrice';
  static const quantity = 'quantity';
  static const unitCode = 'unitCode';
  static const subTotal = 'subTotal';
  static const vatMethod = 'vatMethod';
  static const vatId = 'vatId';
  static const vatPercentage = 'vatPercentage';
  static const vatRate = 'vatRate';
  static const vatTotal = 'vatTotal';
}
