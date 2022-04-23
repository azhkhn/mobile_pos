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
    required String itemCategory,
    required String itemSubCategory,
    required String itemBrand,
    required String itemCost,
    required String sellingPrice,
    required String secondarySellingPrice,
    required String vatMethod,
    required String productVAT,
    required String vatId,
    required String unit,
    required String expiryDate,
    required String openingStock,
    required String alertQuantity,
    required String itemImage,
  }) = _ItemMasterModel;

  factory ItemMasterModel.fromJson(Map<String, dynamic> json) =>
      _$ItemMasterModelFromJson(json);
}

const String tableItemMaster = 'item_master';

class ItemMasterFields {
  static const id = '_id';
  static const productType = 'productType';
  static const itemName = 'itemName';
  static const itemNameArabic = 'itemNameArabic';
  static const itemCode = 'itemCode';
  static const itemCategory = 'itemCategory';
  static const itemSubCategory = 'itemSubCategory';
  static const itemBrand = 'itemBrand';
  static const itemCost = 'itemCost';
  static const sellingPrice = 'sellingPrice';
  static const secondarySellingPrice = 'secondarySellingPrice';
  static const vatMethod = 'vatMethod';
  static const productVAT = 'productVAT';
  static const vatId = 'vatId';
  static const unit = 'unit';
  static const expiryDate = 'expiryDate';
  static const openingStock = 'openingStock';
  static const alertQuantity = 'alertQuantity';
  static const itemImage = 'itemImage';
}

// class ItemMasterModel {
//   final int? id;
//   final String productType,
//       itemName,
//       itemNameArabic,
//       itemCode,
//       itemCategory,
//       itemCost,
//       sellingPrice,
//       vatId,
//       productVAT,
//       unit,
//       vatMethod;
//   final String? itemSubCategory,
//       itemBrand,
//       secondarySellingPrice,
//       openingStock,
//       alertQuantity,
//       itemImage;

//   ItemMasterModel({
//     this.id,
//     required this.productType,
//     required this.itemName,
//     required this.itemNameArabic,
//     required this.itemCode,
//     required this.itemCategory,
//     required this.itemCost,
//     required this.sellingPrice,
//     required this.vatId,
//     required this.productVAT,
//     required this.unit,
//     required this.vatMethod,
//     this.itemSubCategory,
//     this.itemBrand,
//     this.secondarySellingPrice,
//     this.openingStock,
//     this.alertQuantity,
//     this.itemImage,
//   });

//   ItemMasterModel copyWith({
//     final int? id,
//     final String? productType,
//     itemName,
//     itemNameArabic,
//     itemCode,
//     itemCategory,
//     itemCost,
//     sellingPrice,
//     vatId,
//     productVAT,
//     unit,
//     vatMethod,
//     itemSubCategory,
//     itemBrand,
//     secondarySellingPrice,
//     openingStock,
//     alertQuantity,
//     itemImage,
//   }) =>
//       ItemMasterModel(
//         id: id ?? this.id,
//         productType: productType ?? this.productType,
//         itemName: itemName ?? this.itemName,
//         itemNameArabic: itemNameArabic ?? this.itemNameArabic,
//         itemCode: itemCode ?? this.itemCode,
//         itemCategory: itemCategory ?? this.itemCategory,
//         itemCost: itemCost ?? this.itemCost,
//         sellingPrice: sellingPrice ?? this.sellingPrice,
//         vatId: vatId ?? this.vatId,
//         productVAT: productVAT ?? this.productVAT,
//         unit: unit ?? this.unit,
//         vatMethod: vatMethod ?? this.vatMethod,
//         itemSubCategory: itemSubCategory ?? this.itemSubCategory,
//         itemBrand: itemBrand ?? this.itemBrand,
//         secondarySellingPrice:
//             secondarySellingPrice ?? this.secondarySellingPrice,
//         openingStock: openingStock ?? this.openingStock,
//         alertQuantity: alertQuantity ?? this.alertQuantity,
//         itemImage: itemImage ?? this.itemImage,
//       );

//   Map<String, Object?> toJson() => {
//         ItemMasterFields.id: id,
//         ItemMasterFields.productType: productType,
//         ItemMasterFields.itemName: itemName,
//         ItemMasterFields.itemNameArabic: itemNameArabic,
//         ItemMasterFields.itemCode: itemCode,
//         ItemMasterFields.itemCategory: itemCategory,
//         ItemMasterFields.itemSubCategory: itemSubCategory,
//         ItemMasterFields.itemBrand: itemBrand,
//         ItemMasterFields.itemCost: itemCost,
//         ItemMasterFields.sellingPrice: sellingPrice,
//         ItemMasterFields.secondarySellingPrice: secondarySellingPrice,
//         ItemMasterFields.vatId: vatId,
//         ItemMasterFields.productVAT: productVAT,
//         ItemMasterFields.unit: unit,
//         ItemMasterFields.openingStock: openingStock,
//         ItemMasterFields.itemImage: itemImage,
//         ItemMasterFields.vatMethod: vatMethod,
//         ItemMasterFields.alertQuantity: alertQuantity,
//       };

//   static ItemMasterModel fromJson(Map<String, Object?> json) => ItemMasterModel(
//         id: json[ItemMasterFields.id] as int,
//         productType: json[ItemMasterFields.productType] as String,
//         itemName: json[ItemMasterFields.itemName] as String,
//         itemNameArabic: json[ItemMasterFields.itemNameArabic] as String,
//         itemCode: json[ItemMasterFields.itemCode] as String,
//         itemCategory: json[ItemMasterFields.itemCategory] as String,
//         itemSubCategory: json[ItemMasterFields.itemSubCategory] as String,
//         itemBrand: json[ItemMasterFields.itemBrand] as String,
//         itemCost: json[ItemMasterFields.itemCost] as String,
//         sellingPrice: json[ItemMasterFields.sellingPrice] as String,
//         secondarySellingPrice:
//             json[ItemMasterFields.secondarySellingPrice] as String,
//         vatId: json[ItemMasterFields.vatId] as String,
//         productVAT: json[ItemMasterFields.productVAT] as String,
//         unit: json[ItemMasterFields.unit] as String,
//         openingStock: json[ItemMasterFields.openingStock] as String,
//         itemImage: json[ItemMasterFields.itemImage] as String,
//         vatMethod: json[ItemMasterFields.vatMethod] as String,
//         alertQuantity: json[ItemMasterFields.alertQuantity] as String,
//       );
// }
