// ignore_for_file: file_names

import 'dart:developer';
import 'dart:typed_data' show BytesBuilder, Uint8List;
import 'dart:convert' show Base64Encoder, utf8;

import 'package:mobile_pos/core/utils/converters/converters.dart';

class EInvoiceGenerator {
  static String getEInvoiceCode({
    required final String name,
    required final String vatNumber,
    required final DateTime invoiceDate,
    required final String invoiceTotal,
    required final String vatTotal,
  }) {
    // final DateTime dateTime = DateTime.now();
    final String strInvoiceDate = Converter.dateFormatEInvoice.format(invoiceDate);
    log('Date == $strInvoiceDate');
    final BytesBuilder bytesBuilder = BytesBuilder();
// 1. Seller Name
    bytesBuilder.addByte(1);
    final List<int> sellerNameBytes = utf8.encode(name);
    bytesBuilder.addByte(sellerNameBytes.length);
    bytesBuilder.add(sellerNameBytes);
// 2. VAT Registration
    bytesBuilder.addByte(2);
    final List<int> vatRegistrationBytes = utf8.encode(vatNumber);
    bytesBuilder.addByte(vatRegistrationBytes.length);
    bytesBuilder.add(vatRegistrationBytes);
// 3. Time
    bytesBuilder.addByte(3);
    final List<int> time = utf8.encode(strInvoiceDate);
    bytesBuilder.addByte(time.length);
    bytesBuilder.add(time);
// 4. total with vat
    bytesBuilder.addByte(4);
    final List<int> p1 = utf8.encode(invoiceTotal);
    bytesBuilder.addByte(p1.length);
    bytesBuilder.add(p1);
// 5.  vat
    bytesBuilder.addByte(5);
    final List<int> p2 = utf8.encode(vatTotal);
    bytesBuilder.addByte(p2.length);
    bytesBuilder.add(p2);
    //
    final Uint8List qrCodeAsBytes = bytesBuilder.toBytes();

    const Base64Encoder b64Encoder = Base64Encoder();
    return b64Encoder.convert(qrCodeAsBytes);
  }
}
