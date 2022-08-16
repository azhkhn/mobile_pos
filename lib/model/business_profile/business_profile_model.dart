import 'dart:typed_data';

const String tableBusinessProfile = 'business_profile';

class BusinessProfileFields {
  static const id = '_id';
  static const business = 'business';
  static const businessArabic = 'businessArabic';
  static const billerName = 'biller';
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
  static const logo = 'logo';
}

class BusinessProfileModel {
  int? id;
  final String business,
      businessArabic,
      billerName,
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
      email;
  final Uint8List logo;

  BusinessProfileModel({
    this.id = 0,
    required this.business,
    required this.businessArabic,
    required this.billerName,
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
    required this.logo,
  });

  Map<String, Object?> toJson() => {
        BusinessProfileFields.id: id,
        BusinessProfileFields.business: business,
        BusinessProfileFields.businessArabic: businessArabic,
        BusinessProfileFields.billerName: billerName,
        BusinessProfileFields.address: address,
        BusinessProfileFields.addressArabic: addressArabic,
        BusinessProfileFields.city: city,
        BusinessProfileFields.cityArabic: cityArabic,
        BusinessProfileFields.state: state,
        BusinessProfileFields.stateArabic: stateArabic,
        BusinessProfileFields.country: country,
        BusinessProfileFields.countryArabic: countryArabic,
        BusinessProfileFields.vatNumber: vatNumber,
        BusinessProfileFields.phoneNumber: phoneNumber,
        BusinessProfileFields.email: email,
        BusinessProfileFields.logo: logo,
      };

  static BusinessProfileModel fromJson(Map<String, Object?> json) => BusinessProfileModel(
        id: json[BusinessProfileFields.id] as int,
        business: json[BusinessProfileFields.business] as String,
        businessArabic: json[BusinessProfileFields.businessArabic] as String,
        billerName: json[BusinessProfileFields.billerName] as String,
        address: json[BusinessProfileFields.address] as String,
        addressArabic: json[BusinessProfileFields.addressArabic] as String,
        city: json[BusinessProfileFields.city] as String,
        cityArabic: json[BusinessProfileFields.cityArabic] as String,
        state: json[BusinessProfileFields.state] as String,
        stateArabic: json[BusinessProfileFields.stateArabic] as String,
        country: json[BusinessProfileFields.country] as String,
        countryArabic: json[BusinessProfileFields.countryArabic] as String,
        vatNumber: json[BusinessProfileFields.vatNumber] as String,
        phoneNumber: json[BusinessProfileFields.phoneNumber] as String,
        email: json[BusinessProfileFields.email] as String,
        logo: json[BusinessProfileFields.logo] as Uint8List,
      );
}
