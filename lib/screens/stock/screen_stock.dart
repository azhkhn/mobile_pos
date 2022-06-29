// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/db/db_functions/brand/brand_database.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sub_category/sub_category_db.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/stock/widgets/stock_filter_bottom_sheet.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';

import '../../core/utils/device/device.dart';
import '../../core/utils/converters/converters.dart';

class ScreenStock extends StatelessWidget {
  ScreenStock({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final CategoryDatabase categoryDB = CategoryDatabase.instance;
  final SubCategoryDatabase subCategoryDB = SubCategoryDatabase.instance;
  final BrandDatabase brandDB = BrandDatabase.instance;
  final ItemMasterDatabase itemMasterDB = ItemMasterDatabase.instance;

  //========== Value Notifiers ==========
  static final ValueNotifier<List<dynamic>> itemsNotifier = ValueNotifier([]);

  //========== TextEditing Controllers ==========
  static final TextEditingController _productController = TextEditingController();

  //========== FutureBuilder ModelClass by Integer ==========
  int? _builderModel;

//========== Lists ==========
  List categories = [], subCategories = [], brands = [], itemsList = [];

//========== FutureBuilder Database ==========
  final Future<List<dynamic>>? futureGrid = ItemMasterDatabase.instance.getAllItems();

//========== Orientation Mode ==========
  final bool isVertical = OrientationMode.deviceMode == OrientationMode.verticalMode;

  @override
  Widget build(BuildContext context) {
    log('ScreenStock => Build() Called!');
    _builderModel = null;

    return Scaffold(
      appBar: isVertical
          ? AppBarWidget(
              title: 'Stock',
            )
          : null,
      backgroundColor: kBackgroundGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isVertical ? 5.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //========== Get All Products Search Field ==========
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 9,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
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
                                  _builderModel = null;
                                  if (itemsList.isNotEmpty) {
                                    itemsNotifier.value = itemsList;
                                  } else {
                                    itemsList = await itemMasterDB.getAllItems();
                                    itemsNotifier.value = itemsList;
                                  }
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Search product by name/code',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!'))),
                      suggestionsCallback: (pattern) async {
                        return itemMasterDB.getProductSuggestions(pattern);
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
                      onSuggestionSelected: (ItemMasterModel selectedItem) async {
                        _productController.text = selectedItem.itemName;
                        _builderModel = null;
                        itemsNotifier.value = [selectedItem];

                        log(selectedItem.itemName);
                      },
                    ),
                  ),

                  kWidth5,
                  //========== Barcode Scanner Button ==========
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
                        onPressed: () async => await onBarcodeScan(),
                        icon: const Icon(Icons.qr_code, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),

              !isVertical ? kHeight5 : kNone,

