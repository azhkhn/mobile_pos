import 'dart:core';
import 'dart:developer' show log;
import 'dart:typed_data' show ByteData, Uint8List;

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:pdf/pdf.dart' show PdfColors, PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' show PdfGoogleFonts;
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/core/utils/vat/vat.dart';
import 'package:mobile_pos/db/db_functions/customer/customer_database.dart';
import 'package:mobile_pos/db/db_functions/sales/sales_items_database.dart';
import 'package:mobile_pos/db/db_functions/sales_return/sales_return_items_database.dart';
import 'package:mobile_pos/infrastructure/invoice/utils/e-invoice_generate.dart';
import 'package:mobile_pos/model/business_profile/business_profile_model.dart';
import 'package:mobile_pos/model/customer/customer_model.dart';
import 'package:mobile_pos/model/sales/sales_items_model.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import 'package:mobile_pos/model/sales_return/sales_return_model.dart';

class PdfSalesReceipt {
  static Future<pw.Document> generate({SalesModel? salesModel, SalesReturnModal? salesReturnModal, bool isReturn = false}) async {
    // static Future<List<File>> generate({SalesModel? salesModel, SalesReturnModal? salesReturnModal, bool isReturn = false}) async {
    final pw.Document pdf = pw.Document();
    final dynamic sale;
    final dynamic saleItems;

    if (isReturn) {
      log('Sales Return');
      sale = salesReturnModal!;
      saleItems = await SalesReturnItemsDatabase.instance.getSalesReturnItemBySaleReturnId(sale.id!);
    } else {
      log('Sale');
      sale = salesModel!;
      saleItems = await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);
    }

    // final ByteData _bytes = await rootBundle.load('assets/images/invoice_logo.png');
    // final Uint8List logoBytes = _bytes.buffer.asUint8List();
    // final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    // final emojiFont = await PdfGoogleFonts.notoColorEmoji();
    // final arabicFont = await PdfGoogleFonts.iBMPlexSansArabicBold();
    final ByteData data = await rootBundle.load("assets/fonts/ibm_plex_sans_arabic.ttf");
    final pw.Font arabicFont = pw.Font.ttf(data);
    final titleFont = await PdfGoogleFonts.sourceSerifProBold();

    final businessProfile = await UserUtils.instance.businessProfile;
    final customer = await CustomerDatabase.instance.getCustomerById(sale.customerId);

    final Uint8List logoBytes = businessProfile.logo;
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    //========== Pdf Preview ==========
    pdf.addPage(
      pw.Page(
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.roll80,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        build: (context) {
          return builder(
            business: businessProfile,
            titleFont: titleFont,
            logoImage: logoImage,
            sale: sale,
            customer: customer,
            saleItems: saleItems,
            arabicFont: arabicFont,
            isReturn: isReturn,
          );
        },
      ),
    );

    // final pdfFile = await PdfAction.saveDocument(name: 'sale_receipt.pdf', pdf: pdf);

    return pdf;

