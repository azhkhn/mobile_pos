const String tableVat = 'vat';

class VatFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String code = 'code';
  static const String rate = 'rate';
  static const String type = 'type';
}

class VatModel {
  final int? id;
  final String name;
  final String code;
  final String rate;
  final String type;
  VatModel(
      {this.id,
      required this.name,
      required this.code,
      required this.rate,
      required this.type});

  Map<String, Object?> toJson() => {
        VatFields.id: id,
        VatFields.name: name,
        VatFields.code: code,
        VatFields.rate: rate,
        VatFields.type: type
      };

  static VatModel fromJson(Map<String, Object?> json) => VatModel(
        id: json[VatFields.id] as int,
        name: json[VatFields.name] as String,
        code: json[VatFields.code] as String,
        rate: json[VatFields.rate] as String,
        type: json[VatFields.type] as String,
      );

  String get() {
    return name;
  }
}
