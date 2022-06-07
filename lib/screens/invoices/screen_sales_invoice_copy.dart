// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/api/invoice/utils/e-invoice_generate.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/user/user.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/model/business_profile/business_profile_model.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/sales_return/sales_return_model.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';

class ScreenSalesInvoice2 extends StatelessWidget {
  ScreenSalesInvoice2({
    Key? key,
    this.salesModal,
    this.salesReturnModal,
    this.isReturn = false,
  }) : super(key: key);

  final SalesModel? salesModal;
  final SalesReturnModal? salesReturnModal;
  final bool isReturn;
  BusinessProfileModel? businessProfile;
  CustomerModel? customer;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // businessProfile = await UserUtils.instance.businessProfile;
      // customer = await CustomerDatabase.instance.getCustomerById(sale.customerId);
    });

    return Scaffold(
      appBar: AppBarWidget(title: 'Sales Invoice'),
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
                                buildTitle(businessProfile!, isReturn, salesModal),
                                kHeight2,
                                buildCustomerInfo(salesModal, customer!, isReturn),
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
            Expanded(
              child: buildEnglishCompanyInfo(businessProfileModel),
            ),
            Expanded(child: SizedBox(height: 40, width: 40, child: Image.file(File(businessProfileModel.logo)))),
            Expanded(
              child: buildArabicCompanyInfo(businessProfileModel),
            )
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
        Text(business.businessArabic, textDirection: TextDirection.rtl, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        Text(
          business.addressArabic,
          textDirection: TextDirection.rtl,
          style: kStyle,
        ),
        Text(
          'هاتف: ${business.phoneNumber}',
          textDirection: TextDirection.rtl,
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
                              ' مبيعات مسترده / SALES RETURN  ',
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
                    invoiceTotal: Converter.amountRounder(num.parse(sale.grantTotal)),
                    vatTotal: Converter.amountRounder(num.parse(sale.vatAmount))),
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
          height: 100,
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
                          textAlign: TextAlign.left,
                          style: kStyle,
                        )),
                        kWidth5,
                        const Text(
                          'العميل :',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.left,
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
                              textAlign: TextAlign.left,
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
                            textAlign: TextAlign.left,
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
                          const Text(' : رقم الفاتورة Invoice/', textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: kStyle),
                          kWidth5,
                          Expanded(
                              child: Text(
                            sale.invoiceNumber!,
                            textAlign: TextAlign.left,
                            style: kStyle,
                          )),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Row(
                        children: [
                          const Text(' : التاريخ Date/', textDirection: TextDirection.rtl, textAlign: TextAlign.right, style: kStyle),
                          kWidth5,
                          Expanded(
                              flex: 2,
                              child: Text(
                                Converter.dateTimeFormatAmPm.format(DateTime.parse(sale.dateTime)),
                                textAlign: TextAlign.left,
                                style: kStyle,
                              )),
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
                                const Text(' : رقم فاتورة المبيعات المرتجعة Original Invoice No/',
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

  Future<void>? getDetails() async {
    businessProfile = await UserUtils.instance.businessProfile;
    customer = await CustomerDatabase.instance.getCustomerById(salesModal!.customerId);
  }
}
