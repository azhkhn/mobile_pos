const String tableBiller = 'biller';

class BillerFields {
  static const id = '_id';
  static const company = 'company';
  static const companyArabic = 'companyArabic';
  static const name = 'name';
  static const nameArabic = 'nameArabic';
  static const address = 'address';
  static const addressArabic = 'addressArabic';
  static const city = 'city';
  static const cityArabic = 'cityArabic';
  static const state = 'state';
  static const stateArabic = 'stateArabic';
  static const country = 'country';
  static const countryArabic = 'countryArabic';
  static const vatNumber = 'vatNumber';
  static const phoneNumber = 'phoneNumber';
  static const email = 'email';
  static const poBox = 'poBox';
  static const logo = 'logo';
}

class BillerModel {
  int? id;
  final String company,
      companyArabic,
      name,
      nameArabic,
      address,
      addressArabic,
      city,
      cityArabic,
      state,
      stateArabic,
      country,
      countryArabic,
      vatNumber,
      phoneNumber,
      email,
      poBox,
      logo;

  BillerModel({
    this.id = 0,
    required this.company,
    required this.companyArabic,
    required this.name,
    required this.nameArabic,
    required this.address,
    required this.addressArabic,
    required this.city,
    required this.cityArabic,
    required this.state,
    required this.stateArabic,
    required this.country,
    required this.countryArabic,
    required this.vatNumber,
    required this.phoneNumber,
    required this.email,
    required this.poBox,
    required this.logo,
  });

  Map<String, Object?> toJson() => {
        BillerFields.id: id,
        BillerFields.company: company,
        BillerFields.companyArabic: companyArabic,
        BillerFields.name: name,
        BillerFields.nameArabic: nameArabic,
        BillerFields.address: address,
        BillerFields.addressArabic: addressArabic,
        BillerFields.city: city,
        BillerFields.cityArabic: cityArabic,
        BillerFields.state: state,
        BillerFields.stateArabic: stateArabic,
        BillerFields.country: country,
        BillerFields.countryArabic: countryArabic,
        BillerFields.vatNumber: vatNumber,
        BillerFields.phoneNumber: phoneNumber,
        BillerFields.email: email,
        BillerFields.poBox: poBox,
        BillerFields.logo: logo,
      };

  static BillerModel fromJson(Map<String, Object?> json) => BillerModel(
        id: json[BillerFields.id] as int,
        company: json[BillerFields.company] as String,
        companyArabic: json[BillerFields.companyArabic] as String,
        name: json[BillerFields.name] as String,
        nameArabic: json[BillerFields.nameArabic] as String,
        address: json[BillerFields.address] as String,
        addressArabic: json[BillerFields.addressArabic] as String,
        city: json[BillerFields.city] as String,
        cityArabic: json[BillerFields.cityArabic] as String,
        state: json[BillerFields.state] as String,
        stateArabic: json[BillerFields.stateArabic] as String,
        country: json[BillerFields.country] as String,
        countryArabic: json[BillerFields.countryArabic] as String,
        vatNumber: json[BillerFields.vatNumber] as String,
        phoneNumber: json[BillerFields.phoneNumber] as String,
        email: json[BillerFields.email] as String,
        poBox: json[BillerFields.poBox] as String,
        logo: json[BillerFields.logo] as String,
      );
}
