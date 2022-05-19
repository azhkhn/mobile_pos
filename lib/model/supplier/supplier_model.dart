import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_model.freezed.dart';
part 'supplier_model.g.dart';

const String tableSupplier = 'supplier';

class SupplierFields {
  static const id = '_id';
  static const supplierName = 'supplierName';
  static const supplierNameArabic = 'supplierNameArabic';
  static const contactName = 'contactName';
  static const contactNumber = 'contactNumber';
  static const vatNumber = 'vatNumber';
  static const email = 'email';
  static const address = 'address';
  static const addressArabic = 'addressArabic';
  static const city = 'city';
  static const cityArabic = 'cityArabic';
  static const state = 'state';
  static const stateArabic = 'stateArabic';
  static const country = 'country';
  static const countryArabic = 'countryArabic';
  static const poBox = 'poBox';
}

@freezed
class SupplierModel with _$SupplierModel {
  const factory SupplierModel({
    @JsonKey(name: '_id') int? id,
    required String supplierName,
    required String supplierNameArabic,
    required String contactName,
    required String contactNumber,
    String? vatNumber,
    String? email,
    String? address,
    String? addressArabic,
    String? city,
    String? cityArabic,
    String? state,
    String? stateArabic,
    String? country,
    String? countryArabic,
    String? poBox,
  }) = _SupplierModel;

  factory SupplierModel.fromJson(Map<String, dynamic> json) => _$SupplierModelFromJson(json);
}
