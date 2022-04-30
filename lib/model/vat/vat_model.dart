import 'package:freezed_annotation/freezed_annotation.dart';

part 'vat_model.freezed.dart';
part 'vat_model.g.dart';

const String tableVat = 'vat';

class VatFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String code = 'code';
  static const String rate = 'rate';
  static const String type = 'type';
}

@freezed
class VatModel with _$VatModel {
  const VatModel._();
  const factory VatModel({
    @JsonKey(name: '_id') int? id,
    required String name,
    required String code,
    required int rate,
    required String type,
  }) = _VatModel;

  factory VatModel.fromJson(Map<String, dynamic> json) =>
      _$VatModelFromJson(json);

  String get() => name;
}
