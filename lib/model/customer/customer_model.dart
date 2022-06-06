import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

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

@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    @JsonKey(name: '_id') final int? id,
    required final String customerType,
    company,
    companyArabic,
    customer,
    customerArabic,
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
    poBox,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);
}
