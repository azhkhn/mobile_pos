// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/device/device.dart';
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
  final List<TextEditingController> _itemsControllers = [];

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
                  TypeAheadField(
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: false,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _productController,
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
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              child: const Icon(Icons.clear),
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
                    noItemsFoundBuilder: (context) => const SizedBox(
                        height: 50,
                        child: Center(child: Text('No Product Found!'))),
                    suggestionsCallback: (pattern) async {
                      return _itemMasterDB.getProductSuggestions(pattern);
                    },
                    itemBuilder: (context, ItemMasterModel suggestion) {
                      return ListTile(
                        title: AutoSizeText(
                          suggestion.itemName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: _isTablet ? 12 : 10),
                          minFontSize: 10,
                          maxFontSize: 12,
                        ),
                      );
                    },
                    onSuggestionSelected: (ItemMasterModel suggestion) async {
                      final itemId = suggestion.id;
                      _productController.clear();

                      final _selectedItem =
                          await _itemMasterDB.getProductById(itemId!);

                      for (var i = 0; i < itemNotifier.value.length; i++) {
                        if (_selectedItem.first.id ==
                            itemNotifier.value[i].id) {
                          final num qty = num.parse(_itemsControllers[i].text);
                          _itemsControllers[i].text = (qty + 1).toString();
                          return;
                        }
                      }
                      _itemsControllers.add(TextEditingController(text: '1'));
                      itemNotifier.value.add(_selectedItem.first);
                      itemNotifier.notifyListeners();

                      log(suggestion.itemName);
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
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.delete,
                      )),

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
                                              style:
                                                  const TextStyle(fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                          kWidth5,
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              color: Colors.white,
                                              height: 30,
                                              alignment: Alignment.topCenter,
                                              child: TextFormField(
                                                controller:
                                                    _itemsControllers[index],
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10),
                                                ),
                                                style: TextStyle(
                                                    fontSize:
                                                        DeviceUtil.isTablet
                                                            ? 10
                                                            : 10,
                                                    color: kBlack),
                                                onChanged: (value) {},
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.black26,
                                        constraints:
                                            const BoxConstraints(maxWidth: 30),
                                        onPressed: () {
                                          _itemsControllers.removeAt(index);
                                          itemNotifier.value.removeAt(index);
                                          itemNotifier.notifyListeners();
                                        },
                                      )),
                                );
                              },
                              separatorBuilder: (ctx, index) =>
                                  const SizedBox(),
                              itemCount: itemNotifier.value.length);
                        }),
                  )
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: MaterialButton(
                      onPressed: () {},
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
}
