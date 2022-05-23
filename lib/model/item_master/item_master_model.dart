import 'package:freezed_annotation/freezed_annotation.dart';
part 'item_master_model.freezed.dart';
part 'item_master_model.g.dart';

@freezed
class ItemMasterModel with _$ItemMasterModel {
  const factory ItemMasterModel({
    @JsonKey(name: '_id') int? id,
    required String productType,
    required String itemName,
    required String itemNameArabic,
    required String itemCode,
    required int itemCategoryId,
    required int? itemSubCategoryId,
    required int? itemBrandId,
    required String itemCost,
    required String sellingPrice,
    required String? secondarySellingPrice,
    required String vatMethod,
    required String productVAT,
    required int vatId,
    required int vatRate,
    required String unit,
    required String? expiryDate,
    required String openingStock,
    required String? alertQuantity,
    required String? itemImage,
  }) = _ItemMasterModel;

  factory ItemMasterModel.fromJson(Map<String, dynamic> json) => _$ItemMasterModelFromJson(json);
}

const String tableItemMaster = 'item_master';

class ItemMasterFields {
  static const id = '_id';
  static const productType = 'productType';
  static const itemName = 'itemName';
  static const itemNameArabic = 'itemNameArabic';
  static const itemCode = 'itemCode';
  static const itemCategoryId = 'itemCategoryId';
  static const itemSubCategoryId = 'itemSubCategoryId';
  static const itemBrandId = 'itemBrandId';
  static const itemCost = 'itemCost';
  static const sellingPrice = 'sellingPrice';
  static const secondarySellingPrice = 'secondarySellingPrice';
  static const vatMethod = 'vatMethod';
  static const productVAT = 'productVAT';
  static const vatId = 'vatId';
  static const vatRate = 'vatRate';
  static const unit = 'unit';
  static const expiryDate = 'expiryDate';
  static const openingStock = 'openingStock';
  static const alertQuantity = 'alertQuantity';
  static const itemImage = 'itemImage';
}
