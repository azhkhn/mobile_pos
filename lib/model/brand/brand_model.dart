import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_model.g.dart';
part 'brand_model.freezed.dart';

const String tableBrand = 'brand';

class BrandFields {
  static const String id = '_id';
  static const String brand = 'brand';
}

@freezed
class BrandModel with _$BrandModel {
  const BrandModel._();

  const factory BrandModel({
    @JsonKey(name: '_id') int? id,
    required String brand,
  }) = _BrandModel;

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  String get() {
    return brand;
  }
}
