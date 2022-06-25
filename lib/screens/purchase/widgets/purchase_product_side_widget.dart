// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/vat/vat.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_side_widget.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../db/db_functions/brand/brand_database.dart';
import '../../../db/db_functions/category/category_db.dart';
import '../../../db/db_functions/item_master/item_master_database.dart';
import '../../../db/db_functions/sub_category/sub_category_db.dart';
import '../../../model/item_master/item_master_model.dart';
import '../../../widgets/button_widgets/material_button_widget.dart';

class PurchaseProductSideWidget extends StatefulWidget {
  const PurchaseProductSideWidget({
    this.isVertical = false,
    Key? key,
  }) : super(key: key);

  final bool isVertical;

  //========== Value Notifiers ==========
  static final ValueNotifier<List<dynamic>> itemsNotifier = ValueNotifier([]);

  @override
  State<PurchaseProductSideWidget> createState() => _PurchaseProductSideWidgetState();
}

class _PurchaseProductSideWidgetState extends State<PurchaseProductSideWidget> {
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

  //========== TextEditing Controllers ==========
  final _productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _builderModel = null;
    return SizedBox(
      width: widget.isVertical ? double.infinity : _screenSize.width / 1.9,
      height: widget.isVertical ? _screenSize.height / 2.25 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //==================== Search & Filter ====================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Get All Products Search Field ==========
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
                              padding: kClearTextIconPadding,
                              child: InkWell(
                                child: const Icon(Icons.clear, size: 15),
                                onTap: () async {
                                  _productController.clear();
                                  _builderModel = null;
                                  futureGrid = ItemMasterDatabase.instance.getAllItems();
                                  if (itemsList.isNotEmpty) {
                                    PurchaseProductSideWidget.itemsNotifier.value = itemsList;
                                  } else {
                                    itemsList = await itemMasterDB.getAllItems();
                                    PurchaseProductSideWidget.itemsNotifier.value = itemsList;
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
                        _productController.clear();
                        Future<List<dynamic>> future() async => [selectedItem];
                        futureGrid = future();
                        _builderModel = null;
                        PurchaseProductSideWidget.itemsNotifier.value = [selectedItem];

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
              kHeight5,
              widget.isVertical
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //========== Get All Supplier Search Field ==========
                        Flexible(
                          flex: 6,
                          child: TypeAheadField(
                            minCharsForSuggestions: 0,
                            debounceDuration: const Duration(milliseconds: 500),
                            hideSuggestionsOnKeyboardHide: true,
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: PurchaseSideWidget.supplierController,
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
                                      onTap: () {
                                        PurchaseSideWidget.supplierNotifier.value = null;
                                        PurchaseSideWidget.supplierController.clear();
                                      },
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: 'Supplier',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: const OutlineInputBorder(),
                                )),
                            noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No supplier Found!'))),
                            suggestionsCallback: (pattern) async {
                              return SupplierDatabase.instance.getSupplierSuggestions(pattern);
                            },
                            itemBuilder: (context, SupplierModel suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion.supplierName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kText_10_12,
                                ),
                              );
                            },
                            onSuggestionSelected: (SupplierModel suggestion) {
                              PurchaseSideWidget.supplierController.text = suggestion.supplierName;
                              PurchaseSideWidget.supplierNotifier.value = suggestion;
                              log(suggestion.supplierName);
                            },
                          ),
                        ),
                        kWidth5,

