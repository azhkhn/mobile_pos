// ignore_for_file: file_names

import 'dart:typed_data' show BytesBuilder, Uint8List;
import 'dart:convert' show Base64Encoder, utf8;

class EInvoiceGenerator {
  static String getEInvoiceCode(
      {required String name,
      required String vatNumber,
      required DateTime invoiceDate,
      required String invoiceTotal,
      required String vatTotal}) {
    // var dateTime = DateTime.now();
    String strInvoiceDate =
        "${invoiceDate.year}-${invoiceDate.month}-${invoiceDate.day} ${invoiceDate.hour}:${invoiceDate.minute}";
    BytesBuilder bytesBuilder = BytesBuilder();
// 1. Seller Name
    bytesBuilder.addByte(1);
    List<int> sellerNameBytes = utf8.encode(name);
    bytesBuilder.addByte(sellerNameBytes.length);
    bytesBuilder.add(sellerNameBytes);
// 2. VAT Registration
    bytesBuilder.addByte(2);
    List<int> vatRegistrationBytes = utf8.encode(vatNumber);
    bytesBuilder.addByte(vatRegistrationBytes.length);
    bytesBuilder.add(vatRegistrationBytes);
// 3. Time
    bytesBuilder.addByte(3);
    List<int> time = utf8.encode(strInvoiceDate);
    bytesBuilder.addByte(time.length);
    bytesBuilder.add(time);
// 4. total with vat
    bytesBuilder.addByte(4);
    List<int> p1 = utf8.encode(invoiceTotal);
    bytesBuilder.addByte(p1.length);
    bytesBuilder.add(p1);
// 5.  vat
    bytesBuilder.addByte(5);
    List<int> p2 = utf8.encode(vatTotal);
    bytesBuilder.addByte(p2.length);
    bytesBuilder.add(p2);
    //
    Uint8List qrCodeAsBytes = bytesBuilder.toBytes();

    Base64Encoder b64Encoder = const Base64Encoder();
    return b64Encoder.convert(qrCodeAsBytes);
  }
}