    // return [pdfFile, pdfFile];
  }

  static pw.Widget builder(
      {required BusinessProfileModel business,
      required pw.Font titleFont,
      required final SalesModel sale,
      required final CustomerModel customer,
      required final List<SalesItemsModel> saleItems,
      required final pw.Font arabicFont,
      required pw.MemoryImage logoImage,
      required final bool isReturn}) {
    return pw.Column(
      children: [
        header(business: business, titleFont: titleFont, isReturn: isReturn, logoImage: logoImage, arabicFont: arabicFont),
        pw.Divider(height: 2 * PdfPageFormat.mm),
        saleInfo(sale: sale, arabicFont: arabicFont),
        customerInfo(customer: customer, arabicFont: arabicFont),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
        buildInvoice(saleItems: saleItems, arabicFont: arabicFont),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
        pw.Divider(height: 2 * PdfPageFormat.mm, thickness: 0.5),
        buildTotal(sale, arabicFont, business),
        pw.Divider(height: 5 * PdfPageFormat.mm, thickness: 0.5),
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Container(
            height: PdfPageFormat.roll57.availableWidth * 0.60,
            width: PdfPageFormat.roll57.availableWidth * 0.60,
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: EInvoiceGenerator.getEInvoiceCode(
                  name: business.business,
                  vatNumber: business.vatNumber,
                  invoiceDate: DateTime.parse(sale.dateTime),
                  invoiceTotal: Converter.amountRounderString(num.parse(sale.grantTotal)),
                  vatTotal: Converter.amountRounderString(num.parse(sale.vatAmount))),
              drawText: false,
            ),
          ),
        ),
        pw.SizedBox(height: 2 * PdfPageFormat.mm),
        pw.Text('Thank you for shopping with us', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal))
      ],
    );
  }

  //========== Header ==========
  static pw.Widget header(
      {required final BusinessProfileModel business,
      required pw.Font titleFont,
      required pw.MemoryImage logoImage,
      required final bool isReturn,
      required pw.Font arabicFont}) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(
            height: 40,
            width: 40,
            child: pw.Image(
              logoImage,
            )),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
        pw.SizedBox(
          width: double.infinity,
          child: pw.Text(business.business,
              textDirection: pw.TextDirection.ltr,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, font: titleFont)),
        ),
        pw.SizedBox(
          width: double.infinity,
          child: pw.Text(
            business.address,
            textDirection: pw.TextDirection.ltr,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(
              fontSize: 7,
            ),
          ),
        ),
        pw.SizedBox(
          width: double.infinity,
          child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text(
              ' ?????????? ????????????????',
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 7,
                font: arabicFont,
              ),
            ),
            pw.Text('VAT NO. ' + business.vatNumber,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 7,
                )),
          ]),
        ),
        pw.SizedBox(
          width: double.infinity,
          child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text(
              ' ????????',
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 7,
                font: arabicFont,
              ),
            ),
            pw.Text('Tel. ' + business.phoneNumber,
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 7,
                )),
          ]),
        ),
        pw.SizedBox(height: 1 * PdfPageFormat.mm),
        pw.SizedBox(
          width: double.infinity,
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                '???????????? ???????????? ??????????????',
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  font: arabicFont,
                ),
              ),
              pw.Text('Simplified Tax Invoice',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ))
            ],
          ),
        ),
        // isReturn
        //     ? pw.SizedBox(
        //         width: double.infinity,
        //         child: pw.Text(
        //           '/ SALES RETURN',
        //           textAlign: pw.TextAlign.center,
        //           style: pw.TextStyle(fontSize: 6, font: titleFont),
        //         ),
        //       )
        //     : pw.SizedBox(),
      ],
    );
  }

  //========== Sale Info ==========
  static pw.Widget saleInfo({required final sale, required final pw.Font arabicFont}) {
    const kStyle = pw.TextStyle(fontSize: 6);
    return pw.Column(children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(children: [
            pw.Text('Inv No / ', style: kStyle),
            pw.Text(
              ': ?????? ????????????????',
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 6,
                font: arabicFont,
              ),
            ),
            pw.SizedBox(width: 1 * PdfPageFormat.mm),
            pw.Text(sale.invoiceNumber!, style: kStyle),
          ]),
          pw.Row(children: [
            pw.Text('Date / ', style: kStyle),
            pw.Text(
              ': ??????????????',
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 6,
                font: arabicFont,
              ),
            ),
            pw.SizedBox(width: 1 * PdfPageFormat.mm),
            pw.Text(Converter.dateTimeFormatAmPm.format(DateTime.parse(sale.dateTime)), style: kStyle),
          ]),
        ],
      ),
    ]);
  }

  //========== Customer Info ==========
  static pw.Widget customerInfo({required final CustomerModel customer, required final pw.Font arabicFont}) {
    final kStyle = pw.TextStyle(fontSize: 6, font: arabicFont);
    return pw.Column(children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                ': ???????????? Customer /',
                style: kStyle,
                textDirection: pw.TextDirection.rtl,
              ),
              pw.SizedBox(width: 1 * PdfPageFormat.mm),
              pw.Text(
                customer.customerArabic,
                style: kStyle,
                textDirection: pw.TextDirection.rtl,
              ),
            ],
          ),
          // pw.Row(
          //   mainAxisAlignment: pw.MainAxisAlignment.start,
          //   crossAxisAlignment: pw.CrossAxisAlignment.start,
          //   children: [
          //     pw.Text(
          //       ': ?????????? ?????????????? VAT No /',
          //       style: kStyle,
          //       textDirection: pw.TextDirection.rtl,
          //     ),
          //     pw.SizedBox(width: 1 * PdfPageFormat.mm),
          //     pw.Text(
          //       customer.vatNumber ?? '',
          //       style: kStyle,
          //       textDirection: pw.TextDirection.rtl,
          //     ),
          //   ],
          // )
        ],
      ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            ': ?????????? ???????????? Customer Address /',
            style: kStyle,
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(width: 1 * PdfPageFormat.mm),
          pw.Flexible(
            child: pw.Text(
              customer.addressArabic.toString().isNotEmpty ? customer.addressArabic : customer.address,
              style: kStyle,
              maxLines: 2,
              textDirection: customer.addressArabic.toString().isNotEmpty ? pw.TextDirection.rtl : pw.TextDirection.ltr,
            ),
          ),
        ],
      ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            ': ?????????? ?????????????? VAT No /',
            style: kStyle,
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(width: 1 * PdfPageFormat.mm),
          pw.Text(
            customer.vatNumber ?? '',
            style: kStyle,
            textDirection: pw.TextDirection.rtl,
          ),
        ],
      ),
    ]);
  }

  //==================== Invoice Table ====================
  static pw.Widget buildInvoice({required final List<dynamic> saleItems, required final pw.Font arabicFont}) {
    //  'VAT\n ??????????????',
    final headers = [
      'S.No',
      '?????? Description / ',
      'Quantity\n ????????',
      'Rate\n ????????',
      'Amount\n ????????????',
    ];
    int i = 0;
    final items = saleItems.map((item) {
      i++;
      final num exclusiveAmount;
      if (item.vatMethod == 'Inclusive') {
        exclusiveAmount = VatCalculator.getExclusiveAmount(sellingPrice: item.unitPrice, vatRate: item.vatRate);
      } else {
        exclusiveAmount = num.parse(item.unitPrice);
      }

      // final totalAmount = num.parse(item.subTotal) + num.parse(item.vatTotal);
      // Converter.currency.format(num.parse(item.vatTotal)).replaceAll('???', ''),

      return [
        '$i',
        item.productName,
        item.quantity,
        Converter.currency.format(exclusiveAmount).replaceAll('???', ''),
        Converter.currency.format(num.parse(item.subTotal)).replaceAll('???', ''),
      ];
    }).toList();

    final List<String> arabicLabel = saleItems.map((item) => item.productNameArabic.toString()).toList();

    final int tableLength = items.length + 1;
    log('Table Length == $tableLength');

    return pw.Table(
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      border: null,
      columnWidths: const {
        0: pw.FractionColumnWidth(0.10),
        1: pw.FractionColumnWidth(0.35),
        2: pw.FractionColumnWidth(0.13),
        3: pw.FractionColumnWidth(0.15),
        4: pw.FractionColumnWidth(0.15),
        5: pw.FractionColumnWidth(0.15),
      },
      children: List<pw.TableRow>.generate(tableLength, (index) {
        final int _itemIndex = index - 1;

        return index == 0
            ?
            //========== Header ==========
            pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    width: .5,
                    color: PdfColors.grey,
                  ),
                ),
                children: List.generate(
                  headers.length,
                  (_i) => pw.Text(
                    headers[_i],
                    textDirection: pw.TextDirection.rtl,
                    textAlign: _i == 0 || _i == 1 ? pw.TextAlign.right : pw.TextAlign.left,
                    style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.normal, font: arabicFont),
                  ),
                ))
            :
            //========== Cell ==========
            pw.TableRow(
                children: List.generate(
                headers.length,
                (_i) => pw.Column(
                  mainAxisSize: pw.MainAxisSize.max,
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      items[_itemIndex][_i],
                      textDirection: pw.TextDirection.ltr,
                      maxLines: 2,
                      textAlign: _i == 0 || _i == 1 ? pw.TextAlign.left : pw.TextAlign.right,
                      style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.normal),
                    ),
                    if (_i == 1)
                      pw.Text(
                        arabicLabel[_itemIndex],
                        textDirection: pw.TextDirection.rtl,
                        maxLines: 2,
                        style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.normal, font: arabicFont),
                      )
                    else
                      pw.Text('')
                  ],
                ),
              ));
      }),
    );

    // return pw.Directionality(
    //     textDirection: pw.TextDirection.rtl,
    //     child: pw.Table.fromTextArray(
    //       headers: headers,
    //       headerPadding: const pw.EdgeInsets.all(1),
    //       cellPadding: const pw.EdgeInsets.all(1),
    //       data: data,
    //       border: null,
    //       headerStyle: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.normal, font: arabicFont),
    //       cellStyle: pw.TextStyle(fontSize: 6.2, fontWeight: pw.FontWeight.normal),
    //       headerDecoration: pw.BoxDecoration(border: pw.Border.all(width: .5)),
    //       cellHeight: 12,
    //       columnWidths: const {
    //         0: pw.FractionColumnWidth(0.10),
    //         1: pw.FractionColumnWidth(0.35),
    //         2: pw.FractionColumnWidth(0.13),
    //         3: pw.FractionColumnWidth(0.15),
    //         4: pw.FractionColumnWidth(0.15),
    //         5: pw.FractionColumnWidth(0.15),
    //       },
    //       headerAlignments: {
    //         0: pw.Alignment.centerLeft,
    //         1: pw.Alignment.centerLeft,
    //         2: pw.Alignment.centerRight,
    //         3: pw.Alignment.centerRight,
    //         4: pw.Alignment.centerRight,
    //         5: pw.Alignment.centerRight,
    //       },
    //       cellAlignments: {
    //         0: pw.Alignment.centerLeft,
    //         1: pw.Alignment.centerLeft,
    //         2: pw.Alignment.centerRight,
    //         3: pw.Alignment.centerRight,
    //         4: pw.Alignment.centerRight,
    //         5: pw.Alignment.centerRight,
    //       },
    //     ));
  }

  //==================== Total Section ====================
  static pw.Widget buildTotal(final sale, pw.Font arabicFont, BusinessProfileModel business) {
    return pw.Container(
        child: pw.Expanded(
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Spacer(),
          pw.SizedBox(width: 1 * PdfPageFormat.mm),
          pw.Expanded(
            flex: 5,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildText(
                  title: ' / Total Amount  ???????????? ???????????????? ',
                  value: Converter.currency.format(num.parse(sale.subTotal)).replaceAll("???", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Discount  ?????????? ??????????',
                  value: Converter.currency.format(num.parse(sale.discount.isEmpty ? '0' : sale.discount)).replaceAll("???", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Vat Amount  ???????? ??????????????',
                  value: Converter.currency.format(num.parse(sale.vatAmount)).replaceAll("???", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                pw.Divider(height: 1 * PdfPageFormat.mm, thickness: .5),
                buildText(
                  title: ' / Grand Total  ?????????????? ????????',
                  value: Converter.currency.format(num.parse(sale.grantTotal)).replaceAll("???", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Paid Amount  ???????????? ??????????????',
                  value: Converter.currency.format(num.parse(sale.paid)).replaceAll("???", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                buildText(
                  title: ' / Balance  ?????????? ????????',
                  value: Converter.currency.format(num.parse(sale.balance)).replaceAll("???", ''),
                  unite: true,
                  arabicFont: arabicFont,
                ),
                pw.SizedBox(height: .5 * PdfPageFormat.mm),
                pw.Divider(height: .5, color: PdfColors.black, thickness: .5),
                pw.SizedBox(height: 0.3 * PdfPageFormat.mm),
                pw.Divider(height: .5, color: PdfColors.black, thickness: .5),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  //==================== TextField ====================
  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    required arabicFont,
    bool unite = false,
  }) {
    final style = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      font: arabicFont,
      fontSize: 8,
    );

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(
              child: pw.Text(
            title,
            textDirection: pw.TextDirection.rtl,
            style: style,
          )),
          pw.Text(value, style: unite ? style : style),
        ],
      ),
    );
  }
}
