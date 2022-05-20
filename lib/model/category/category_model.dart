import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

const String tableCategory = 'category';

class CategoryFields {
  static const String id = '_id';
  static const String category = 'category';
}

@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();
  const factory CategoryModel({
    @JsonKey(name: '_id') int? id,
    required String category,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  String get() {
    return category;
  }
}
