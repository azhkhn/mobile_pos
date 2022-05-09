import 'package:shop_ez/model/invoice/customer_invoice_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

class InvoiceModel {
  final SalesModel info;
  final List<InvoiceItemModel> items;

  const InvoiceModel({
    required this.info,
    required this.items,
  });
}

@freezed
class InvoiceItemModel with _$InvoiceItemModel {
  const factory InvoiceItemModel({
    required String no,
    required String description,
    required String quantity,
    required String unitPrice,
    required String subTotal,
    required String vatPercentage,
    required String vatAmount,
    required String totalAmount,
  }) = _InvoiceItem;

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);
}
