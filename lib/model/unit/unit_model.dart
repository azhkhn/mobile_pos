const String tableUnit = 'unit';

class UnitFields {
  static const String id = '_id';
  static const String unit = 'unit';
}

class UnitModel {
  final int? id;
  final String unit;
  UnitModel({
    this.id,
    required this.unit,
  });

  Map<String, Object?> toJson() => {
        UnitFields.id: id,
        UnitFields.unit: unit,
      };

  static UnitModel fromJson(Map<String, Object?> json) => UnitModel(
        id: json[UnitFields.id] as int,
        unit: json[UnitFields.unit] as String,
      );

  String get() {
    return unit;
  }
}
