// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/debouncer/debouncer.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_button_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_price_section_widget.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../core/utils/device/device.dart';
import '../../../core/utils/snackbar/snackbar.dart';

class PurchaseSideWidget extends StatelessWidget {
  const PurchaseSideWidget({
    Key? key,
  }) : super(key: key);

  //==================== Value Notifiers ====================
  static final ValueNotifier<List<ItemMasterModel>> selectedProductsNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> subTotalNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> itemTotalVatNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> quantityNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> costNotifier = ValueNotifier([]);

  static final ValueNotifier<int?> supplierIdNotifier = ValueNotifier(null);
  static final ValueNotifier<String?> supplierNameNotifier = ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalVatNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalPayableNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final supplierController = TextEditingController();
  static final referenceNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        selectedProductsNotifier.value.clear();
        subTotalNotifier.value.clear();
        itemTotalVatNotifier.value.clear();
        supplierController.clear();
        costNotifier.value.clear();
        quantityNotifier.value.clear();
        totalItemsNotifier.value = 0;
        totalQuantityNotifier.value = 0;
        totalAmountNotifier.value = 0;
        totalVatNotifier.value = 0;
        totalPayableNotifier.value = 0;
        supplierIdNotifier.value = null;
        supplierNameNotifier.value = null;
        return true;
      },
      child: SizedBox(
        width: _screenSize.width / 2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //==================== Get All Supplier Search Field ====================
                Flexible(
                  flex: 6,
                  child: TypeAheadField(
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: false,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: supplierController,
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
                                supplierIdNotifier.value = null;
                                supplierController.clear();
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
                        title: AutoSizeText(
                          suggestion.contactName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10),
                          minFontSize: 10,
                          maxFontSize: 12,
                        ),
                      );
                    },
                    onSuggestionSelected: (SupplierModel suggestion) {
                      supplierController.text = suggestion.contactName;
                      supplierNameNotifier.value = suggestion.contactName;
                      supplierIdNotifier.value = suggestion.id;
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
                          referenceNumberController.clear();
                        },
                      ),
                    ),
                    controller: referenceNumberController,
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
                          minHeight: 45,
                          maxHeight: 45,
                        ),
                        onPressed: () {
                          if (supplierIdNotifier.value != null) {
                            log('$supplierIdNotifier');

                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: kTransparentColor,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                builder: (context) => DismissibleWidget(
                                      context: context,
                                      child: CustomBottomSheetWidget(
                                        id: supplierIdNotifier.value,
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
                          minHeight: 45,
                          maxHeight: 45,
                        ),
                        onPressed: () async {
                          // DeviceUtil.isLandscape = false;
                          // await DeviceUtil.toPortrait();
                          final id = await Navigator.pushNamed(context, routeManageSupplier, arguments: true);

                          if (id != null) {
                            final addedSupplier = await SupplierDatabase.instance.getSupplierById(id as int);

                            supplierController.text = addedSupplier.contactName;
                            supplierNameNotifier.value = addedSupplier.contactName;
                            supplierIdNotifier.value = addedSupplier.id;
                            log(addedSupplier.supplierName);
                          }

                          // await DeviceUtil.toLandscape();
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.blue,
                          size: 25,
                        )),
                  ),
                ),
              ],
            ),

            kHeight5,
            //==================== Table Header ====================
            const SalesTableHeaderWidget(
              isPurchase: true,
            ),

            //==================== Product Items Table ====================
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: selectedProductsNotifier,
                  builder: (context, List<ItemMasterModel> selectedProducts, child) {
                    return Table(
                      columnWidths: const {
                        0: FractionColumnWidth(0.30),
                        1: FractionColumnWidth(0.23),
                        2: FractionColumnWidth(0.12),
                        3: FractionColumnWidth(0.23),
                        4: FractionColumnWidth(0.12),
                      },
                      border: TableBorder.all(color: Colors.grey, width: 0.5),
                      children: List<TableRow>.generate(
                        selectedProducts.length,
                        (index) {
                          final ItemMasterModel _product = selectedProducts[index];
                          return TableRow(children: [
                            //==================== Item Name ====================
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                _product.itemName,
                                softWrap: true,
                                style: TextStyle(fontSize: DeviceUtil.isTablet ? 10 : 7),
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 7,
                                maxFontSize: 10,
                                maxLines: 2,
                              ),
                            ),
                            //==================== Item Cost ====================
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                controller: costNotifier.value[index],
                                keyboardType: TextInputType.number,
                                inputFormatters: Validators.digitsOnly,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                ),
                                style: TextStyle(fontSize: DeviceUtil.isTablet ? 10 : 7, color: kBlack),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '*';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    Debouncer().run(() {
                                      onItemCostChanged(cost: value, index: index);
                                    });
                                  } else {
                                    onItemCostChanged(cost: '0', index: index);
                                  }
                                },
                              ),
                            ),
                            //==================== Quantity ====================
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                controller: quantityNotifier.value[index],
                                keyboardType: TextInputType.number,
                                inputFormatters: Validators.digitsOnly,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                ),
                                style: TextStyle(fontSize: DeviceUtil.isTablet ? 10 : 7, color: kBlack),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    Debouncer().run(() {
                                      onItemQuantityChanged(value, selectedProducts, index);
                                    });
                                  } else {
                                    onItemQuantityChanged('0', selectedProducts, index);
                                  }
                                },
                              ),
                            ),
                            //==================== Sub Total ====================
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: ValueListenableBuilder(
                                    valueListenable: subTotalNotifier,
                                    builder: (context, List<String> subTotal, child) {
                                      return AutoSizeText(
                                        Converter.currency.format(num.tryParse(subTotal[index])),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: DeviceUtil.isTablet ? 10 : 7),
                                        minFontSize: 7,
                                        maxFontSize: 10,
                                      );
                                    })),
                            //==================== Delete Icon ====================
                            Container(
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    selectedProducts.removeAt(index);
                                    subTotalNotifier.value.removeAt(index);
                                    itemTotalVatNotifier.value.removeAt(index);
                                    costNotifier.value.removeAt(index);
                                    quantityNotifier.value.removeAt(index);
                                    subTotalNotifier.notifyListeners();
                                    selectedProductsNotifier.notifyListeners();
                                    totalItemsNotifier.value -= 1;
                                    getTotalQuantity();
                                    getTotalAmount();
                                    getTotalVAT();
                                    getTotalPayable();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 16,
                                  ),
                                ))
                          ]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            kHeight5,

            //==================== Price Sections ====================
            const PurchasePriceSectionWidget(),

            //==================== Payment Buttons Widget ====================
            const PurchaseButtonsWidget()
          ],
        ),
      ),
    );
  }

  //==================== On Item Cost Changed ====================
  void onItemCostChanged({required String cost, required int index}) {
    final qty = num.tryParse(quantityNotifier.value[index].text);
    final itemCost = num.tryParse(cost);
    log('Item Cost == $cost');

    if (qty != null && itemCost != null) {
      selectedProductsNotifier.value[index] = selectedProductsNotifier.value[index].copyWith(itemCost: cost);
      selectedProductsNotifier.notifyListeners();
      getSubTotal(selectedProductsNotifier.value, index, qty);
      getTotalAmount();
      getTotalVAT();
      getTotalPayable();
    }
  }

  //==================== On Item Quantity Changed ====================
  void onItemQuantityChanged(String value, List<ItemMasterModel> selectedProducts, int index) {
    final qty = num.tryParse(value);
    if (qty != null) {
      getTotalQuantity();
      getSubTotal(selectedProducts, index, qty);
      getTotalAmount();
      getTotalVAT();
      getTotalPayable();
    }
  }

  //==================== Get SubTotal Amount ====================
  void getSubTotal(List<ItemMasterModel> selectedProducts, int index, num qty) {
    final cost = num.tryParse(selectedProducts[index].itemCost);
    final vatRate = selectedProducts[index].vatRate;
    if (selectedProducts[index].vatMethod == 'Inclusive') {
      final _exclusiveCost = getExclusiveAmount(itemCost: selectedProducts[index].itemCost, vatRate: vatRate);
      final _subTotal = _exclusiveCost * qty;
      subTotalNotifier.value[index] = '$_subTotal';
    } else {
      final _subTotal = cost! * qty;
      subTotalNotifier.value[index] = '$_subTotal';
    }

    subTotalNotifier.notifyListeners();
  }

  //==================== Get Total Quantity ====================
  void getTotalQuantity() async {
    num? _totalQuantiy = 0;

    for (var i = 0; i < selectedProductsNotifier.value.length; i++) {
      _totalQuantiy = _totalQuantiy! + num.tryParse(quantityNotifier.value[i].value.text)!;
    }
    await Future.delayed(const Duration(milliseconds: 0));
    totalQuantityNotifier.value = _totalQuantiy!;
  }

  //==================== Get Total Amount ====================
  void getTotalAmount() {
    num? _totalAmount = 0;
    num? subTotal = 0;
    if (subTotalNotifier.value.isEmpty) {
      totalAmountNotifier.value = 0;
    } else {
      for (var i = 0; i < subTotalNotifier.value.length; i++) {
        if (selectedProductsNotifier.value[i].vatMethod == 'Inclusive') {
          subTotal = num.tryParse(subTotalNotifier.value[i]);
        } else {
          subTotal = num.tryParse(subTotalNotifier.value[i]);
        }

        _totalAmount = _totalAmount! + subTotal!;
      }
      totalAmountNotifier.value = _totalAmount!;
      log('Total Amount ==  $_totalAmount');
    }
  }

  //==================== Get Item VAT ====================
  void getItemVat({
    required String vatMethod,
    required String amount,
    required int vatRate,
  }) {
    num? itemTotalVat;
    num itemCost = num.parse(amount);

    if (vatMethod == 'Inclusive') {
      itemCost = getExclusiveAmount(itemCost: '$itemCost', vatRate: vatRate);
    }

    itemTotalVat = itemCost * vatRate / 100;
    log('Item VAT == $itemTotalVat');
    itemTotalVatNotifier.value.add('$itemTotalVat');
  }

  //==================== Get Total VAT ====================
  void getTotalVAT() {
    num _totalVAT = 0;
    int _vatRate;
    num _subTotal;

    if (subTotalNotifier.value.isEmpty) {
      totalVatNotifier.value = 0;
    } else {
      for (var i = 0; i < subTotalNotifier.value.length; i++) {
        _subTotal = num.parse(subTotalNotifier.value[i]);
        _vatRate = selectedProductsNotifier.value[i].vatRate;
        itemTotalVatNotifier.value[i] = '${_subTotal * _vatRate / 100}';

        log('Item Total VAT == ${itemTotalVatNotifier.value[i]}');

        _totalVAT += _subTotal * _vatRate / 100;
      }
      log('Total VAT == $_totalVAT');
      totalVatNotifier.value = _totalVAT;
    }
  }

  //==================== Calculate Exclusive Amount from Inclusive Amount ====================
  //==================== Calculate Exclusive Amount from Inclusive Amount ====================
  num getExclusiveAmount({required String itemCost, required int vatRate}) {
    num _exclusiveAmount = 0;
    num percentageYouHave = vatRate + 100;

    final _inclusiveAmount = num.tryParse(itemCost);

    _exclusiveAmount = _inclusiveAmount! * 100 / percentageYouHave;

    // log('Product VAT == ' '${_inclusiveAmount * 15 / 115}');
    // log('Exclusive == ' '${_inclusiveAmount * 100 / 115}');
    // log('Inclusive == ' '${_inclusiveAmount * 115 / 100}');

    return _exclusiveAmount;
  }

