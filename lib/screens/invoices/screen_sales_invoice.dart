// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shop_ez/api/invoice/pdf_invoice.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';

class ScreenSalesInvoice extends StatelessWidget {
  const ScreenSalesInvoice({
    Key? key,
    required this.sale,
  }) : super(key: key);

  final SalesModel sale;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<File?> pdfFile = ValueNotifier(null),
        pdfPreview = ValueNotifier(null);
    late PDFViewController pdfViewController;
    ValueNotifier<int> page = ValueNotifier(0);

    ValueNotifier<int> indexPage = ValueNotifier(0);

    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales Invoice',
          actions: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ValueListenableBuilder(
                  valueListenable: page,
                  builder: (context, int totalPage, __) {
                    log('total page $totalPage');

                    return totalPage >= 2
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${indexPage.value + 1} of $totalPage'),
                              kWidth5,
                              InkWell(
                                onTap: () {
                                  final newPage = indexPage.value == 0
                                      ? totalPage
                                      : indexPage.value - 1;
                                  pdfViewController.setPage(newPage);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 18,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  final newPage =
                                      indexPage.value == totalPage + -1
                                          ? 0
                                          : indexPage.value + 1;
                                  pdfViewController.setPage(newPage);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox();
                  }),
            )),
            IconButton(
                onPressed: () async {
                  if (pdfFile.value != null) {
                    await Printing.layoutPdf(
                        format: PdfPageFormat.a4,
                        name: sale.invoiceNumber!,
                        usePrinterSettings: true,
                        onLayout: (PdfPageFormat format) async =>
                            pdfFile.value!.readAsBytes());
                  }
                },
                icon: const Icon(Icons.print)),
          ],
        ),
        body: Stack(
          children: [
            FutureBuilder(
                future: createInvoice(),
                builder: (context, AsyncSnapshot<List<File>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:

                    default:
                      if (!snapshot.hasData) {
                        return const Center(child: Text('Not Found!'));
                      }
                      pdfFile.value = snapshot.data!.first;
                      pdfPreview.value = snapshot.data!.last;

                      return Stack(
                        children: [
                          ValueListenableBuilder(
                              valueListenable: page,
                              builder: (context, _, __) {
                                return PDFView(
                                  filePath: pdfPreview.value!.path,
                                  swipeHorizontal: true,
                                  onRender: (totalPage) {
                                    page.value = totalPage!;
                                    page.notifyListeners();
                                  },
                                  onViewCreated: (controller) =>
                                      pdfViewController = controller,
                                  onPageChanged: (index, _) {
                                    indexPage.value = index!;
                                    page.notifyListeners();
                                  },
                                );
                              }),
                        ],
                      );
                  }
                }),
          ],
        ));
  }

  //========== Create Invoice ==========
  Future<List<File>> createInvoice() async {
    final pdfFiles = await PdfInvoice.generate(sale);

    return pdfFiles;
  }
}
