import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

const String tableUnit = 'unit';

class UnitFields {
  static const String id = '_id';
  static const String unit = 'unit';
}

@freezed
class UnitModel with _$UnitModel {
  const UnitModel._();
  const factory UnitModel({
    @JsonKey(name: '_id') int? id,
    required String unit,
  }) = _UnitModel;

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);

  String get() => unit;
}
