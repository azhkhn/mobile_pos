import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:shop_ez/api/invoice/pdf_action.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';

class PdfInvoice {
  static Future<File> generate(SalesModel sale) async {
    final pdf = Document();

    final items =
        await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);

    pdf.addPage(MultiPage(
      build: (context) {
        return [
          buildTitle(),
          buildInvoice(items),
        ];
      },
    ));

    return PdfAction.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TAX INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(List<SalesItemsModel> saleItems) {
    final headers = [
      'S.No',
      'Description',
      'Quantity',
      'Unit Price',
      'Sub Total',
      'VAT %',
      'VAT Amount',
      'Total Amount'
    ];
    int i = 0;
    final data = saleItems.map((item) {
      i++;
      return [
        '$i',
        item.productName,
        item.quantity,
        item.unitPrice,
        item.subTotal,
        item.vatPercentage,
        item.vatTotal,
        '${num.parse(item.subTotal) + num.parse(item.vatTotal)}'
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerLeft,
        8: Alignment.centerLeft,
      },
    );
  }
}
