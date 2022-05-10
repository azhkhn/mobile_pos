import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:shop_ez/api/invoice/pdf_action.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/core/utils/vat/vat.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoice {
  static Future<File> generate(SalesModel sale) async {
    final pdf = Document();
    final PdfImage logoImage;

    ByteData _bytes = await rootBundle.load('assets/images/invoice_logo.png');
    final logoBytes = _bytes.buffer.asUint8List();

    logoImage = PdfImage.file(
      pdf.document,
      bytes: logoBytes,
    );

    // final emojiFont = await PdfGoogleFonts.notoColorEmoji();
    final arabicFont = await PdfGoogleFonts.iBMPlexSansArabicBold();

    final businessProfile = await UserUtils.instance.businessProfile;

    final items =
        await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (context) {
        return [
          buildHeader(businessProfile, arabicFont, logoImage),
          SizedBox(height: 3 * PdfPageFormat.cm),
          buildTitle(arabicFont),
          buildInvoice(items),
          Divider(),
          buildTotal(sale, arabicFont),
        ];
      },
      // footer: (context) => buildFooter(invoice),
    ));

    return PdfAction.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(BusinessProfileModel businessProfileModel,
      Font arabicFont, PdfImage logo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildEnglishCompanyInfo(businessProfileModel),
            ),

            // pw.Container(
            //   height: 50,
            //   width: 50,
            //   child: pw.Image(logo)
            // ),

            Expanded(
              child: buildArabicCompanyInfo(businessProfileModel, arabicFont),
            )

            // Container(
            //   height: 50,
            //   width: 50,
            //   child: BarcodeWidget(
            //     barcode: Barcode.qrCode(),
            //     data: sale.info.number,
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     buildCustomerAddress(sale.customer),
        //     buildInvoiceInfo(sale.info),
        //   ],
        // ),
      ],
    );
  }

  static Widget buildEnglishCompanyInfo(BusinessProfileModel business) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(business.business,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(business.address),
          Text('Tel: ${business.phoneNumber}'),
          Text('Email: ${business.email}'),
        ],
      );

  static Widget buildArabicCompanyInfo(
          BusinessProfileModel business, Font arabicFont) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(business.businessArabic,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.bold, font: arabicFont)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(
            business.addressArabic,
            textDirection: TextDirection.rtl,
            style: TextStyle(font: arabicFont),
          ),
          Text(
            'هاتف: ${business.phoneNumber}',
            textDirection: TextDirection.rtl,
            style: TextStyle(font: arabicFont),
          ),
          Text(
            'البريد: ${business.email}',
            textDirection: TextDirection.rtl,
            style: TextStyle(font: arabicFont),
          ),
        ],
      );

  static Widget buildTitle(arabicFont) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              color: PdfColors.green300,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  ' فاتورة ضريبية  TAX INVOICE ',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 16,
                    color: PdfColors.white,
                    fontWeight: FontWeight.bold,
                    font: arabicFont,
                  ),
                ),
              )),
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
      final num exclusiveAmount;
      if (item.vatMethod == 'Inclusive') {
        exclusiveAmount = VatCalculator.getExclusiveAmount(
            sellingPrice: item.unitPrice, vatRate: item.vatRate);
      } else {
        exclusiveAmount = num.parse(item.unitPrice);
      }

      final totalAmount = num.parse(item.subTotal) + num.parse(item.vatTotal);

      return [
        '$i',
        item.productName,
        item.quantity,
        Converter.currency.format(exclusiveAmount).replaceAll('₹', ''),
        Converter.currency.format(num.parse(item.subTotal)).replaceAll('₹', ''),
        item.vatPercentage,
        Converter.currency.format(num.parse(item.vatTotal)).replaceAll('₹', ''),
        Converter.currency.format(totalAmount).replaceAll('₹', ''),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellStyle: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.normal,
      ),
      headerStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: const {
        1: FractionColumnWidth(0.20),
        2: FractionColumnWidth(0.10),
        3: FractionColumnWidth(0.15),
        4: FractionColumnWidth(0.15),
        5: FractionColumnWidth(0.10),
        6: FractionColumnWidth(0.10),
        7: FractionColumnWidth(0.15),
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(SalesModel sale, Font arabicFont) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 4),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: ' / Total Amount  المبلغ اإلجمالي ',
                  value: Converter.currency
                      .format(num.parse(sale.subTotal))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Discount  مقدار الخصم',
                  value: Converter.currency
                      .format(num.parse(
                          sale.discount.isEmpty ? '0' : sale.discount))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Vat Amount  قيمة الضريبة',
                  value: Converter.currency
                      .format(num.parse(sale.vatAmount))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                Divider(),
                buildText(
                  title: ' / Grant Total  المجموع الكل',
                  value: Converter.currency
                      .format(num.parse(sale.grantTotal))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Paid Amount  المبلغ المدفوع',
                  value: Converter.currency
                      .format(num.parse(sale.paid))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Balance  مقدار وسطي',
                  value: Converter.currency
                      .format(num.parse(sale.balance))
                      .replaceAll("₹", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // static Widget buildFooter(SalesModel sale) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Divider(),
  //         SizedBox(height: 2 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Address', value: sale.customerName.address),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Paypal', value: sale.supplier.paymentInfo),
  //       ],
  //     );

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    required arabicFont,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
          font: arabicFont,
        );

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            textDirection: TextDirection.rtl,
            style: style,
          )),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
