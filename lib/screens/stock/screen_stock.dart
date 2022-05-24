// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/brand/brand_database.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sub_category/sub_category_db.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/stock/widgets/stock_filter_bottom_sheet.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';

import '../../core/utils/device/device.dart';
import '../../core/utils/converters/converters.dart';

//========== DropDown Items ==========
const List types = ['Negative Stock', 'Zero Stock', 'Expired Stock'];

class ScreenStock extends StatelessWidget {
  ScreenStock({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final itemMasterDB = ItemMasterDatabase.instance;

  //========== Value Notifiers ==========
  static final ValueNotifier<List<dynamic>> itemsNotifier = ValueNotifier([]);

  //========== TextEditing Controllers ==========
  static final _productController = TextEditingController();

  //========== FutureBuilder ModelClass by Integer ==========
  late int? _builderModel;

//========== Lists ==========
  List categories = [], subCategories = [], brands = [], itemsList = [];

//========== FutureBuilder Database ==========
  Future<List<dynamic>>? futureGrid;

  @override
  Widget build(BuildContext context) {
    log('ScreenStock => Build() Called!');
    _builderModel = null;
    futureGrid = ItemMasterDatabase.instance.getAllItems();
    final bool _isTablet = DeviceUtil.isTablet;
    // Size _screenSize = MediaQuery.of(context).size;

    if (DeviceUtil.isLandscape) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    }
    return Scaffold(
      // appBar: AppBarWidget(
      //   title: 'Stock',
      // ),
      backgroundColor: kBackgroundGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
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
                            _productController.text = suggestion.itemName;
                            _builderModel = null;
                            itemsNotifier.value = await itemMasterDB.getProductById(itemId!);

                            log(suggestion.itemName);
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

                  //==================== Quick Filter Buttons ====================
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: CustomMaterialBtton(
                            buttonColor: Colors.blue,
                            onPressed: () async {
                              _builderModel = 0;

                              if (categories.isNotEmpty) {
                                itemsNotifier.value = categories;
                              } else {
                                categories = await categoryDB.getAllCategories();
                                itemsNotifier.value = categories;
                              }
                            },
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
                            buttonColor: Colors.orange,
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
                          buttonColor: Colors.indigo,
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

                  //==================== Product Listing Grid ====================
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                    child: AutoSizeText('No Item Found!'),
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
                                          log('hellootherererj');
                                          log('Total Products == ${itemsNotifier.value.length}');

                                          return itemsNotifier.value.isNotEmpty
                                              ? GridView.builder(
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 5,
                                                    childAspectRatio: (1 / .75),
                                                  ),
                                                  itemCount: itemList.length,
                                                  itemBuilder: (context, index) {
                                                    return InkWell(
                                                      onTap: () async {
                                                        if (_builderModel == 0) {
                                                          log(itemList[index].category);
                                                          final category = itemList[index].category;
                                                          _builderModel = null;
                                                          itemsNotifier.value = await itemMasterDB.getProductByCategoryId(category);
                                                        } else if (_builderModel == 1) {
                                                          log(itemList[index].subCategory);
                                                          final subCategory = itemList[index].subCategory;
                                                          _builderModel = null;
                                                          itemsNotifier.value = await itemMasterDB.getProductBySubCategoryId(subCategory);
                                                        } else if (_builderModel == 2) {
                                                          log(itemList[index].brand);
                                                          final brand = itemList[index].brand;
                                                          _builderModel = null;
                                                          itemsNotifier.value = await itemMasterDB.getProductByBrandId(brand);
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
                                                                          child: AutoSizeText(
                                                                            itemList[index].itemName,
                                                                            // index == 0
                                                                            //     ? 'Alienware 21x'
                                                                            //     : index == 1
                                                                            //         ? 'ALIENWARE Core i9 10th Gen'
                                                                            //         : index == 2
                                                                            //             ? 'Fried Chicken 6pc'
                                                                            //             : 'Samsung Galaxy S9 Plus - 8GB Ram, 64gb Storage',
                                                                            textAlign: TextAlign.center,
                                                                            softWrap: true,
                                                                            style: TextStyle(fontSize: _isTablet ? 11 : 8),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 2,
                                                                            minFontSize: 8,
                                                                            maxFontSize: 11,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Spacer(),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child: AutoSizeText(
                                                                          'Qty : ' + itemList[index].openingStock,
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontSize: _isTablet ? 11 : 8),
                                                                          maxLines: 1,
                                                                          minFontSize: 8,
                                                                          maxFontSize: 11,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child: AutoSizeText(
                                                                          'Cost : ' +
                                                                              Converter.currency.format(num.tryParse(itemList[index].itemCost)),
                                                                          style: TextStyle(fontSize: _isTablet ? 11 : 8),
                                                                          maxLines: 1,
                                                                          minFontSize: 8,
                                                                          maxFontSize: 11,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child: AutoSizeText(
                                                                          'Price : ' +
                                                                              Converter.currency.format(num.tryParse(itemList[index].sellingPrice)),
                                                                          style: TextStyle(fontSize: _isTablet ? 11 : 8),
                                                                          maxLines: 1,
                                                                          minFontSize: 8,
                                                                          maxFontSize: 11,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                : Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      AutoSizeText(
                                                                        _builderModel == 0
                                                                            ? itemList[index].category
                                                                            : _builderModel == 1
                                                                                ? itemList[index].subCategory
                                                                                : _builderModel == 2
                                                                                    ? itemList[index].brand
                                                                                    : '',
                                                                        textAlign: TextAlign.center,
                                                                        softWrap: true,
                                                                        style: TextStyle(fontSize: _isTablet ? 11 : 9),
                                                                        minFontSize: 9,
                                                                        maxFontSize: 11,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: _builderModel == 0 &&
                                                                                itemList[index].category.toString().contains(' ')
                                                                            ? 2
                                                                            : _builderModel == 1 &&
                                                                                    itemList[index].subCategory.toString().contains(' ')
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
                                                  child: AutoSizeText('No Item Found!'),
                                                );
                                        },
                                      )
                                    : const Center(
                                        child: AutoSizeText('No Item Found!'),
                                      );
                            }
                          },
                        )),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 35,
                    width: 65,
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
                                  return StockFilterBottomSheet();
                                });
                          },
                          icon: const Icon(Icons.filter_list),
                          label: const Text('Filter')),
                    ),
                  ),
                ),
              )
            ],
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
    log(categoryId.toString());
    log(brandId.toString());
    log(stock.toString());
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
