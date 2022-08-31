// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/db/db_functions/item_master/item_master_database.dart';
import 'package:mobile_pos/model/item_master/item_master_model.dart';
import 'package:mobile_pos/screens/item_master/widgets/item_card_widget.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';

class ScreenBarcode extends StatelessWidget {
  ScreenBarcode({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController productController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<int?> itemIdNotifier = ValueNotifier(null);
  final ValueNotifier<List<ItemMasterModel>> productsNotifier = ValueNotifier([]);

  //==================== List Items ====================
  List<ItemMasterModel> itemsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Barcode Generator'),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              //==================== Search & Filter ====================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Get All Suppliers Search Field ==========
                  Flexible(
                    flex: 8,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: productController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            suffixIcon: Padding(
                              padding: kClearTextIconPadding,
                              child: InkWell(
                                child: const Icon(Icons.clear, size: 15),
                                onTap: () async {
                                  productController.clear();

                                  if (itemsList.isNotEmpty) {
                                    productsNotifier.value = itemsList;
                                  } else {
                                    productsNotifier.value = await ItemMasterDatabase.instance.getAllItems();
                                  }
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Product',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!'))),
                      suggestionsCallback: (pattern) async {
                        return itemsList
                            .where((item) {
                              return item.itemName.toLowerCase().contains(pattern.toLowerCase()) || item.itemCode.contains(pattern);
                            })
                            .toList()
                            .take(10);
                      },
                      itemBuilder: (context, ItemMasterModel suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.itemName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kText_10_12,
                          ),
                        );
                      },
                      onSuggestionSelected: (ItemMasterModel suggestion) {
                        productsNotifier.value = [suggestion];
                      },
                    ),
                  ),
                  kWidth5,

                  //========== Add Product Button ==========
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      child: IconButton(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          maxHeight: 30,
                        ),
                        onPressed: () async {
                          final ItemMasterModel? addedProduct =
                              await Navigator.pushNamed(context, routeAddProduct, arguments: {'from': true}) as ItemMasterModel;

                          if (addedProduct != null) {
                            productsNotifier.value.add(addedProduct);
                            itemsList.add(addedProduct);
                            productsNotifier.notifyListeners();
                          }
                        },
                        icon: const Icon(
                          Icons.playlist_add,
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              kHeight10,

              //========== List Items ==========
              Expanded(
                child: FutureBuilder(
                    future: ItemMasterDatabase.instance.getAllItems(),
                    builder: (context, AsyncSnapshot<List<ItemMasterModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Products is Empty!'));
                          }
                          productsNotifier.value = snapshot.data!;

                          if (itemsList.isEmpty) {
                            itemsList = snapshot.data!;
                          }
                          return ValueListenableBuilder(
                              valueListenable: productsNotifier,
                              builder: (context, List<ItemMasterModel> items, _) {
                                return items.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: items.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: ItemCardWidget(
                                              index: index,
                                              product: items[index],
                                            ),
                                            onTap: () async {
                                              // Preview Barcode
                                              await barcodePreview(context, product: items[index]);
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Products is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }

//==================== Barcode Preview ====================
  Future<void> barcodePreview(BuildContext context, {required ItemMasterModel product}) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Preview!', style: kText12, textAlign: TextAlign.center),
            kHeight5,
            //===== Barcode Preview =====
            Card(
              shadowColor: mainColor,
              elevation: 5,
              child: Padding(
                padding: kPadding10,
                child: BarcodeWidget(
                  data: product.itemCode,
                  barcode: Barcode.code128(),
                  width: 200,
                  height: 100,
                  textPadding: 5,
                ),
              ),
            ),
            //===== Item Name & Item Price =====
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Name: ', style: kText12Lite),
                      Text(
                        product.itemName,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Price: ', style: kText12Lite),
                      FittedBox(
                        child: Text(
                          Converter.currency.format(num.parse(product.sellingPrice)),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton.icon(
            onPressed: () async => await printBarcode(itemCode: product.itemCode),
            icon: const Icon(Icons.print_outlined),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }

  //========== Print Barcode ==========
  Future<void> printBarcode({required String itemCode}) async {
    final pw.Document pdf = pw.Document();

    //========== Pdf Generation ==========
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(30),
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (context) {
          return pw.BarcodeWidget(
            data: itemCode,
            barcode: Barcode.code128(),
            width: PdfPageFormat.inch * 1.469,
            height: PdfPageFormat.inch * 1.02,
            textPadding: 5,
          );
        },
      ),
    );

    //========== Pdf Print ==========
    await Printing.layoutPdf(
      name: 'barcode',
      onLayout: (PdfPageFormat format) async => await pdf.save(),
    );
  }
}
