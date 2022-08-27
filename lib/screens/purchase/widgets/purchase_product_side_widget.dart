// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/vat/vat.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_side_widget.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../db/db_functions/brand/brand_database.dart';
import '../../../db/db_functions/category/category_db.dart';
import '../../../db/db_functions/item_master/item_master_database.dart';
import '../../../db/db_functions/sub_category/sub_category_db.dart';
import '../../../model/item_master/item_master_model.dart';
import '../../../widgets/button_widgets/material_button_widget.dart';

//==== ==== ==== ==== ==== Providers ==== ==== ==== ==== ====
final _futureProductsProvider = FutureProvider.autoDispose<List<ItemMasterModel>>((ref) async {
  return ItemMasterDatabase.instance.getAllItems();
});
final _isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

class PurchaseProductSideWidget extends ConsumerWidget {
  PurchaseProductSideWidget({
    this.isVertical = false,
    Key? key,
  }) : super(key: key);

  final bool isVertical;

  //========== Providers ==========
  static final itemsProvider = StateProvider.autoDispose<List<dynamic>>((ref) => []);
  static final builderModelProvider = StateProvider.autoDispose<int?>((ref) => null);

  //========== Lists ==========
  List categories = [], subCategories = [], brands = [], _stableItemsList = [];

  //========== TextEditing Controllers ==========
  final TextEditingController _productController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SizedBox(
        width: isVertical ? double.infinity : SizerUtil.width / 1.9,
        height: isVertical
            ? isThermal
                ? SizerUtil.height / 2.60
                : SizerUtil.height / 2.25
            : double.infinity,
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
                            onTap: () {},
                            style: kText_10_12,
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
                                    ref.read(builderModelProvider.notifier).state = null;
                                    ref.read(itemsProvider.notifier).state = _stableItemsList;
                                  },
                                ),
                              ),
                              contentPadding: EdgeInsets.all(isThermal ? 8 : 10),
                              hintText: 'Search product by name/code',
                              hintStyle: kText_10_12,
                              border: const OutlineInputBorder(),
                            )),
                        noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!'))),
                        suggestionsCallback: (pattern) async {
                          return ItemMasterDatabase.instance.getProductSuggestions(pattern);
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

                          ref.read(builderModelProvider.notifier).state = null;
                          ref.read(itemsProvider.notifier).state = [selectedItem];

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
                            minHeight: 20,
                            maxHeight: 20,
                          ),
                          onPressed: () async => await onBarcodeScan(ref),
                          icon: Icon(
                            Icons.qr_code,
                            color: Colors.blue,
                            size: isThermal ? 22 : 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                kHeight3,
                isVertical
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
                                  style: kText_10_12,
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
                                    contentPadding: EdgeInsets.all(isThermal ? 8 : 10),
                                    hintText: 'Supplier',
                                    hintStyle: kText_10_12,
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
                              textStyle: kText_10_12,
                              inputBorder: const OutlineInputBorder(),
                              textInputType: TextInputType.text,
                              constraints: const BoxConstraints(maxHeight: 40),
                              hintStyle: kText_10_12,
                              contentPadding: EdgeInsets.all(isThermal ? 8 : 10),
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
                                    minHeight: 20,
                                    maxHeight: 20,
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
                                  icon: Icon(
                                    Icons.visibility,
                                    color: Colors.blue,
                                    size: isThermal ? 25 : 25,
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
                                    minHeight: 20,
                                    maxHeight: 20,
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
                                  icon: Icon(
                                    Icons.person_add,
                                    color: Colors.blue,
                                    size: isThermal ? 25 : 25,
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
              padding: isVertical ? const EdgeInsets.only(top: 4.0, bottom: 2.0) : const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                height: isThermal ? 22 : 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: CustomMaterialBtton(
                          color: Colors.blue,
                          onPressed: () async {
                            ref.read(builderModelProvider.notifier).state = 0;

                            if (categories.isNotEmpty) {
                              log('loading Categories..');
                              ref.read(itemsProvider.notifier).state = categories;
                            } else {
                              log('fetching Categories..');
                              categories = await CategoryDatabase.instance.getAllCategories();
                              ref.read(itemsProvider.notifier).state = categories;
                            }
                          },
                          padding: kPadding0,
                          fontSize: 10,
                          buttonText: 'Categories'),
                    ),
                    kWidth5,
                    Expanded(
                      flex: 5,
                      child: CustomMaterialBtton(
                          onPressed: () async {
                            ref.read(builderModelProvider.notifier).state = 1;
                            if (subCategories.isNotEmpty) {
                              ref.read(itemsProvider.notifier).state = subCategories;
                            } else {
                              subCategories = await SubCategoryDatabase.instance.getAllSubCategories();
                              ref.read(itemsProvider.notifier).state = subCategories;
                            }
                          },
                          padding: kPadding0,
                          fontSize: 10,
                          color: Colors.orange,
                          buttonText: 'Sub Categories'),
                    ),
                    kWidth5,
                    Expanded(
                      flex: 3,
                      child: CustomMaterialBtton(
                        onPressed: () async {
                          ref.read(builderModelProvider.notifier).state = 2;
                          if (brands.isNotEmpty) {
                            ref.read(itemsProvider.notifier).state = brands;
                          } else {
                            brands = await BrandDatabase.instance.getAllBrands();
                            ref.read(itemsProvider.notifier).state = brands;
                          }
                        },
                        padding: kPadding0,
                        color: Colors.indigo,
                        fontSize: 10,
                        buttonText: 'Brands',
                      ),
                    ),
                    kWidth5,
                    Expanded(
                      flex: 2,
                      child: MaterialButton(
                        onPressed: () async {
                          _productController.clear();
                          ref.read(builderModelProvider.notifier).state = null;
                          ref.read(itemsProvider.notifier).state = _stableItemsList;
                        },
                        color: Colors.blue,
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Icon(
                            Icons.rotate_left,
                            color: kWhite,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            //========================================                      ========================================
            //======================================== Product Listing Grid ========================================
            //========================================                      ========================================
            Expanded(
              flex: isVertical ? 1 : 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Consumer(
                  builder: (context, ref, _) {
                    final _futureProducts = ref.watch(_futureProductsProvider);

                    return _futureProducts.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Center(child: Text('No items found')),
                        data: (items) {
                          log('Future Provider() => called!');
                          _stableItemsList = items;
                          return Consumer(
                            builder: (context, ref, _) {
                              log('Items Provider() => called!');

                              List<dynamic> _itemList = ref.watch(itemsProvider);

                              final _isLoaded = ref.read(_isLoadedProvider.notifier);
                              // log('isLoaded = ${_isLoaded.state}');

                              if (!_isLoaded.state) {
                                _itemList = items;
                                WidgetsBinding.instance.addPostFrameCallback((_) => _isLoaded.state = true);
                              }

                              return _itemList.isNotEmpty
                                  ? GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: isVertical ? 4 : 5,
                                        childAspectRatio: (1 / .75),
                                      ),
                                      itemCount: _itemList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            final int? _builderModel = ref.read(builderModelProvider);
                                            if (_builderModel == 0) {
                                              log(_itemList[index].category);
                                              final categoryId = _itemList[index].id;
                                              ref.read(builderModelProvider.notifier).state = null;
                                              ref.read(itemsProvider.notifier).state =
                                                  await ItemMasterDatabase.instance.getProductByCategoryId(categoryId);
                                            } else if (_builderModel == 1) {
                                              log(_itemList[index].subCategory);
                                              final subCategoryId = _itemList[index].id;
                                              ref.read(builderModelProvider.notifier).state = null;
                                              ref.read(itemsProvider.notifier).state =
                                                  await ItemMasterDatabase.instance.getProductBySubCategoryId(subCategoryId);
                                            } else if (_builderModel == 2) {
                                              log(_itemList[index].brand);
                                              final brandId = _itemList[index].id;
                                              ref.read(builderModelProvider.notifier).state = null;
                                              ref.read(itemsProvider.notifier).state = await ItemMasterDatabase.instance.getProductByBrandId(brandId);
                                            } else {
                                              //===================================== if the Product Already Added ====================================
                                              isProductAlreadyAdded(ref, _itemList, index);
                                              //=======================================================================================================

                                              PurchaseSideWidget.totalQuantityNotifier.value++;
                                            }
                                          },
                                          child: Card(
                                            elevation: 10,
                                            child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                                child: ref.read(builderModelProvider) == null
                                                    ? Column(
                                                        children: [
                                                          Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              _itemList[index].itemName ?? '',
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
                                                              'Qty : ' + _itemList[index].openingStock,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontSize: DeviceUtil.isTablet ? 10 : 8,
                                                                color: num.parse(_itemList[index].openingStock) <= 0 ? kTextErrorColor : kTextColor,
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              Converter.currency.format(num.tryParse(_itemList[index].itemCost)),
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
                                                            ref.read(builderModelProvider) == 0
                                                                ? _itemList[index].category
                                                                : ref.read(builderModelProvider) == 1
                                                                    ? _itemList[index].subCategory
                                                                    : ref.read(builderModelProvider) == 2
                                                                        ? _itemList[index].brand
                                                                        : '',
                                                            textAlign: TextAlign.center,
                                                            softWrap: true,
                                                            style: kItemsTextStyle,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: ref.read(builderModelProvider) == 0 &&
                                                                    _itemList[index].category.toString().contains(' ')
                                                                ? 2
                                                                : ref.read(builderModelProvider) == 1 &&
                                                                        _itemList[index].subCategory.toString().contains(' ')
                                                                    ? 2
                                                                    : ref.read(builderModelProvider) == 2 &&
                                                                            _itemList[index].brand.toString().contains(' ')
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
                                      child: Text('No items found'),
                                    );
                            },
                          );
                        });
                  },
                ),
              ),
            ),
            //== == == == == Provider Listeners == == == == ==
            Consumer(builder: (context, ref, _) {
              ref.watch(_isLoadedProvider);
              ref.watch(builderModelProvider);
              return kNone;
            }),
          ],
        ),
      ),
    );
  }

