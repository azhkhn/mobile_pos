// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../db/db_functions/brand/brand_database.dart';
import '../../../db/db_functions/category/category_db.dart';
import '../../../db/db_functions/item_master/item_master_database.dart';
import '../../../db/db_functions/sub_category/sub_category_db.dart';
import '../../../model/item_master/item_master_model.dart';
import '../../../widgets/button_widgets/material_button_widget.dart';

class ProductSideWidget extends StatefulWidget {
  const ProductSideWidget({
    Key? key,
  }) : super(key: key);

  //========== Value Notifiers ==========
  static final ValueNotifier<List<dynamic>> itemsNotifier = ValueNotifier([]);

  @override
  State<ProductSideWidget> createState() => _ProductSideWidgetState();
}

class _ProductSideWidgetState extends State<ProductSideWidget> {
  //========== Database Instances ==========
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final itemMasterDB = ItemMasterDatabase.instance;

  //========== FutureBuilder Database ==========
  Future<List<dynamic>>? futureGrid = ItemMasterDatabase.instance.getAllItems();

  //========== FutureBuilder ModelClass by Integer ==========
  int? _builderModel;

  //========== Lists ==========
  List categories = [], subCategories = [], brands = [], itemsList = [];

  //========== MediaQuery Screen Size ==========
  late Size _screenSize;

  //========== Device Type ==========
  late bool _isTablet;

