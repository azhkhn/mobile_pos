import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_category_model.freezed.dart';
part 'sub_category_model.g.dart';

const String tableSubCategory = 'sub_category';

class SubCategoryFields {
  static const String id = '_id';
  static const String category = 'category';
  static const String subCategory = 'subCategory';
}

@freezed
class SubCategoryModel with _$SubCategoryModel {
  const SubCategoryModel._();
  const factory SubCategoryModel({
    @JsonKey(name: '_id') int? id,
    required String category,
    required String subCategory,
  }) = _CategoryModel;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryModelFromJson(json);

  String get() {
    return subCategory;
  }
}
