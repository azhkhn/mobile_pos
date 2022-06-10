// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:shop_ez/api/invoice/a4/pdf_a4_invoice.dart';
import 'package:shop_ez/api/invoice/receipt/pdf_receipt_invoice.dart';
import 'package:shop_ez/api/invoice/utils/e-invoice_generate.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/core/utils/vat/vat.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/db/db_functions/sales_return/sales_return_items_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/sales_return/sales_return_model.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';

class ScreenSalesInvoice extends StatelessWidget {
  ScreenSalesInvoice({
    Key? key,
    this.salesModel,
    this.salesReturnModal,
    this.isReturn = false,
  }) : super(key: key);

  final SalesModel? salesModel;
  final SalesReturnModal? salesReturnModal;
  final bool isReturn;

  dynamic sale;
  dynamic items;
  BusinessProfileModel? businessProfile;
  CustomerModel? customer;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // businessProfile = await UserUtils.instance.businessProfile;
      // customer = await CustomerDatabase.instance.getCustomerById(sale.customerId);
    });

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Sales Invoice',
        actions: [
          !isReturn
              ? PopupMenuButton(
                  icon: const Icon(Icons.print),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("A4 Invoice"),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("Receipt Invoice"),
                      ),
                    ];
                  },
                  onSelected: (value) async {
                    if (value == 0) {
                      if (isReturn) {
                        final File pdfFile = await PdfSalesInvoice.generate(salesReturnModal: salesReturnModal, isReturn: true);
                        await Printing.layoutPdf(
                            format: PdfPageFormat.a4,
                            name: salesModel != null ? salesModel!.invoiceNumber! : salesReturnModal!.invoiceNumber!,
                            onLayout: (PdfPageFormat format) async => pdfFile.readAsBytes());
                      } else {
                        final File pdfFile = await PdfSalesInvoice.generate(salesModel: salesModel);
                        await Printing.layoutPdf(
                            format: PdfPageFormat.a4,
                            name: salesModel != null ? salesModel!.invoiceNumber! : salesReturnModal!.invoiceNumber!,
                            onLayout: (PdfPageFormat format) async => pdfFile.readAsBytes());
                      }
                    } else if (value == 1) {
                      if (salesModel != null) {
                        final pw.Document? pdfReceipt = await PdfSalesReceipt.generate(salesModel: salesModel);

                        if (pdfReceipt != null) {
                          await Printing.layoutPdf(
                              format: PdfPageFormat.roll80,
                              name: salesModel!.invoiceNumber!,
                              onLayout: (PdfPageFormat format) async => pdfReceipt.save());
                        }
                      }
                    }
                  })
              : IconButton(
                  onPressed: () async {
                    final File pdfFile = await PdfSalesInvoice.generate(salesReturnModal: salesReturnModal, isReturn: true);
                    await Printing.layoutPdf(
                        format: PdfPageFormat.a4,
                        name: salesModel != null ? salesModel!.invoiceNumber! : salesReturnModal!.invoiceNumber!,
                        onLayout: (PdfPageFormat format) async => pdfFile.readAsBytes());
                  },
                  icon: const Icon(Icons.print)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                      future: getDetails(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.done:

                          default:
                            // if (!snapshot.hasData) {
                            //   return const Center(child: Text('Not Found!'));
                            // }

                            return ListView(
                              shrinkWrap: true,
                              children: [
                                buildHeader(businessProfileModel: businessProfile!),
                                kHeight5,
                                buildTitle(businessProfile!, isReturn, sale),
                                kHeight2,
                                buildCustomerInfo(sale, customer!, isReturn),
                                kHeight5,
                                buildInvoice(items),
                                const Divider(),
                                buildTotal(sale),
                              ],
                            );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildHeader({
    required BusinessProfileModel businessProfileModel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: buildEnglishCompanyInfo(businessProfileModel)),
            Expanded(child: SizedBox(height: 40, width: 40, child: Image.file(File(businessProfileModel.logo)))),
            Expanded(child: buildArabicCompanyInfo(businessProfileModel))
          ],
        ),
      ],
    );
  }

  //==================== English Company Info ====================
  static Widget buildEnglishCompanyInfo(BusinessProfileModel business) {
    const kStyle = TextStyle(fontSize: 8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(business.business, textDirection: TextDirection.ltr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        kHeight5,
        Text(business.address, textDirection: TextDirection.ltr, style: kStyle),
        Text('Tel: ${business.phoneNumber}', textDirection: TextDirection.ltr, style: kStyle),
        Text('Email: ${business.email}', textDirection: TextDirection.ltr, style: kStyle),
      ],
    );
  }

  //==================== Arabic Company Info ====================
  static Widget buildArabicCompanyInfo(
    BusinessProfileModel business,
  ) {
    const kStyle = TextStyle(
      fontSize: 8,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(business.businessArabic,
            textAlign: TextAlign.right, textDirection: TextDirection.rtl, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        Text(
          business.addressArabic,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: kStyle,
        ),
        Text(
          'هاتف: ${business.phoneNumber}',
          textDirection: TextDirection.ltr,
          style: kStyle,
        ),
        Text(
          'البريد: ${business.email}',
          textDirection: TextDirection.rtl,
          style: kStyle,
        ),
      ],
    );
  }

  //==================== TAX INVOICE ====================
  static Widget buildTitle(
    BusinessProfileModel business,
    bool isReturn,
    final sale,
  ) {
    const kStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 10);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center, children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                color: Colors.green[300],
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'فاتورة ضريبية TAX INVOICE',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 12,
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // isReturn
                      //     ? SizedBox(
                      //         height: 0.01 * PdfPageFormat.a4.availableWidth)
                      //     : SizedBox(),
                      isReturn
                          ? const Text(
                              ' مبيعات مسترده  SALES RETURN/',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 8,
                                color: kWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : kNone,
                    ],
                  ),

                  // مبيعات مسترده  / SALES RETURN
                )),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 40,
              width: 40,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
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
        ]),
        kHeight5,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(child: Text('VAT Registration Number', textDirection: TextDirection.ltr, textAlign: TextAlign.left, style: kStyle)),
            Expanded(child: Text(business.vatNumber, textDirection: TextDirection.ltr, textAlign: TextAlign.center, style: kStyle)),
            const Expanded(
                child: Text(
              'الضريبي التسجيل رقم',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: kStyle,
            )),
          ],
        ),
      ],
    );
  }

  //==================== Customer Info ====================
  static Widget buildCustomerInfo(final sale, CustomerModel customer, bool isReturn) {
    const kStyle = TextStyle(
      fontSize: 8,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: kGreen)),
          width: double.infinity,
          height: !isReturn ? 110 : 125,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Customer Name :', textDirection: TextDirection.ltr, textAlign: TextAlign.left, style: kStyle),
                        kWidth5,
                        Expanded(child: Text(customer.customer, textDirection: TextDirection.ltr, textAlign: TextAlign.left, style: kStyle)),
                      ],
                    ),
                  ),
                  kWidth5,
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          customer.customerArabic,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: kStyle,
                        )),
                        kWidth5,
                        const Text(
                          'العميل :',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: kStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Customer Address :', textDirection: TextDirection.ltr, textAlign: TextAlign.left, style: kStyle),
                      kWidth5,
                      Expanded(
                          child: Text(
                        customer.address ?? '',
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: kStyle,
                        maxLines: 3,
                      )),
                    ],
                  )),
                  customer.addressArabic != null ? kWidth5 : kNone,
                  customer.addressArabic != null
                      ? Expanded(
                          child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              customer.addressArabic ?? '',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: kStyle,
                              maxLines: 3,
                            )),
                            kWidth5,
                            const Text(
                              'عنوان العميل :',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: kStyle,
                            ),
                          ],
                        ))
                      : kNone,
                ],
              ),
              customer.vatNumber!.isNotEmpty
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                              child: Text('Customer VAT Number', textDirection: TextDirection.ltr, textAlign: TextAlign.left, style: kStyle)),
                          Expanded(
                              child: Text(customer.vatNumber ?? '', textDirection: TextDirection.ltr, textAlign: TextAlign.center, style: kStyle)),
                          const Expanded(
                              child: Text(
                            'الرقم الضريبي :',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: kStyle,
                          )),
                        ],
                      ),
                    )
                  : kNone,
              const Divider(color: kGrey),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(' : رقم الفاتورة /Invoice', textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: kStyle),
                          kWidth5,
                          Text(
                            sale.invoiceNumber!,
                            textAlign: TextAlign.left,
                            style: kStyle,
                          ),
                        ],
                      ),
                    ),
                    kWidth5,
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(' : التاريخ /Date', textDirection: TextDirection.rtl, style: kStyle),
                          kWidth5,
                          Text(
                            Converter.dateTimeFormatAmPm.format(DateTime.parse(sale.dateTime)),
                            style: kStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isReturn ? kHeight5 : kNone,
              isReturn
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(' : رقم فاتورة المبيعات المرتجعة /Original Invoice No',
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: kStyle),
                                kWidth5,
                                Expanded(
                                    child: Text(
                                  sale.originalInvoiceNumber,
                                  textAlign: TextAlign.right,
                                  style: kStyle,
                                )),
                              ],
                            ),
                          ),
                          kWidth10,
                          const Spacer()
                        ],
                      ),
                    )
                  : kNone,
            ],
          ),
        )
      ],
    );
  }

  //==================== Invoice Table ====================
  static Widget buildInvoice(
    List<dynamic> saleItems,
  ) {
    final headers = [
      'S.No',
      'Description / وصف',
      'Quantity\n كمية',
      'Unit Price\n سعر الوحدة',
      'VAT Amount\n قيمة الضريبة',
      'Total Amount\n المبلغ الإجمالي',
    ];
    int i = 0;
    final List<List<String>> data = saleItems.map((item) {
      i++;
      final num exclusiveAmount;
      if (item.vatMethod == 'Inclusive') {
        exclusiveAmount = VatCalculator.getExclusiveAmount(sellingPrice: item.unitPrice, vatRate: item.vatRate);
      } else {
        exclusiveAmount = num.parse(item.unitPrice);
      }

      // final totalAmount = num.parse(item.subTotal) + num.parse(item.vatTotal);

      return [
        '$i',
        '${item.productName}',
        '${item.quantity}',
        Converter.currency.format(exclusiveAmount).replaceAll('₹', ''),
        Converter.currency.format(num.parse(item.vatTotal)).replaceAll('₹', ''),
        Converter.currency.format(num.parse(item.subTotal)).replaceAll('₹', ''),
      ];
    }).toList();

    log('items == ' + data.toString());

    final int tableLength = data.length + 1;
    log('Table Length == $tableLength');

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: null,
      columnWidths: const {
        0: FractionColumnWidth(0.10),
        1: FractionColumnWidth(0.30),
        2: FractionColumnWidth(0.10),
        3: FractionColumnWidth(0.15),
        4: FractionColumnWidth(0.15),
        5: FractionColumnWidth(0.15),
      },
      children: List<TableRow>.generate(tableLength, (index) {
        return index == 0
            ? TableRow(
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                children: List.generate(
                  headers.length,
                  (_i) => Text(
                    headers[_i],
                    textAlign: _i == 0 || _i == 1 ? TextAlign.left : TextAlign.right,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
            : TableRow(
                children: List.generate(
                headers.length,
                (_i) => Text(
                  data[index - 1][_i],
                  textAlign: _i == 0 || _i == 1 ? TextAlign.left : TextAlign.right,
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ));
      }),
    );
  }

  //==================== Total Section ====================
  static Widget buildTotal(final sale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildFooter(),
            ],
          ),
        ),
        kWidth5,
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(
                title: ' / Total Amount  المبلغ اإلجمالي ',
                value: Converter.currency.format(num.parse(sale.subTotal)).replaceAll("₹", ''),
                unite: true,
              ),
              buildText(
                title: ' / Discount  مقدار الخصم',
                value: Converter.currency.format(num.parse(sale.discount.isEmpty ? '0' : sale.discount)).replaceAll("₹", ''),
                unite: true,
              ),
              buildText(
                title: ' / Vat Amount  قيمة الضريبة',
                value: Converter.currency.format(num.parse(sale.vatAmount)).replaceAll("₹", ''),
                unite: true,
              ),
              const Divider(height: 5, thickness: 1),
              buildText(
                title: ' / Grand Total  المجموع الكل',
                value: Converter.currency.format(num.parse(sale.grantTotal)).replaceAll("₹", ''),
                unite: true,
              ),
              buildText(
                title: ' / Paid Amount  المبلغ المدفوع',
                value: Converter.currency.format(num.parse(sale.paid)).replaceAll("₹", ''),
                unite: true,
              ),
              buildText(
                title: ' / Balance  مقدار وسطي',
                value: Converter.currency.format(num.parse(sale.balance)).replaceAll("₹", ''),
                unite: true,
              ),
              kHeight1,
              Container(height: 1, color: Colors.grey[400]),
              kHeight1,
              Container(height: 1, color: Colors.grey[400]),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildSimpleText(
                  title: 'استلمت من قبل',
                  value: 'Received By',
                ),
              ),
              kWidth5,
              Expanded(
                child: buildSimpleText(
                  title: 'تمت الموافقة عليه من قبل',
                  value: 'Approved By',
                ),
              ),
              kWidth5,
              Expanded(
                child: buildSimpleText(
                  title: 'أعدت بواسطة',
                  value: 'Prepared By',
                ),
              ),
            ],
          ),
          // SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

//==================== TextField ====================
  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ??
        const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 9,
        );

    return SizedBox(
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

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 5);
    const eStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 7);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: style, textDirection: TextDirection.rtl),
        FittedBox(
          child: Text(value, style: eStyle),
        )
      ],
    );
  }

  Future<void>? getDetails() async {
    if (isReturn) {
      log('Sales Return');
      sale = salesReturnModal!;
      items = await SalesReturnItemsDatabase.instance.getSalesReturnItemBySaleReturnId(sale.id!);
    } else {
      log('Sale');
      sale = salesModel!;
      items = await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);
    }

    businessProfile = await UserUtils.instance.businessProfile;
    customer = await CustomerDatabase.instance.getCustomerById(sale!.customerId);
  }
}
