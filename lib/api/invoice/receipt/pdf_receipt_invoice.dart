// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:shop_ez/api/invoice/utils/pdf_action.dart';
// import 'package:shop_ez/core/utils/user/user.dart';
// import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
// import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
// import 'package:shop_ez/db/db_functions/sales_return/sales_return_items_database.dart';
// import 'package:shop_ez/model/business_profile/business_profile_model.dart';

// import 'package:shop_ez/model/sales/sales_model.dart';
// import 'package:shop_ez/model/sales_return/sales_return_model.dart';

// class PdfSalesReceipt {
//   static Future<File> generate(
//       {SalesModel? salesModel,
//       SalesReturnModal? salesReturnModal,
//       bool isReturn = false}) async {
//     final pdf = pw.Document();
//     final dynamic sale;
//     final dynamic items;

//     if (isReturn) {
//       log('Sales Return');
//       sale = salesReturnModal!;
//       items = await SalesReturnItemsDatabase.instance
//           .getSalesReturnItemBySaleReturnId(sale.id!);
//     } else {
//       log('Sale');
//       sale = salesModel!;
//       items = await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);
//     }

//     ByteData _bytes = await rootBundle.load('assets/images/invoice_logo.png');
//     final logoBytes = _bytes.buffer.asUint8List();
//     pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

//     // final emojiFont = await PdfGoogleFonts.notoColorEmoji();
//     final arabicFont = await PdfGoogleFonts.iBMPlexSansArabicBold();

//     final businessProfile = await UserUtils.instance.businessProfile;
//     final customer =
//         await CustomerDatabase.instance.getCustomerById(sale.customerId);

//     //========== Pdf Preview ==========
//     pdf.addPage(pw.Page(
//       orientation: pw.PageOrientation.portrait,
//       pageFormat: PdfPageFormat.roll80,
//       theme: pw.ThemeData.withFont(
//         base: arabicFont,
//       ),
//       build: (context) {
//         return builder(business: businessProfile);
//       },
//     ));

//     final pdfFile =
//         await PdfAction.saveDocument(name: 'sale_receipt.pdf', pdf: pdf);

//     return pdfFile;
//   }

//   static pw.Widget builder({required BusinessProfileModel business}) {
//     return pw.Column(children: [
//       pw.Column(
//         mainAxisAlignment: pw.MainAxisAlignment.start,
//         crossAxisAlignment: pw.CrossAxisAlignment.center,
//         children: [
//           pw.SizedBox(
//             width: double.infinity,
//             child: pw.Text(business.business,
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(
//                   fontSize: 9,
//                   fontWeight: pw.FontWeight.bold,
//                 )),
//           ),
//           pw.SizedBox(
//             width: double.infinity,
//             child: pw.Text('VAT NO. ' + business.vatNumber,
//                 textAlign: pw.TextAlign.center,
//                 style: const pw.TextStyle(
//                   fontSize: 6,
//                 )),
//           ),
//           pw.SizedBox(
//             width: double.infinity,
//             child: pw.Text('PH NO. ' + business.phoneNumber,
//                 textAlign: pw.TextAlign.center,
//                 style: const pw.TextStyle(
//                   fontSize: 6,
//                 )),
//           ),
//           pw.SizedBox(height: .1 * PdfPageFormat.cm),
//           pw.SizedBox(
//             width: double.infinity,
//             child: pw.Text('TAX INVOICE',
//                 textAlign: pw.TextAlign.center,
//                 style: pw.TextStyle(
//                   fontSize: 10,
//                   fontWeight: pw.FontWeight.bold,
//                 )),
//           ),
//         ],
//       ),
//     ]);
//   }
// }
