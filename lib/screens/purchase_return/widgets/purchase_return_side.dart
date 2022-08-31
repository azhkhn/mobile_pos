// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_alert.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/debouncer/debouncer.dart';
import 'package:mobile_pos/db/db_functions/item_master/item_master_database.dart';
import 'package:mobile_pos/db/db_functions/purchase/purchase_database.dart';
import 'package:mobile_pos/db/db_functions/purchase/purchase_items_database.dart';
import 'package:mobile_pos/db/db_functions/purchase_return/purchase_return_items_database.dart';
import 'package:mobile_pos/db/db_functions/supplier/supplier_database.dart';
import 'package:mobile_pos/model/item_master/item_master_model.dart';
import 'package:mobile_pos/model/purchase/purchase_items_model.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';
import 'package:mobile_pos/model/purchase_return/purchase_return_items_modal.dart';
import 'package:mobile_pos/model/supplier/supplier_model.dart';
import 'package:mobile_pos/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:mobile_pos/screens/pos/widgets/sales_table_header_widget.dart';
import 'package:mobile_pos/screens/purchase_return/widgets/purchase_return_buttons.dart';
import 'package:mobile_pos/screens/purchase_return/widgets/purchase_return_price_section.dart';
import 'package:mobile_pos/screens/purchase_return/widgets/purchase_return_product_side.dart';
import 'package:mobile_pos/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../core/utils/snackbar/snackbar.dart';

class PurchaseReturnSideWidget extends StatelessWidget {
  const PurchaseReturnSideWidget({
    this.isVertical = false,
    Key? key,
  }) : super(key: key);

  final bool isVertical;
  //==================== Value Notifiers ====================
  static final ValueNotifier<List<ItemMasterModel>> selectedProductsNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> subTotalNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> itemTotalVatNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> quantityNotifier = ValueNotifier([]);

  static final ValueNotifier<PurchaseModel?> originalPurchaseNotifier = ValueNotifier(null);

  static final ValueNotifier<SupplierModel?> supplierNotifier = ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalVatNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalPayableNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final TextEditingController supplierController = TextEditingController();
  static final TextEditingController purchaseInvoiceController = TextEditingController();

  //========== Database Instances ==========
  static final PurchaseDatabase purchaseDatabase = PurchaseDatabase.instance;
  static final PurchaseItemsDatabase purchaseItemsDatabase = PurchaseItemsDatabase.instance;
  static final ItemMasterDatabase itemDB = ItemMasterDatabase.instance;