  //========== TextEditing Controllers ==========
  final _productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _isTablet = DeviceUtil.isTablet;
    _screenSize = MediaQuery.of(context).size;
    _builderModel = null;
    return SizedBox(
      width: _screenSize.width / 1.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //==================== Get All Products Search Field ====================
          Row(
            mainAxisSize: MainAxisSize.min,
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
                              futureGrid =
                                  ItemMasterDatabase.instance.getAllItems();
                              if (itemsList.isNotEmpty) {
                                ProductSideWidget.itemsNotifier.value =
                                    itemsList;
                              } else {
                                itemsList = await itemMasterDB.getAllItems();
                                ProductSideWidget.itemsNotifier.value =
                                    itemsList;
                              }
                            },
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Search product by name/code',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: const OutlineInputBorder(),
                      )),
                  noItemsFoundBuilder: (context) => const SizedBox(
                      height: 50,
                      child: Center(child: Text('No Product Found!'))),
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
                  onSuggestionSelected: (ItemMasterModel selectedItem) async {
                    _productController.text = selectedItem.itemName;
                    Future<List<dynamic>> future() async => [selectedItem];
                    futureGrid = future();
                    _builderModel = null;
                    ProductSideWidget.itemsNotifier.value = [selectedItem];
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

          //==================== Quick Filter Buttons ====================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: CustomMaterialBtton(
                    buttonColor: Colors.blue,
                    onPressed: () async {
                      _builderModel = 0;

                      if (categories.isNotEmpty) {
                        ProductSideWidget.itemsNotifier.value = categories;
                      } else {
                        categories = await categoryDB.getAllCategories();
                        ProductSideWidget.itemsNotifier.value = categories;
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
                        ProductSideWidget.itemsNotifier.value = subCategories;
                      } else {
                        subCategories =
                            await subCategoryDB.getAllSubCategories();
                        ProductSideWidget.itemsNotifier.value = subCategories;
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
                      ProductSideWidget.itemsNotifier.value = brands;
                    } else {
                      brands = await brandDB.getAllBrands();
                      ProductSideWidget.itemsNotifier.value = brands;
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
                      ProductSideWidget.itemsNotifier.value = itemsList;
                    } else {
                      itemsList = await itemMasterDB.getAllItems();
                      ProductSideWidget.itemsNotifier.value = itemsList;
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
                          ProductSideWidget.itemsNotifier.value =
                              snapshot.data!;
                        } else {
                          ProductSideWidget.itemsNotifier.value = [];
                        }

                        return snapshot.hasData &&
                                ProductSideWidget.itemsNotifier.value.isNotEmpty
                            ? ValueListenableBuilder(
                                valueListenable:
                                    ProductSideWidget.itemsNotifier,
                                builder: (context, List<dynamic> itemList, _) {
                                  log('Total Products == ${ProductSideWidget.itemsNotifier.value.length}');

                                  return ProductSideWidget
                                          .itemsNotifier.value.isNotEmpty
                                      ? GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            childAspectRatio: (1 / .75),
                                          ),
                                          itemCount: itemList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                if (_builderModel == 0) {
                                                  log(itemList[index].category);
                                                  final category =
                                                      itemList[index].category;
                                                  _builderModel = null;
                                                  ProductSideWidget
                                                          .itemsNotifier.value =
                                                      await itemMasterDB
                                                          .getProductByCategory(
                                                              category);
                                                } else if (_builderModel == 1) {
                                                  log(itemList[index]
                                                      .subCategory);
                                                  final subCategory =
                                                      itemList[index]
                                                          .subCategory;
                                                  _builderModel = null;
                                                  ProductSideWidget
                                                          .itemsNotifier.value =
                                                      await itemMasterDB
                                                          .getProductBySubCategory(
                                                              subCategory);
                                                } else if (_builderModel == 2) {
                                                  log(itemList[index].brand);
                                                  final brand =
                                                      itemList[index].brand;
                                                  _builderModel = null;
                                                  ProductSideWidget
                                                          .itemsNotifier.value =
                                                      await itemMasterDB
                                                          .getProductByBrand(
                                                              brand);
                                                } else {
//===================================== if the Product Already Added ====================================
                                                  isProductAlreadyAdded(
                                                      itemList, index);
//=======================================================================================================

                                                  SaleSideWidget
                                                      .selectedProductsNotifier
                                                      .notifyListeners();

                                                  SaleSideWidget
                                                      .totalQuantityNotifier
                                                      .value++;
                                                }
                                              },
                                              child: Card(
                                                elevation: 10,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 5.0),
                                                    child: _builderModel == null
                                                        ? Column(
                                                            children: [
                                                              Expanded(
                                                                flex: 4,
                                                                child:
                                                                    AutoSizeText(
                                                                  itemList[index]
                                                                          .itemName ??
                                                                      '',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          _isTablet
                                                                              ? 10
                                                                              : 7),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  minFontSize:
                                                                      7,
                                                                  maxFontSize:
                                                                      10,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    AutoSizeText(
                                                                  'Qty : ' +
                                                                      itemList[
                                                                              index]
                                                                          .openingStock,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          _isTablet
                                                                              ? 10
                                                                              : 7),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      7,
                                                                  maxFontSize:
                                                                      10,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    AutoSizeText(
                                                                  Converter
                                                                      .currency
                                                                      .format(num.tryParse(
                                                                          itemList[index]
                                                                              .sellingPrice)),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          _isTablet
                                                                              ? 10
                                                                              : 7),
                                                                  maxLines: 1,
                                                                  minFontSize:
                                                                      7,
                                                                  maxFontSize:
                                                                      10,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              AutoSizeText(
                                                                _builderModel ==
                                                                        0
                                                                    ? itemList[
                                                                            index]
                                                                        .category
                                                                    : _builderModel ==
                                                                            1
                                                                        ? itemList[index]
                                                                            .subCategory
                                                                        : _builderModel ==
                                                                                2
                                                                            ? itemList[index].brand
                                                                            : '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        _isTablet
                                                                            ? 10
                                                                            : 8),
                                                                minFontSize: 8,
                                                                maxFontSize: 10,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: _builderModel ==
                                                                            0 &&
                                                                        itemList[index]
                                                                            .category
                                                                            .toString()
                                                                            .contains(
                                                                                ' ')
                                                                    ? 2
                                                                    : _builderModel ==
                                                                                1 &&
                                                                            itemList[index].subCategory.toString().contains(
                                                                                ' ')
                                                                        ? 2
                                                                        : _builderModel == 2 &&
                                                                                itemList[index].brand.toString().contains(' ')
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
    );
  }

// Checking if the product already added then Increasing the Quantity
//====================================================================
  void isProductAlreadyAdded(itemList, int index) {
    final vatMethod = itemList[index].vatMethod;
    log('VAT Method = ' + vatMethod);

    for (var i = 0;
        i < SaleSideWidget.selectedProductsNotifier.value.length;
        i++) {
      if (SaleSideWidget.selectedProductsNotifier.value[i].id ==
          itemList[index].id) {
        final _currentQty =
            num.tryParse(SaleSideWidget.quantityNotifier.value[i].value.text);

        SaleSideWidget.quantityNotifier.value[i].text = '${_currentQty! + 1}';

//==================== On Item Quantity Changed ====================
        const SaleSideWidget().onItemQuantityChanged(
          SaleSideWidget.quantityNotifier.value[i].text,
          SaleSideWidget.selectedProductsNotifier.value,
          i,
        );
        return;
      }
    }
    SaleSideWidget.selectedProductsNotifier.value.add(itemList[index]);

    SaleSideWidget.subTotalNotifier.value.add(vatMethod == 'Inclusive'
        ? '${const SaleSideWidget().getExclusiveAmount(itemList[index].sellingPrice)}'
        : itemList[index].sellingPrice);

    SaleSideWidget.quantityNotifier.value.add(TextEditingController(text: '1'));

    SaleSideWidget.totalItemsNotifier.value++;

    const SaleSideWidget()
        .getItemVat(vatMethod: vatMethod, amount: itemList[index].sellingPrice);
    const SaleSideWidget().getTotalAmount();
    const SaleSideWidget().getTotalVAT();
    const SaleSideWidget().getTotalPayable();
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
      ProductSideWidget.itemsNotifier.value =
          await itemMasterDB.getProductByItemCode(_itemCode);
    } on PlatformException catch (_) {
      log('Failed to get Platform version!');
    } catch (e) {
      log(e.toString());
    }

    if (!mounted) return;
  }
}
