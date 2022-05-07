import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_return_model.freezed.dart';
part 'sales_return_model.g.dart';

@freezed
class SalesReturnModal with _$SalesReturnModal {
  const factory SalesReturnModal({
    @JsonKey(name: '_id') int? id,
    int? saleId,
    String? invoiceNumber,
    required String? originalInvoiceNumber,
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
  }) = _SalesReturnModal;

  factory SalesReturnModal.fromJson(Map<String, dynamic> json) =>
      _$SalesReturnModalFromJson(json);
}

const String tableSalesReturn = 'sales_return';

class SalesReturnFields {
  static const id = '_id';
  static const saleId = 'saleId';
  static const invoiceNumber = 'invoiceNumber';
  static const originalInvoiceNumber = 'originalInvoiceNumber';
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
  static const paymentType = 'paymentType';
  static const salesStatus = 'salesStatus';
  static const paymentStatus = 'paymentStatus';
  static const createdBy = 'createdBy';
}
