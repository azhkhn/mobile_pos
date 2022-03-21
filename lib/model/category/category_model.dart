const String tableCategory = 'category';

class CategoryFields {
  static const String id = '_id';
  static const String category = 'category';
}

class CategoryModel {
  final int? id;
  final String category;
  CategoryModel({
    this.id,
    required this.category,
  });

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.category: category,
      };

  static CategoryModel fromJson(Map<String, Object?> json) => CategoryModel(
        id: json[CategoryFields.id] as int,
        category: json[CategoryFields.category] as String,
      );

  String get() {
    return category;
  }
}
