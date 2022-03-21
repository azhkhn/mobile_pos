const String tableSubCategory = 'sub_category';

class SubCategoryFields {
  static const String id = '_id';
  static const String category = 'category';
  static const String subCategory = 'subCategory';
}

class SubCategoryModel {
  final int? id;
  final String category;
  final String subCategory;
  SubCategoryModel({
    this.id,
    required this.category,
    required this.subCategory,
  });

  Map<String, Object?> toJson() => {
        SubCategoryFields.id: id,
        SubCategoryFields.category: category,
        SubCategoryFields.subCategory: subCategory,
      };

  static SubCategoryModel fromJson(Map<String, Object?> json) =>
      SubCategoryModel(
        id: json[SubCategoryFields.id] as int,
        category: json[SubCategoryFields.category] as String,
        subCategory: json[SubCategoryFields.subCategory] as String,
      );

  String get() {
    return subCategory;
  }
}