  @override
  Widget build(BuildContext context) {
    // Size _screenSize = MediaQuery.of(context).size;
    final bool isSmall = DeviceUtil.isSmall;

    return WillPopScope(
      onWillPop: () async {
        if (selectedProductsNotifier.value.isEmpty) {
          resetPurchaseReturn();
          PurchaseReturnProductSideWidget.itemsNotifier.value.clear();
          return true;
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return KAlertDialog(
                  content: const Text('Are you sure want to cancel the purchase return?'),
                  submitAction: () {
                    Navigator.pop(context);
                    resetPurchaseReturn();
                    PurchaseReturnProductSideWidget.itemsNotifier.value.clear();

                    Navigator.pop(context);
                  },
                );
              });
          return false;
        }
      },
      child: Expanded(
        child: SizedBox(
          // width: isVertical ? double.infinity : _screenSize.width / 2.5,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // isVertical
              //     ? kNone :
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Get All Products Search Field ==========
                  Flexible(
                    flex: 9,
                    child: ValueListenableBuilder(
                        valueListenable: originalPurchaseNotifier,
                        builder: (context, _, __) {
                          return TypeAheadField(
                            minCharsForSuggestions: 0,
                            debounceDuration: const Duration(milliseconds: 500),
                            hideSuggestionsOnKeyboardHide: true,
                            textFieldConfiguration: TextFieldConfiguration(
                                enabled: originalPurchaseNotifier.value == null,
                                controller: supplierController,
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
                                        supplierNotifier.value = null;
                                        supplierController.clear();
                                      },
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(isSmall ? 8 : 10),
                                  hintText: 'Supplier',
                                  hintStyle: kText_10_12,
                                  border: const OutlineInputBorder(),
                                )),
                            noItemsFoundBuilder: (context) => SizedBox(
                                height: 50,
                                child: Center(
                                    child: Text(
                                  'No supplier found!',
                                  style: kText_10_12,
                                ))),
                            suggestionsCallback: (pattern) async {
                              return SupplierDatabase.instance.getSupplierSuggestions(pattern);
                            },
                            itemBuilder: (context, SupplierModel suggestion) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  suggestion.supplierName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kText_10_12,
                                ),
                              );
                            },
                            onSuggestionSelected: (SupplierModel suggestion) {
                              supplierController.text = suggestion.supplierName;
                              supplierNotifier.value = suggestion;
                              log(suggestion.supplierName);
                            },
                          );
                        }),
                  ),
                  kWidth5,

                  //==================== Get All Purchases Invoices ====================
                  Flexible(
                    flex: 9,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: purchaseInvoiceController,
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
                                child: const Icon(
                                  Icons.clear,
                                  size: 15,
                                ),
                                onTap: () async {
                                  purchaseInvoiceController.clear();

                                  if (originalPurchaseNotifier.value != null) {
                                    return resetPurchaseReturn(notify: true);
                                  }

                                  originalPurchaseNotifier.value = null;
                                },
                              ),
                            ),
                            contentPadding: EdgeInsets.all(isSmall ? 8 : 10),
                            hintText: 'Invoice No',
                            hintStyle: kText_10_12,
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => SizedBox(height: 50, child: Center(child: Text('No Invoice Found!', style: kText_10_12))),
                      suggestionsCallback: (pattern) async {
                        return await purchaseDatabase.getPurchaseByInvoiceSuggestions(pattern);
                      },
                      itemBuilder: (context, PurchaseModel suggestion) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            suggestion.invoiceNumber!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kText_10_12,
                          ),
                        );
                      },
                      onSuggestionSelected: (PurchaseModel purchase) async {
                        resetPurchaseReturn(notify: true);
                        purchaseInvoiceController.text = purchase.invoiceNumber!;
                        originalPurchaseNotifier.value = purchase;

                        await getPurchaseDetails(purchase);

                        log(purchase.invoiceNumber!);
                      },
                    ),
                  ),
                  kWidth5,

                  //========== View Supplier Button ==========
                  Flexible(
                    flex: isVertical ? 2 : 1,
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: IconButton(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(
                            minHeight: 20,
                            maxHeight: 20,
                          ),
                          onPressed: () {
                            if (supplierNotifier.value != null) {
                              log('${supplierNotifier.value}');

                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: kTransparentColor,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                  builder: (context) => DismissibleWidget(
                                        context: context,
                                        child: CustomBottomSheetWidget(
                                          model: supplierNotifier.value,
                                          supplier: true,
                                        ),
                                      ));
                            } else {
                              kSnackBar(context: context, content: 'Please select any Supplier to show details!');
                            }
                          },
                          icon: Icon(
                            Icons.person_search,
                            color: Colors.blue,
                            size: isSmall ? 23 : 25,
                          )),
                    ),
                  ),

                  // //========== Add supplier Button ==========
                  // Flexible(
                  //   flex: 1,
                  //   child: FittedBox(
                  //     child: IconButton(
                  //         padding: const EdgeInsets.all(5),
                  //         alignment: Alignment.center,
                  //         constraints: const BoxConstraints(
                  //           minHeight: 45,
                  //           maxHeight: 45,
                  //         ),
                  //         onPressed: () async {
                  //           // OrientationMode.isLandscape = false;
                  //           // await OrientationMode.toPortrait();
                  //           final id = await Navigator.pushNamed(context, routeAddSupplier, arguments: true);

                  //           if (id != null) {
                  //             final addedSupplier = await SupplierDatabase.instance.getSupplierById(id as int);

                  //             supplierController.text = addedSupplier.contactName;
                  //             supplierNameNotifier.value = addedSupplier.contactName;
                  //             supplierIdNotifier.value = addedSupplier.id;
                  //             log(addedSupplier.supplierName);
                  //           }

                  //           // await OrientationMode.toLandscape();
                  //         },
                  //         icon: const Icon(
                  //           Icons.person_add,
                  //           color: Colors.blue,
                  //           size: 25,
                  //         )),
                  //   ),
                  // ),
                ],
              ),

              kHeight5,
              //==================== Table Header ====================
              const SalesTableHeaderWidget(isPurchase: true),

              //==================== Product Items Table ====================
              Expanded(
                child: SingleChildScrollView(
                  child: ValueListenableBuilder(
                    valueListenable: selectedProductsNotifier,
                    builder: (context, List<ItemMasterModel> selectedProducts, child) {
                      return selectedProducts.isNotEmpty
                          ? Table(
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: isSmall ? 25 : 30,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _product.itemName,
                                        softWrap: true,
                                        style: kItemsTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      color: Colors.white,
                                      height: isSmall ? 25 : 30,
                                      alignment: Alignment.center,
                                      child: Text(
                                        _product.vatMethod == 'Exclusive'
                                            ? Converter.currency.format(num.parse(_product.itemCost))
                                            : Converter.currency.format(getExclusiveAmount(itemCost: _product.itemCost, vatRate: _product.vatRate)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kItemsTextStyle,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      height: isSmall ? 25 : 30,
                                      alignment: Alignment.topCenter,
                                      child: TextFormField(
                                        controller: quantityNotifier.value[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          errorStyle: TextStyle(fontSize: 0.1),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(color: kTextErrorColor, width: 0.8),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero,
                                            borderSide: BorderSide(color: kTextErrorColor, width: 0.8),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5.0),
                                        ),
                                        style: kItemsTextStyle,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          final num soldQty = num.parse(selectedProductsNotifier.value[index].openingStock);

                                          if (value == null || value.isEmpty || value == '.') {
                                            return '*';
                                          } else if (num.parse(value) > soldQty) {
                                            return '*';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (num.tryParse(value) != null) {
                                            if (num.parse(value) <= 0) {
                                              quantityNotifier.value[index].clear();
                                            } else {
                                              Debouncer().run(() {
                                                if (value.isNotEmpty && value != '.') {
                                                  final num _newQuantity = num.parse(value);

                                                  onItemQuantityChanged(value, selectedProducts, index);

                                                  log('new Quantity == ' + _newQuantity.toString());
                                                }
                                              });
                                            }
                                          } else {
                                            if (value.isEmpty) {
                                              onItemQuantityChanged('0', selectedProducts, index);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        color: Colors.white,
                                        height: isSmall ? 25 : 30,
                                        alignment: Alignment.center,
                                        child: ValueListenableBuilder(
                                            valueListenable: subTotalNotifier,
                                            builder: (context, List<String> subTotal, child) {
                                              return Text(
                                                Converter.currency.format(num.tryParse(subTotal[index])),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: kItemsTextStyle,
                                              );
                                            })),
                                    Container(
                                        color: Colors.white,
                                        height: isSmall ? 25 : 30,
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          onPressed: () {
                                            selectedProducts.removeAt(index);
                                            subTotalNotifier.value.removeAt(index);
                                            itemTotalVatNotifier.value.removeAt(index);
                                            quantityNotifier.value.removeAt(index);
                                            subTotalNotifier.notifyListeners();
                                            selectedProductsNotifier.notifyListeners();
                                            totalItemsNotifier.value -= 1;
                                            getTotalQuantity();
                                            getTotalAmount();
                                            getTotalVAT();
                                            getTotalPayable();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: isSmall ? 12 : 16,
                                          ),
                                        ))
                                  ]);
                                },
                              ),
                            )
                          : Center(
                              child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                originalPurchaseNotifier.value == null
                                    ? 'Select any invoice to return purchase!'
                                    : 'This purchase is already returned!',
                                style: originalPurchaseNotifier.value == null ? null : kBoldText,
                              ),
                            ));
                    },
                  ),
                ),
              ),
              kHeight5,

              //==================== Price Sections ====================
              PurchaseReturnPriceSectionWidget(isVertical: isVertical),

              //==================== Payment Buttons Widget ====================
              PurchaseReturnButtonsWidget(isVertical: isVertical)
            ],
          ),
        ),
      ),
    );
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
  Future<void> getTotalQuantity() async {
    num? _totalQuantiy = 0;

    for (var i = 0; i < selectedProductsNotifier.value.length; i++) {
      _totalQuantiy = _totalQuantiy! + num.parse(quantityNotifier.value[i].value.text.isNotEmpty ? quantityNotifier.value[i].value.text : '0');
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

  //========================================                      ========================================
  //======================================== Get Purchase Details ========================================
  //========================================                      ========================================
  Future<void> getPurchaseDetails(PurchaseModel purchase) async {
    final List<ItemMasterModel> remainingPurchasedItems = [];

    supplierController.text = purchase.supplierName;
    supplierNotifier.value = await SupplierDatabase.instance.getSupplierById(purchase.supplierId);

    //==================== Fetch sold items based on salesId ====================
    final List<PurchaseItemsModel> purchasedItems = await PurchaseItemsDatabase.instance.getPurchaseItemByPurchaseId(purchase.id!);

    final List<PurchaseItemsReturnModel> purchaseReturnedItems =
        await PurchaseReturnItemsDatabase.instance.getPurchaseReturnItemByPurchaseId(purchase.id!);
    log('==========================================================================================');

    //==================== Adding purchased items to UI ====================
    for (var i = 0; i < purchasedItems.length; i++) {
      PurchaseItemsModel purchasedItem = purchasedItems[i];
      final ItemMasterModel item = await itemDB.getProductById(purchasedItem.productId);

      final List<PurchaseItemsReturnModel> returnedItems =
          purchaseReturnedItems.where((returnedItem) => returnedItem.productId == purchasedItem.productId).toList();

      log('Returnned Items =+==+= ' + returnedItems.toString());

      //==================== Calculating Returned Items and Quantity from Purchased Items ====================
      for (var i2 = 0; i2 < returnedItems.length; i2++) {
        final soldQty = num.parse(purchasedItem.quantity);
        final num returnedQty = num.parse(returnedItems[i2].quantity);
        log('Purchased Qty = $soldQty');
        log('Returned Qty = $returnedQty');
        purchasedItem = purchasedItem.copyWith(quantity: (soldQty - returnedQty).toString());
      }

      // log('item Id == ' '${item.id}');
      // log('item Name == ' + item.itemName);
      // log('Category == ${purchasedItem.categoryId}');
      // log('Product Code == ' + purchasedItem.productCode);
      // log('Cost == ' + purchasedItem.productCost);
      // log('Unit Price == ' + purchasedItem.unitPrice);
      // log('Net Unit Price == ' + purchasedItem.netUnitPrice);
      // log('Quantity == ' + purchasedItem.quantity);
      // log('Unit Code == ' + purchasedItem.unitCode);
      // log('Vat Id == ${purchasedItem.vatId}');
      // log('Products Vat Method == ' + item.vatMethod);
      // log('Vat Method == ' + item.vatMethod);
      // log('Vat Percentage == ' + purchasedItem.vatPercentage);
      // log('Vat Total == ' + purchasedItem.vatTotal);

      final finalQty = num.parse(purchasedItem.quantity);

      if (finalQty > 0) {
        remainingPurchasedItems.add(ItemMasterModel(
          id: item.id,
          productType: item.productType,
          itemName: item.itemName,
          itemNameArabic: item.itemNameArabic,
          itemCode: purchasedItem.productCode,
          itemCategoryId: purchasedItem.categoryId,
          itemSubCategoryId: item.itemSubCategoryId,
          itemBrandId: item.itemBrandId,
          itemCost: purchasedItem.productCost,
          sellingPrice: purchasedItem.unitPrice,
          secondarySellingPrice: item.secondarySellingPrice,
          vatMethod: item.vatMethod,
          productVAT: item.productVAT,
          vatId: purchasedItem.vatId,
          vatRate: item.vatRate,
          unit: purchasedItem.unitCode,
          expiryDate: item.expiryDate,
          openingStock: purchasedItem.quantity,
          alertQuantity: item.alertQuantity,
          itemImage: item.itemImage,
        ));

        quantityNotifier.value.add(TextEditingController(text: purchasedItem.quantity));
        selectedProductsNotifier.value.add(remainingPurchasedItems[remainingPurchasedItems.length - 1]);
        subTotalNotifier.value.add(purchasedItem.unitPrice);

        getSubTotal(remainingPurchasedItems, remainingPurchasedItems.length - 1, num.parse(purchasedItem.quantity));
        getItemVat(vatMethod: purchasedItem.vatMethod, amount: purchasedItem.unitPrice, vatRate: purchasedItem.vatRate);
      }
    }

    totalItemsNotifier.value = num.parse(remainingPurchasedItems.length.toString());
    await getTotalQuantity();
    getTotalVAT();
    getTotalAmount();
    getTotalPayable();

    selectedProductsNotifier.notifyListeners();
    subTotalNotifier.notifyListeners();
    itemTotalVatNotifier.notifyListeners();
    quantityNotifier.notifyListeners();
    totalItemsNotifier.notifyListeners();
    totalQuantityNotifier.notifyListeners();
    totalAmountNotifier.notifyListeners();
    totalVatNotifier.notifyListeners();
    totalPayableNotifier.notifyListeners();
    supplierNotifier.notifyListeners();
    originalPurchaseNotifier.notifyListeners();
  }

  //==================== Reset All Values ====================
  void resetPurchaseReturn({bool notify = false}) {
    selectedProductsNotifier.value.clear();
    subTotalNotifier.value.clear();
    itemTotalVatNotifier.value.clear();
    supplierController.clear();
    purchaseInvoiceController.clear();
    quantityNotifier.value.clear();
    totalItemsNotifier.value = 0;
    totalQuantityNotifier.value = 0;
    totalAmountNotifier.value = 0;
    totalVatNotifier.value = 0;
    totalPayableNotifier.value = 0;
    supplierNotifier.value = null;
    originalPurchaseNotifier.value = null;
    // PurchaseReturnProductSideWidget.itemsNotifier.value.clear();

    if (notify) {
      selectedProductsNotifier.notifyListeners();
      subTotalNotifier.notifyListeners();
      itemTotalVatNotifier.notifyListeners();
      quantityNotifier.notifyListeners();
      totalItemsNotifier.notifyListeners();
      totalQuantityNotifier.notifyListeners();
      totalAmountNotifier.notifyListeners();
      totalVatNotifier.notifyListeners();
      totalPayableNotifier.notifyListeners();
      supplierNotifier.notifyListeners();
    }

    log('========== Purchase Return values has been cleared! ==========');
  }
}
