import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_model.freezed.dart';
part 'sales_model.g.dart';

@freezed
class SalesModel with _$SalesModel {
  const factory SalesModel({
    @JsonKey(name: '_id') int? id,
    String? invoiceNumber,
    String? returnAmount,
    required int customerId,
    required String dateTime,
    required String customerName,
    required String billerName,
    required String salesNote,
    required String totalItems,
    required String vatAmount,
    required String subTotal,
    required String discount,
    required String grantTotal,
    required String paid,
    required String balance,
    required String paymentType,
    required String salesStatus,
    required String paymentStatus,
    required String createdBy,
  }) = _SalesModel;
  factory SalesModel.fromJson(Map<String, dynamic> json) => _$SalesModelFromJson(json);
}

const String tableSales = 'sales';

class SalesFields {
  static const id = '_id';
  static const invoiceNumber = 'invoiceNumber';
  static const salesNote = 'salesNote';
  static const dateTime = 'dateTime';
  static const customerId = 'customerId';
  static const customerName = 'customerName';
  static const billerName = 'billerName';
  static const totalItems = 'totalItems';
  static const vatAmount = 'vatAmount';
  static const subTotal = 'subTotal';
  static const discount = 'discount';
  static const grantTotal = 'grantTotal';
  static const paid = 'paid';
  static const balance = 'balance';
  static const returnAmount = 'returnAmount';
  static const paymentType = 'paymentType';
  static const salesStatus = 'salesStatus';
  static const paymentStatus = 'paymentStatus';
  static const createdBy = 'createdBy';
}
