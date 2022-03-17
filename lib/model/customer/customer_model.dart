const String tableCustomer = 'customer';

class CustomerFields {
  static const id = '_id';
  static const customerType = 'customerType';
  static const company = 'company';
  static const companyArabic = 'companyArabic';
  static const customer = 'customer';
  static const customerArabic = 'customerArabic';
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

class CustomerModel {
  final int? id;
  final String customerType, company, companyArabic, customer, customerArabic;
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

  CustomerModel({
    this.id,
    required this.customerType,
    required this.company,
    required this.companyArabic,
    required this.customer,
    required this.customerArabic,
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
        CustomerFields.id: id,
        CustomerFields.customerType: customerType,
        CustomerFields.company: company,
        CustomerFields.companyArabic: companyArabic,
        CustomerFields.customer: customer,
        CustomerFields.customerArabic: customerArabic,
        CustomerFields.vatNumber: vatNumber,
        CustomerFields.email: email,
        CustomerFields.address: address,
        CustomerFields.addressArabic: addressArabic,
        CustomerFields.city: city,
        CustomerFields.cityArabic: cityArabic,
        CustomerFields.state: state,
        CustomerFields.stateArabic: stateArabic,
        CustomerFields.country: country,
        CustomerFields.countryArabic: countryArabic,
        CustomerFields.poBox: poBox,
      };

  static CustomerModel fromJson(Map<String, Object?> json) => CustomerModel(
        id: json[CustomerFields.id] as int,
        customerType: json[CustomerFields.customerType] as String,
        company: json[CustomerFields.company] as String,
        companyArabic: json[CustomerFields.companyArabic] as String,
        customer: json[CustomerFields.customer] as String,
        customerArabic: json[CustomerFields.customerArabic] as String,
        vatNumber: json[CustomerFields.vatNumber] as String,
        email: json[CustomerFields.email] as String,
        address: json[CustomerFields.address] as String,
        addressArabic: json[CustomerFields.addressArabic] as String,
        city: json[CustomerFields.city] as String,
        cityArabic: json[CustomerFields.cityArabic] as String,
        state: json[CustomerFields.state] as String,
        stateArabic: json[CustomerFields.stateArabic] as String,
        country: json[CustomerFields.country] as String,
        countryArabic: json[CustomerFields.countryArabic] as String,
        poBox: json[CustomerFields.poBox] as String,
      );
}
