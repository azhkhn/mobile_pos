const String tableSupplier = 'supplier';

class SupplierFields {
  static const id = '_id';
  static const company = 'company';
  static const companyArabic = 'companyArabic';
  static const supplier = 'supplier';
  static const supplierArabic = 'supplierArabic';
  static const vatNumber = 'vatNumber';
  static const email = 'email';
  static const address = 'address';
  static const addressArabic = 'addressArabic';
  static const city = 'city';
  static const cityArabic = 'cityArabic';
  static const state = 'state';
  static const stateArabic = 'stateArabic';
  static const country = 'country';
  static const countryArabic = 'countryArabic';
  static const poBox = 'poBox';
}

class SupplierModel {
  final int? id;
  final String company, companyArabic, supplier, supplierArabic;
  final String? vatNumber,
      email,
      address,
      addressArabic,
      city,
      cityArabic,
      state,
      stateArabic,
      country,
      countryArabic,
      poBox;

  SupplierModel({
    this.id,
    required this.company,
    required this.companyArabic,
    required this.supplier,
    required this.supplierArabic,
    this.vatNumber,
    this.email,
    this.address,
    this.addressArabic,
    this.city,
    this.cityArabic,
    this.state,
    this.stateArabic,
    this.country,
    this.countryArabic,
    this.poBox,
  });

  Map<String, Object?> toJson() => {
        SupplierFields.id: id,
        SupplierFields.company: company,
        SupplierFields.companyArabic: companyArabic,
        SupplierFields.supplier: supplier,
        SupplierFields.supplierArabic: supplierArabic,
        SupplierFields.vatNumber: vatNumber,
        SupplierFields.email: email,
        SupplierFields.address: address,
        SupplierFields.addressArabic: addressArabic,
        SupplierFields.city: city,
        SupplierFields.cityArabic: cityArabic,
        SupplierFields.state: state,
        SupplierFields.stateArabic: stateArabic,
        SupplierFields.country: country,
        SupplierFields.countryArabic: countryArabic,
        SupplierFields.poBox: poBox,
      };

  static SupplierModel fromJson(Map<String, Object?> json) => SupplierModel(
        id: json[SupplierFields.id] as int,
        company: json[SupplierFields.company] as String,
        companyArabic: json[SupplierFields.companyArabic] as String,
        supplier: json[SupplierFields.supplier] as String,
        supplierArabic: json[SupplierFields.supplierArabic] as String,
        vatNumber: json[SupplierFields.vatNumber] as String,
        email: json[SupplierFields.email] as String,
        address: json[SupplierFields.address] as String,
        addressArabic: json[SupplierFields.addressArabic] as String,
        city: json[SupplierFields.city] as String,
        cityArabic: json[SupplierFields.cityArabic] as String,
        state: json[SupplierFields.state] as String,
        stateArabic: json[SupplierFields.stateArabic] as String,
        country: json[SupplierFields.country] as String,
        countryArabic: [SupplierFields.countryArabic] as String,
        poBox: json[SupplierFields.poBox] as String,
      );
}