// Checking if the product already added then Increasing the Quantity
//====================================================================
  void isProductAlreadyAdded(WidgetRef ref, itemList, int index) async {
    final vatMethod = itemList[index].vatMethod;
    final _vat = await VatUtils.instance.getVatById(vatId: itemList[index].vatId);
    log('VAT Method = ' + vatMethod);

    final _selectedProducts = ref.read(PurchaseSideWidget.selectedProductProvider.notifier);

    for (var i = 0; i < _selectedProducts.state.length; i++) {
      if (_selectedProducts.state[i].id == itemList[index].id) {
        final _currentQty = num.tryParse(PurchaseSideWidget.quantityNotifier.value[i].value.text);

        PurchaseSideWidget.quantityNotifier.value[i].text = '${_currentQty! + 1}';

//==================== On Item Quantity Changed ====================
        const PurchaseSideWidget().onItemQuantityChanged(
          ref,
          PurchaseSideWidget.quantityNotifier.value[i].text,
          _selectedProducts.state[i],
          i,
        );
        return;
      }
    }

    _selectedProducts.addItem(item: itemList[index]);
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
    const PurchaseSideWidget().getTotalAmount(ref);
    const PurchaseSideWidget().getTotalVAT();
    const PurchaseSideWidget().getTotalPayable();
  }

  Future onBarcodeScan(WidgetRef ref) async {
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
      ref.read(builderModelProvider.notifier).state = null;
      ref.read(itemsProvider.notifier).state = await ItemMasterDatabase.instance.getProductByItemCode(_itemCode);
    } on PlatformException catch (_) {
      log('Failed to get Platform version!');
    } catch (e) {
      log(e.toString());
    }

    // if (!mounted) return;
  }
}
