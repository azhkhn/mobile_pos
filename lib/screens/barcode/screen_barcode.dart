// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenBarcode extends StatefulWidget {
  const ScreenBarcode({Key? key}) : super(key: key);

  @override
  State<ScreenBarcode> createState() => _ScreenBarcodeState();
}

class _ScreenBarcodeState extends State<ScreenBarcode> {
//========== TextEditing Controllers ==========
  final _productController = TextEditingController();
  final List<TextEditingController> _quantityControllers = [];

//========== FocusNodes ==========
  final FocusNode _productFocusNode = FocusNode();

//========== Database Instances ==========
  final ItemMasterDatabase _itemMasterDB = ItemMasterDatabase.instance;

//========== Value Notifiers ==========
  final ValueNotifier<List<ItemMasterModel>> itemNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final bool _isTablet = DeviceUtil.isTablet;
    return Scaffold(
      appBar: AppBarWidget(title: 'Barcode'),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Stack(
            children: [
              Column(
                children: [
                  kHeight10,
                  //==================== Product Search Bar ====================
                  TypeAheadField(
                    minCharsForSuggestions: 0,
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _productController,
                        focusNode: _productFocusNode,
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
                                _productController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Select Product',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: const OutlineInputBorder(),
                        )),
                    noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!'))),
                    suggestionsCallback: (pattern) async {
                      return _itemMasterDB.getProductSuggestions(pattern);
                    },
                    itemBuilder: (context, ItemMasterModel suggestion) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          suggestion.itemName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: _isTablet ? 12 : 10),
                        ),
                      );
                    },
                    onSuggestionSelected: (ItemMasterModel selectedItem) async {
                      _productController.clear();

                      for (var i = 0; i < itemNotifier.value.length; i++) {
                        if (selectedItem.id == itemNotifier.value[i].id) {
                          final num qty = num.parse(_quantityControllers[i].text);
                          _quantityControllers[i].text = (qty + 1).toString();
                          return;
                        }
                      }
                      _quantityControllers.add(TextEditingController(text: '1'));
                      itemNotifier.value.add(selectedItem);
                      itemNotifier.notifyListeners();

                      log(selectedItem.itemName);
                    },
                  ),
                  kHeight10,

                  //========== ListTile Header ==========
                  ListTile(
                      title: Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Product',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Quantity',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.delete,
                      )),

                  const Divider(height: 1, color: kBlack),

                  Flexible(
                    child: ValueListenableBuilder(
                        valueListenable: itemNotifier,
                        builder: (context, List<ItemMasterModel> items, _) {
                          return ListView.separated(
                              itemBuilder: (ctx, index) {
                                final item = items[index];
                                return Card(
                                  elevation: 10,
                                  child: ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              item.itemName,
                                              style: const TextStyle(fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                          kWidth5,
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                              color: Colors.white,
                                              height: 30,
                                              alignment: Alignment.topCenter,
                                              child: TextFormField(
                                                controller: _quantityControllers[index],
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                                ),
                                                style: TextStyle(fontSize: DeviceUtil.isTablet ? 10 : 10, color: kBlack),
                                                onChanged: (value) {},
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.black26,
                                        constraints: const BoxConstraints(maxWidth: 30),
                                        onPressed: () {
                                          _quantityControllers.removeAt(index);
                                          itemNotifier.value.removeAt(index);
                                          itemNotifier.notifyListeners();
                                        },
                                      )),
                                );
                              },
                              separatorBuilder: (ctx, index) => const SizedBox(),
                              itemCount: itemNotifier.value.length);
                        }),
                  )
                ],
              ),

              //==================== Print Button ====================
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: MaterialButton(
                      onPressed: () => onPrint(),
                      color: mainColor,
                      minWidth: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.print_outlined,
                            color: kWhite,
                          ),
                          kWidth5,
                          Text(
                            'Print',
                            style: TextStyle(color: kWhite),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void onPrint() {
    final items = itemNotifier.value;
    final quantities = _quantityControllers;
    num totalQuantity = 0;

    if (items.isNotEmpty) {
      for (var i = 0; i < quantities.length; i++) {
        totalQuantity += num.parse(quantities[i].value.text);
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          // contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Preview!',
                style: kText12,
              ),
              kHeight5,
              Card(
                shadowColor: mainColor,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BarcodeWidget(
                              data: items.first.itemCode,
                              barcode: Barcode.code128(),
                              width: 200,
                              height: 100,
                              textPadding: 5,
                            ),
                            kHeight5,
                            Text(
                              items.first.itemName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            FittedBox(
                              child: Text(
                                Converter.currency.format(num.parse(items.first.sellingPrice)),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              kHeight15,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Total Products',
                            style: kText12Bold,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const Text(
                        ' :  ',
                        style: kText12Bold,
                        textAlign: TextAlign.start,
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          '${items.length}',
                          style: kText12Bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Total Quantity',
                            style: kText12Bold,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const Text(
                        ' :  ',
                        style: kText12Bold,
                        textAlign: TextAlign.start,
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          '$totalQuantity',
                          style: kText12Bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.print_outlined),
              label: const Text('Print'),
            ),
          ],
        ),
      );
    } else {
      _productFocusNode.requestFocus();
      kSnackBar(
        context: context,
        content: 'Please select any Product!',
      );
    }
  }
}
