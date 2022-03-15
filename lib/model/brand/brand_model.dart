const String tableBrand = 'brand';

class BrandFields {
  static const String id = '_id';
  static const String brand = 'brand';
}

class BrandModel {
  final int? id;
  final String brand;
  BrandModel({
    this.id,
    required this.brand,
  });

  Map<String, Object?> toJson() => {
        BrandFields.id: id,
        BrandFields.brand: brand,
      };

  static BrandModel fromJson(Map<String, Object?> json) => BrandModel(
        id: json[BrandFields.id] as int,
        brand: json[BrandFields.brand] as String,
      );
}