              //==================== Quick Filter Buttons ====================
              Padding(
                padding: isVertical ? const EdgeInsets.symmetric(vertical: 5.0) : const EdgeInsets.only(bottom: 5),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: CustomMaterialBtton(
                            color: Colors.blue,
                            onPressed: () async {
                              _builderModel = 0;

                              if (categories.isNotEmpty) {
                                log('loading Categories..');
                                itemsNotifier.value = categories;
                                itemsNotifier.notifyListeners();
                              } else {
                                log('fetching Categories..');
                                categories = await categoryDB.getAllCategories();
                                itemsNotifier.value = categories;
                                itemsNotifier.notifyListeners();
                              }
                            },
                            padding: kPadding0,
                            fontSize: 12,
                            buttonText: 'Categories'),
                      ),
                      kWidth5,
                      Expanded(
                        flex: 5,
                        child: CustomMaterialBtton(
                            onPressed: () async {
                              _builderModel = 1;
                              if (subCategories.isNotEmpty) {
                                itemsNotifier.value = subCategories;
                              } else {
                                subCategories = await subCategoryDB.getAllSubCategories();
                                itemsNotifier.value = subCategories;
                              }
                            },
                            padding: kPadding0,
                            fontSize: 12,
                            color: Colors.orange,
                            buttonText: 'Sub Categories'),
                      ),
                      kWidth5,
                      Expanded(
                        flex: 3,
                        child: CustomMaterialBtton(
                          onPressed: () async {
                            _builderModel = 2;
                            if (brands.isNotEmpty) {
                              itemsNotifier.value = brands;
                            } else {
                              brands = await brandDB.getAllBrands();
                              itemsNotifier.value = brands;
                            }
                          },
                          padding: kPadding0,
                          color: Colors.indigo,
                          fontSize: 12,
                          buttonText: 'Brands',
                        ),
                      ),
                      kWidth5,
                      Expanded(
                        flex: 2,
                        child: MaterialButton(
                          onPressed: () async {
                            _productController.clear();
                            _builderModel = null;

                            if (itemsList.isNotEmpty) {
                              itemsNotifier.value = itemsList;
                            } else {
                              itemsList = await itemMasterDB.getAllItems();
                              itemsNotifier.value = itemsList;
                            }
                          },
                          color: Colors.blue,
                          child: const Icon(
                            Icons.rotate_left,
                            color: kWhite,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //==================== Product Listing Grid ====================
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: FutureBuilder(
                      future: futureGrid,
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        log('Future Builder() => Called!');

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                          default:
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error Occured!'),
                              );
                            }
                            if (snapshot.hasData) {
                              itemsNotifier.value = snapshot.data!;
                            } else {
                              itemsNotifier.value = [];
                            }

                            return snapshot.hasData && itemsNotifier.value.isNotEmpty
                                ? ValueListenableBuilder(
                                    valueListenable: itemsNotifier,
                                    builder: (context, List<dynamic> itemList, _) {
                                      log('Total Products == ${itemsNotifier.value.length}');

                                      return itemsNotifier.value.isNotEmpty
                                          ? GridView.builder(
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: isVertical ? 4 : 6,
                                                childAspectRatio: (1 / .9),
                                              ),
                                              itemCount: itemList.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () async {
                                                    if (_builderModel == 0) {
                                                      log(itemList[index].category);
                                                      final categoryId = itemList[index].id;
                                                      _builderModel = null;
                                                      itemsNotifier.value = await itemMasterDB.getProductByCategoryId(categoryId);
                                                    } else if (_builderModel == 1) {
                                                      log(itemList[index].subCategory);
                                                      final subCategoryId = itemList[index].id;
                                                      _builderModel = null;
                                                      itemsNotifier.value = await itemMasterDB.getProductBySubCategoryId(subCategoryId);
                                                    } else if (_builderModel == 2) {
                                                      log(itemList[index].brand);
                                                      final brandId = itemList[index].id;
                                                      _builderModel = null;
                                                      itemsNotifier.value = await itemMasterDB.getProductByBrandId(brandId);
                                                    } else {
                                                      // //===================================== if the Product Already Added ====================================
                                                      //                                         isProductAlreadyAdded(itemList, index);
                                                      // //=======================================================================================================

                                                      //                                         SaleSideWidget.selectedProductsNotifier
                                                      //                                             .notifyListeners();

                                                      //                                         SaleSideWidget
                                                      //                                             .totalQuantityNotifier.value++;
                                                    }
                                                  },
                                                  child: Card(
                                                    elevation: 10,
                                                    child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                                        child: _builderModel == null
                                                            ? Column(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: Center(
                                                                      child: Text(
                                                                        itemList[index].itemName,
                                                                        textAlign: TextAlign.center,
                                                                        softWrap: true,
                                                                        style: isVertical ? kItemsTextStyle : kItemsTextStyleStock,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      'Qty : ' + itemList[index].openingStock,
                                                                      textAlign: TextAlign.center,
                                                                      style: isVertical ? kItemsTextStyle : kItemsTextStyleStock,
                                                                      maxLines: 1,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      'Cost : ' + Converter.currency.format(num.tryParse(itemList[index].itemCost)),
                                                                      style: isVertical ? kItemsTextStyle : kItemsTextStyleStock,
                                                                      maxLines: 1,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      'Price : ' +
                                                                          Converter.currency.format(num.tryParse(itemList[index].sellingPrice)),
                                                                      style: isVertical ? kItemsTextStyle : kItemsTextStyleStock,
                                                                      maxLines: 1,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    _builderModel == 0
                                                                        ? itemList[index].category
                                                                        : _builderModel == 1
                                                                            ? itemList[index].subCategory
                                                                            : _builderModel == 2
                                                                                ? itemList[index].brand
                                                                                : '',
                                                                    textAlign: TextAlign.center,
                                                                    softWrap: true,
                                                                    style: isVertical ? kItemsTextStyle : kItemsTextStyleStock,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: _builderModel == 0 && itemList[index].category.toString().contains(' ')
                                                                        ? 2
                                                                        : _builderModel == 1 && itemList[index].subCategory.toString().contains(' ')
                                                                            ? 2
                                                                            : _builderModel == 2 && itemList[index].brand.toString().contains(' ')
                                                                                ? 2
                                                                                : 1,
                                                                  ),
                                                                ],
                                                              )),
                                                  ),
                                                );
                                              },
                                            )
                                          : const Center(
                                              child: Text('No Item Found!'),
                                            );
                                    },
                                  )
                                : const Center(
                                    child: Text('No Item Found!'),
                                  );
                        }
                      },
                    )),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Card(
        elevation: 10,
        child: Container(
          height: 35,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(
              color: kBlack.withOpacity(.1),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (ctx) {
                        return StockFilterBottomSheet(isVertical: isVertical);
                      });
                },
                icon: const Icon(Icons.filter_list),
                label: const Text('Filter', style: TextStyle(fontSize: 17))),
          ),
        ),
      ),
    );
  }

  void onFilter(BuildContext context, int? categoryId, int? brandId, String? stock, GlobalKey<FormState> formKey) async {
    List<ItemMasterModel> _items = [];
    final List<ItemMasterModel> _results = [];
    final _formState = formKey.currentState!;
    _builderModel = null;
    log('categoryId = $categoryId');
    log('brandId = $brandId');
    log('stock = $stock');

    if (_formState.validate()) {
      log('valid');
    } else {
      log('invalid');
    }
    if (_formState.validate()) {
      //========== Stock Base Filtering ==========
      if (stock != null) {
        if (categoryId != null) {
          _items = await itemMasterDB.getProductByCategoryId(categoryId);
        } else if (brandId != null) {
          _items = await itemMasterDB.getProductByBrandId(brandId);
        } else if (itemsList.isNotEmpty) {
          _items = itemsList as List<ItemMasterModel>;
        } else {
          _items = await itemMasterDB.getAllItems();
        }

        if (stock == 'Negative Stock') {
          for (var i = 0; i < _items.length; i++) {
            final qty = num.tryParse(_items[i].openingStock);
            if (qty! < 0) {
              _results.add(_items[i]);
            }
          }
          itemsNotifier.value = _results;
        } else if (stock == 'Zero Stock') {
          for (var i = 0; i < _items.length; i++) {
            final qty = num.tryParse(_items[i].openingStock);
            if (qty! == 0) {
              _results.add(_items[i]);
            }
          }
          itemsNotifier.value = _results;
        } else if (stock == 'Expired Stock') {
          for (var i = 0; i < _items.length; i++) {
            final DateTime? expDate = DateTime.tryParse(_items[i].expiryDate!);

            if (expDate != null) {
              if (expDate.isBefore(DateTime.now())) {
                _results.add(_items[i]);
              }
            }
          }
          itemsNotifier.value = _results;
        }
        //========== Category Base Filtering ==========
      } else if (categoryId != null) {
        itemsNotifier.value = await itemMasterDB.getProductByCategoryId(categoryId);
        //========== Brand Base Filtering ==========
      } else if (brandId != null) {
        itemsNotifier.value = await itemMasterDB.getProductByBrandId(brandId);
      }

      log('message');
      _productController.clear();
      itemsNotifier.notifyListeners();
      Navigator.pop(context);
    }
  }

  Future onBarcodeScan() async {
    final String _scanResult;

    try {
      _scanResult = await FlutterBarcodeScanner.scanBarcode(
        scannerColor,
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      log('Item Code == $_scanResult');
      if (_scanResult == '-1') return;
      final String _itemCode = _scanResult;
      _builderModel = null;
      itemsNotifier.value = await itemMasterDB.getProductByItemCode(_itemCode);
    } on PlatformException catch (_) {
      log('Failed to get Platform version!');
    } catch (e) {
      log(e.toString());
    }
  }
}