//==================== Get Total VAT ====================
  void getTotalPayable() {
    final num _totalPayable = totalAmountNotifier.value + totalVatNotifier.value;
    totalPayableNotifier.value = _totalPayable;
    log('Total Payable == $_totalPayable');
  }

  //==================== Reset All Values ====================
  void resetPurchase() {
    selectedProductsNotifier.value.clear();
    subTotalNotifier.value.clear();
    itemTotalVatNotifier.value.clear();
    supplierController.clear();
    costNotifier.value.clear();
    quantityNotifier.value.clear();
    totalItemsNotifier.value = 0;
    totalQuantityNotifier.value = 0;
    totalAmountNotifier.value = 0;
    totalVatNotifier.value = 0;
    totalPayableNotifier.value = 0;
    supplierIdNotifier.value = null;
    supplierNameNotifier.value = null;

    selectedProductsNotifier.notifyListeners();
    subTotalNotifier.notifyListeners();
    itemTotalVatNotifier.notifyListeners();
    costNotifier.notifyListeners();
    quantityNotifier.notifyListeners();
    totalItemsNotifier.notifyListeners();
    totalQuantityNotifier.notifyListeners();
    totalAmountNotifier.notifyListeners();
    totalVatNotifier.notifyListeners();
    totalPayableNotifier.notifyListeners();
    supplierIdNotifier.notifyListeners();
    supplierNameNotifier.notifyListeners();
  }
}
