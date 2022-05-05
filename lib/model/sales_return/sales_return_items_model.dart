import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_return_items_model.freezed.dart';
part 'sales_return_items_model.g.dart';

@freezed
class SalesReturnItemsModel with _$SalesReturnItemsModel {
  const factory SalesReturnItemsModel({
    @JsonKey(name: '_id') int? id,
    String? originalInvoiceNumber,
    required int saleReturnId,
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
  }) = _SalesReturnItemsModel;

  factory SalesReturnItemsModel.fromJson(Map<String, dynamic> json) =>
      _$SalesReturnItemsModelFromJson(json);
}

const String tableSalesReturnItems = 'sales_return_items';

class SalesReturnItemsFields {
  static const id = '_id';
  static const saleReturnId = 'saleReturnId';
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