                        Flexible(
                          flex: 4,
                          child: TextFeildWidget(
                            labelText: 'Ref No',
                            isHint: true,
                            isDense: true,
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            suffixIcon: Padding(
                              padding: kClearTextIconPadding,
                              child: InkWell(
                                child: const Icon(Icons.clear, size: 15),
                                onTap: () {
                                  PurchaseSideWidget.referenceNumberController.clear();
                                },
                              ),
                            ),
                            controller: PurchaseSideWidget.referenceNumberController,
                            textStyle: const TextStyle(fontSize: 12),
                            inputBorder: const OutlineInputBorder(),
                            textInputType: TextInputType.text,
                            constraints: const BoxConstraints(maxHeight: 40),
                            hintStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.all(10),
                            errorStyle: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        kWidth5,

                        //========== View supplier Button ==========
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
                                onPressed: () {
                                  if (PurchaseSideWidget.supplierNotifier.value != null) {
                                    log('${PurchaseSideWidget.supplierNotifier}');

                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: kTransparentColor,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                        builder: (context) => DismissibleWidget(
                                              context: context,
                                              child: CustomBottomSheetWidget(
                                                model: PurchaseSideWidget.supplierNotifier.value,
                                                supplier: true,
                                              ),
                                            ));
                                  } else {
                                    kSnackBar(context: context, content: 'Please select any Supplier to show details!');
                                  }
                                },
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                  size: 25,
                                )),
                          ),
                        ),

                        //========== Add supplier Button ==========
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
                                  // OrientationMode.isLandscape = false;
                                  // await OrientationMode.toPortrait();
                                  final addedSupplier = await Navigator.pushNamed(context, routeAddSupplier, arguments: true);

                                  if (addedSupplier is SupplierModel) {
                                    PurchaseSideWidget.supplierController.text = addedSupplier.contactName;
                                    PurchaseSideWidget.supplierNotifier.value = addedSupplier;
                                    log(addedSupplier.supplierName);
                                  }

                                  // await OrientationMode.toLandscape();
                                },
                                icon: const Icon(
                                  Icons.person_add,
                                  color: Colors.blue,
                                  size: 25,
                                )),
                          ),
                        ),
                      ],
                    )
                  : kNone,
            ],
          ),

          //==================== Quick Filter Buttons ====================
          Padding(
            padding: widget.isVertical ? const EdgeInsets.symmetric(vertical: 5.0) : const EdgeInsets.only(bottom: 5),
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
                            PurchaseProductSideWidget.itemsNotifier.value = categories;
                            PurchaseProductSideWidget.itemsNotifier.notifyListeners();
                          } else {
                            log('fetching Categories..');
                            categories = await categoryDB.getAllCategories();
                            PurchaseProductSideWidget.itemsNotifier.value = categories;
                            PurchaseProductSideWidget.itemsNotifier.notifyListeners();
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
                            PurchaseProductSideWidget.itemsNotifier.value = subCategories;
                          } else {
                            subCategories = await subCategoryDB.getAllSubCategories();
                            PurchaseProductSideWidget.itemsNotifier.value = subCategories;
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
                          PurchaseProductSideWidget.itemsNotifier.value = brands;
                        } else {
                          brands = await brandDB.getAllBrands();
                          PurchaseProductSideWidget.itemsNotifier.value = brands;
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
                          PurchaseProductSideWidget.itemsNotifier.value = itemsList;
                        } else {
                          itemsList = await itemMasterDB.getAllItems();
                          PurchaseProductSideWidget.itemsNotifier.value = itemsList;
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
            flex: widget.isVertical ? 1 : 1,
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
                            child: Text('No Item Found!'),
                          );
                        }
                        if (snapshot.hasData) {
                          if (PurchaseProductSideWidget.itemsNotifier.value.isEmpty) {
                            PurchaseProductSideWidget.itemsNotifier.value = snapshot.data!;
                          }
                        } else {
                          PurchaseProductSideWidget.itemsNotifier.value = [];
                        }

                        return ValueListenableBuilder(
                          valueListenable: PurchaseProductSideWidget.itemsNotifier,
                          builder: (context, List<dynamic> itemList, _) {
                            log('Total Products == ${PurchaseProductSideWidget.itemsNotifier.value.length}');

                            return PurchaseProductSideWidget.itemsNotifier.value.isNotEmpty
                                ? GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: widget.isVertical ? 4 : 5,
                                      childAspectRatio: (1 / .75),
                                    ),
                                    itemCount: itemList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          if (_builderModel == 0) {
                                            log(itemList[index].category);
                                            final categoryId = itemList[index].id;
                                            _builderModel = null;
                                            PurchaseProductSideWidget.itemsNotifier.value = await itemMasterDB.getProductByCategoryId(categoryId);
                                          } else if (_builderModel == 1) {
                                            log(itemList[index].subCategory);
                                            final subCategoryId = itemList[index].id;
                                            _builderModel = null;
                                            PurchaseProductSideWidget.itemsNotifier.value =
                                                await itemMasterDB.getProductBySubCategoryId(subCategoryId);
                                          } else if (_builderModel == 2) {
                                            log(itemList[index].brand);
                                            final brandId = itemList[index].id;
                                            _builderModel = null;
                                            PurchaseProductSideWidget.itemsNotifier.value = await itemMasterDB.getProductByBrandId(brandId);
                                          } else {
//===================================== if the Product Already Added ====================================
                                            isProductAlreadyAdded(itemList, index);
//=======================================================================================================

                                            PurchaseSideWidget.selectedProductsNotifier.notifyListeners();

                                            PurchaseSideWidget.totalQuantityNotifier.value++;
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
                                                          child: Text(
                                                            itemList[index].itemName ?? '',
                                                            textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            style: kItemsTextStyle,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            'Qty : ' + itemList[index].openingStock,
                                                            textAlign: TextAlign.center,
                                                            style: kItemsTextStyle,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            Converter.currency.format(num.tryParse(itemList[index].itemCost)),
                                                            style: kItemsTextStyle,
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
                                                          style: kItemsTextStyle,
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
  void isProductAlreadyAdded(itemList, int index) async {
    final vatMethod = itemList[index].vatMethod;
    final _vat = await VatUtils.instance.getVatById(vatId: itemList[index].vatId);
    log('VAT Method = ' + vatMethod);

    for (var i = 0; i < PurchaseSideWidget.selectedProductsNotifier.value.length; i++) {
      if (PurchaseSideWidget.selectedProductsNotifier.value[i].id == itemList[index].id) {
        final _currentQty = num.tryParse(PurchaseSideWidget.quantityNotifier.value[i].value.text);

        PurchaseSideWidget.quantityNotifier.value[i].text = '${_currentQty! + 1}';

//==================== On Item Quantity Changed ====================
        const PurchaseSideWidget().onItemQuantityChanged(
          PurchaseSideWidget.quantityNotifier.value[i].text,
          PurchaseSideWidget.selectedProductsNotifier.value,
          i,
        );
        return;
      }
    }
    PurchaseSideWidget.selectedProductsNotifier.value.add(itemList[index]);
    PurchaseSideWidget.vatRateNotifier.value.add(_vat.rate);

    final String _itemCost = vatMethod == 'Inclusive'
        ? Converter.amountRounderString(const PurchaseSideWidget().getExclusiveAmount(itemCost: itemList[index].itemCost, vatRate: _vat.rate))
        : Converter.amountRounderString(num.tryParse(itemList[index].itemCost)!);

    PurchaseSideWidget.costNotifier.value.add(TextEditingController(text: _itemCost));

    PurchaseSideWidget.quantityNotifier.value.add(TextEditingController(text: '1'));

    PurchaseSideWidget.subTotalNotifier.value.add(vatMethod == 'Inclusive'
        ? '${const PurchaseSideWidget().getExclusiveAmount(itemCost: itemList[index].itemCost, vatRate: _vat.rate)}'
        : itemList[index].itemCost);

    PurchaseSideWidget.totalItemsNotifier.value++;

    const PurchaseSideWidget().getItemVat(vatMethod: vatMethod, amount: itemList[index].itemCost, vatRate: _vat.rate);
    const PurchaseSideWidget().getTotalAmount();
    const PurchaseSideWidget().getTotalVAT();
    const PurchaseSideWidget().getTotalPayable();
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
      PurchaseProductSideWidget.itemsNotifier.value = await itemMasterDB.getProductByItemCode(_itemCode);
    } on PlatformException catch (_) {
      log('Failed to get Platform version!');
    } catch (e) {
      log(e.toString());
    }

    if (!mounted) return;
  }
}
