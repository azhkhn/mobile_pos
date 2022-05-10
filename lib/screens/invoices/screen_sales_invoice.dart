import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_ez/api/invoice/pdf_action.dart';
import 'package:shop_ez/api/invoice/pdf_invoice.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';
import '../../../widgets/container/background_container_widget.dart';
import '../../../widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenSalesInvoice extends StatelessWidget {
  const ScreenSalesInvoice({
    Key? key,
    required this.sale,
  }) : super(key: key);

  final SalesModel sale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales Invoice',
        ),
        body: BackgroundContainerWidget(
            child: ItemScreenPaddingWidget(
          child: Stack(
            children: [
              FutureBuilder(
                  future: createInvoice(),
                  builder: (context, AsyncSnapshot<File> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:

                      default:
                        if (!snapshot.hasData) {
                          return const Center(child: Text('Not Found!'));
                        }
                        final pdfFile = snapshot.data!;

                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () => PdfAction.openFile(pdfFile),
                                child: const Text('Print'),
                              ),
                            ),
                          ),
                        );
                    }
                  }),
            ],
          ),
        )));
  }

  //========== Create Invoice ==========
  Future<File> createInvoice() async {
    final pdfFile = await PdfInvoice.generate(sale);

    return pdfFile;
  }
}
