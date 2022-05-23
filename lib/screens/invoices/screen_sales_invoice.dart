// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' show PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' show PdfPreview, Printing;
import 'package:shop_ez/api/invoice/a4/pdf_a4_invoice.dart';
import 'package:shop_ez/api/invoice/receipt/pdf_receipt_invoice.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/model/sales_return/sales_return_model.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';

class ScreenSalesInvoice extends StatelessWidget {
  const ScreenSalesInvoice({
    Key? key,
    this.salesModal,
    this.salesReturnModal,
    this.isReturn = false,
  }) : super(key: key);

  final SalesModel? salesModal;
  final SalesReturnModal? salesReturnModal;
  final bool isReturn;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<File?> pdfFile = ValueNotifier(null), pdfPreview = ValueNotifier(null);
    // late PDFViewController pdfViewController;
    // ValueNotifier<int> page = ValueNotifier(0);
    // ValueNotifier<int> indexPage = ValueNotifier(0);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Sales Invoice',
        actions: [
          // Center(
          //     child: Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: ValueListenableBuilder(
          //       valueListenable: page,
          //       builder: (context, int totalPage, __) {
          //         log('total page $totalPage');

          //         return totalPage >= 2
          //             ? Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Text('${indexPage.value + 1} of $totalPage'),
          //                   kWidth5,
          //                   InkWell(
          //                     onTap: () {
          //                       final newPage = indexPage.value == 0
          //                           ? totalPage
          //                           : indexPage.value - 1;
          //                       pdfViewController.setPage(newPage);
          //                     },
          //                     child: const Padding(
          //                       padding: EdgeInsets.all(3.0),
          //                       child: Icon(
          //                         Icons.arrow_back_ios,
          //                         size: 18,
          //                       ),
          //                     ),
          //                   ),
          //                   InkWell(
          //                     onTap: () {
          //                       final newPage =
          //                           indexPage.value == totalPage + -1
          //                               ? 0
          //                               : indexPage.value + 1;
          //                       pdfViewController.setPage(newPage);
          //                     },
          //                     child: const Padding(
          //                       padding: EdgeInsets.all(3.0),
          //                       child: Icon(
          //                         Icons.arrow_forward_ios,
          //                         size: 18,
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )
          //             : const SizedBox();
          //       }),
          // )),
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
                      if (pdfFile.value != null) {
                        await Printing.layoutPdf(
                            format: PdfPageFormat.a4,
                            name: salesModal != null ? salesModal!.invoiceNumber! : salesReturnModal!.invoiceNumber!,
                            onLayout: (PdfPageFormat format) async => pdfFile.value!.readAsBytes());
                      }
                    } else if (value == 1) {
                      if (salesModal != null) {
                        final pw.Document? pdfReceipt = await PdfSalesReceipt.generate(salesModel: salesModal);

                        if (pdfReceipt != null) {
                          await Printing.layoutPdf(
                              format: PdfPageFormat.roll80,
                              name: salesModal!.invoiceNumber!,
                              onLayout: (PdfPageFormat format) async => pdfReceipt.save());
                        }
                      }
                    }
                  })
              : IconButton(
                  onPressed: () async {
                    if (pdfFile.value != null) {
                      await Printing.layoutPdf(
                          format: PdfPageFormat.a4,
                          name: salesModal != null ? salesModal!.invoiceNumber! : salesReturnModal!.invoiceNumber!,
                          usePrinterSettings: true,
                          onLayout: (PdfPageFormat format) async => pdfFile.value!.readAsBytes());
                    }
                  },
                  icon: const Icon(Icons.print)),
        ],
      ),
      body: Center(
        child: FutureBuilder(
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

                  return PdfPreview(
                      useActions: false,
                      canChangeOrientation: true,
                      loadingWidget: const CircularProgressIndicator(),
                      build: (PdfPageFormat format) => pdfPreview.value!.readAsBytes());

                // return ValueListenableBuilder(
                //     valueListenable: page,
                //     builder: (context, _, __) {
                //       // return PDFView(
                //       //   filePath: pdfPreview.value!.path,
                //       //   swipeHorizontal: true,
                //       //   // autoSpacing: false,
                //       //   onRender: (totalPage) {
                //       //     page.value = totalPage!;
                //       //     page.notifyListeners();
                //       //   },
                //       //   onViewCreated: (controller) =>
                //       //       pdfViewController = controller,
                //       //   onPageChanged: (index, _) {
                //       //     indexPage.value = index!;
                //       //     page.notifyListeners();
                //       //   },
                //       // );

                //     });
              }
            }),
      ),
    );
  }

  //========== Create Invoice ==========
  Future<List<File>> createInvoice() async {
    if (isReturn) {
      final pdfFiles = await PdfSalesInvoice.generate(salesReturnModal: salesReturnModal, isReturn: true);
      return pdfFiles;
    } else {
      final pdfFiles = await PdfSalesInvoice.generate(salesModel: salesModal);
      return pdfFiles;
    }
  }
}
