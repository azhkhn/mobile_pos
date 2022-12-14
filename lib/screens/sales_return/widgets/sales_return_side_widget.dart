// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_alert.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/debouncer/debouncer.dart';
import 'package:mobile_pos/core/utils/validators/validators.dart';
import 'package:mobile_pos/db/db_functions/customer/customer_database.dart';
import 'package:mobile_pos/db/db_functions/item_master/item_master_database.dart';
import 'package:mobile_pos/db/db_functions/sales/sales_database.dart';
import 'package:mobile_pos/db/db_functions/sales/sales_items_database.dart';
import 'package:mobile_pos/db/db_functions/sales_return/sales_return_items_database.dart';
import 'package:mobile_pos/model/customer/customer_model.dart';
import 'package:mobile_pos/model/item_master/item_master_model.dart';
import 'package:mobile_pos/model/sales/sales_items_model.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import 'package:mobile_pos/model/sales_return/sales_return_items_model.dart';
import 'package:mobile_pos/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:mobile_pos/screens/pos/widgets/sales_table_header_widget.dart';
import 'package:mobile_pos/screens/sales_return/widgets/sales_return_buttons_widget.dart';
import 'package:mobile_pos/screens/sales_return/widgets/sales_return_price_section.dart';
import 'package:mobile_pos/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../core/utils/snackbar/snackbar.dart';

class SalesReturnSideWidget extends StatelessWidget {
  const SalesReturnSideWidget({
    Key? key,
    this.isVertical = false,
  }) : super(key: key);

  final bool isVertical;

  //==================== Value Notifiers ====================
  static final ValueNotifier<List<ItemMasterModel>> selectedProductsNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> subTotalNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> itemTotalVatNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> quantityNotifier = ValueNotifier([]);

  static final ValueNotifier<SalesModel?> originalSaleNotifier = ValueNotifier(null);

  static final ValueNotifier<CustomerModel?> customerNotifier = ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalVatNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalPayableNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final customerController = TextEditingController();
  static final saleInvoiceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //========== Device Utils ==========
    // Size _screenSize = MediaQuery.of(context).size;
    final bool isSmall = DeviceUtil.isSmall;

    return WillPopScope(
      onWillPop: () async {
        if (selectedProductsNotifier.value.isEmpty) {
          resetSalesReturn();

          return true;
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return KAlertDialog(
                  content: const Text('Are you sure want to cancel the sales return?'),
                  submitAction: () {
                    Navigator.pop(context);
                    resetSalesReturn();
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
                  //==================== Get All Customer Search Field ====================
                  Flexible(
                    flex: 9,
                    child: ValueListenableBuilder(
                        valueListenable: originalSaleNotifier,
                        builder: (context, _, __) {
                          return TypeAheadField(
                            minCharsForSuggestions: 0,
                            debounceDuration: const Duration(milliseconds: 500),
                            hideSuggestionsOnKeyboardHide: true,
                            textFieldConfiguration: TextFieldConfiguration(
                                enabled: originalSaleNotifier.value == null,
                                controller: customerController,
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
                                        customerNotifier.value = null;
                                        customerController.clear();
                                      },
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(isSmall ? 8 : 10),
                                  hintText: 'Customer',
                                  hintStyle: kText_10_12,
                                  border: const OutlineInputBorder(),
                                )),
                            noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No customer Found!'))),
                            suggestionsCallback: (pattern) async {
                              return CustomerDatabase.instance.getCustomerSuggestions(pattern);
                            },
                            itemBuilder: (context, CustomerModel suggestion) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  suggestion.customer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kText_10_12,
                                ),
                              );
                            },
                            onSuggestionSelected: (CustomerModel suggestion) {
                              customerController.text = suggestion.customer;
                              customerNotifier.value = suggestion;
                              log(suggestion.company);
                            },
                          );
                        }),
                  ),
                  kWidth5,

                  //==================== Get All Sales Invoices ====================
                  Flexible(
                    flex: 9,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: saleInvoiceController,
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
                                  saleInvoiceController.clear();
                                  if (originalSaleNotifier.value != null) {
                                    return resetSalesReturn(notify: true);
                                  }
                                  originalSaleNotifier.value = null;
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
                        return await SalesDatabase.instance.getSalesByInvoiceSuggestions(pattern);
                      },
                      itemBuilder: (context, SalesModel suggestion) {
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
                      onSuggestionSelected: (SalesModel sale) async {
                        resetSalesReturn(notify: true);
                        saleInvoiceController.text = sale.invoiceNumber!;
                        originalSaleNotifier.value = sale;

                        //========== Get Sales Details ==========
                        await getSalesDetails(sale);

                        log(sale.invoiceNumber!);
                      },
                    ),
                  ),
                  kWidth5,

                  //========== View customer Button ==========
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
                            if (customerNotifier.value != null) {
                              log('${customerNotifier.value}');

                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: kTransparentColor,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                  builder: (context) => DismissibleWidget(
                                        context: context,
                                        child: CustomBottomSheetWidget(
                                          model: customerNotifier.value,
                                          supplier: false,
                                        ),
                                      ));
                            } else {
                              kSnackBar(context: context, content: 'Please select any Customer to show details!');
                            }
                          },
                          icon: Icon(
                            Icons.person_search,
                            color: Colors.blue,
                            size: isSmall ? 23 : 25,
                          )),
                    ),
                  ),

                  // //========== Add customer Button ==========
                  // Flexible(
                  //   flex: 1,
                  //   child: FittedBox(
                  //     child: IconButton(
                  //         padding: const EdgeInsets.all(5),
                  //         alignment: Alignment.center,
                  //         constraints: const BoxConstraints(
                  //           minHeight: 30,
                  //           maxHeight: 30,
                  //         ),
                  //         onPressed: () async {
                  //           // OrientationMode.isLandscape = false;
                  //           // await OrientationMode.toPortrait();
                  // final CustomerModel? addedCustomer =
                  //                   await Navigator.pushNamed(context, routeAddCustomer, arguments: {'from': true}) as CustomerModel;

                  //               if (addedCustomer != null) {
                  //                 // final addedCustomer = await CustomerDatabase.instance.getCustomerById(id as int);

                  //             customerController.text = addedCustomer.customer;
                  //             customerNameNotifier.value = addedCustomer.customer;
                  //             customerIdNotifier.value = addedCustomer.id;
                  //             log(addedCustomer.company);
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
              const SalesTableHeaderWidget(),

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
                                            ? Converter.currency.format(num.parse(_product.sellingPrice))
                                            : Converter.currency
                                                .format(getExclusiveAmount(sellingPrice: _product.sellingPrice, vatRate: _product.vatRate)),
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
                                        inputFormatters: Validators.digitsOnly,
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
                                originalSaleNotifier.value == null ? 'Select any invoice to return sale!' : 'This sale is already returned!',
                                style: originalSaleNotifier.value == null ? null : kBoldText,
                              ),
                            ));
                    },
                  ),
                ),
              ),
              kHeight5,

              //==================== Price Sections ====================
              SalesReturnPriceSectionWidget(isVertical: isVertical),

              //==================== Payment Buttons Widget ====================
              SalesReturnButtonsWidget(isVertical: isVertical)
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
    final cost = num.tryParse(selectedProducts[index].sellingPrice);
    final vatRate = selectedProducts[index].vatRate;
    if (selectedProducts[index].vatMethod == 'Inclusive') {
      final _exclusiveCost = getExclusiveAmount(sellingPrice: selectedProducts[index].sellingPrice, vatRate: vatRate);
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
      totalAmountNotifier.value = Converter.amountRounder(_totalAmount!);
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
    num sellingPrice = num.parse(amount);

    if (vatMethod == 'Inclusive') {
      sellingPrice = getExclusiveAmount(sellingPrice: '$sellingPrice', vatRate: vatRate);
    }

    itemTotalVat = sellingPrice * vatRate / 100;
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
      totalVatNotifier.value = Converter.amountRounder(_totalVAT);
    }
  }

  //==================== Calculate Exclusive Amount from Inclusive Amount ====================
  num getExclusiveAmount({required String sellingPrice, required int vatRate}) {
    num _exclusiveAmount = 0;
    num percentageYouHave = vatRate + 100;

    final _inclusiveAmount = num.tryParse(sellingPrice);

    _exclusiveAmount = _inclusiveAmount! * 100 / percentageYouHave;

    // log('Product VAT == ' '${_inclusiveAmount * 15 / 115}');
    // log('Exclusive == ' '${_inclusiveAmount * 100 / 115}');
    // log('Inclusive == ' '${_inclusiveAmount * 115 / 100}');

    return _exclusiveAmount;
  }

//==================== Get Total VAT ====================
  void getTotalPayable() {
    final num _totalPayable = totalAmountNotifier.value + totalVatNotifier.value;
    totalPayableNotifier.value = Converter.amountRounder(_totalPayable);
    log('Total Payable == $_totalPayable');
  }

  //========================================                   ========================================
  //======================================== Get Sales Details ========================================
  //========================================                   ========================================
  Future<void> getSalesDetails(SalesModel sale) async {
    final List<ItemMasterModel> remainingsoldItems = [];

    customerController.text = sale.customerName;
    customerNotifier.value = await CustomerDatabase.instance.getCustomerById(sale.customerId);

    //==================== Fetch sold items based on salesId ====================
    final List<SalesItemsModel> soldItems = await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);

    final List<SalesReturnItemsModel> salesReturnedItems = await SalesReturnItemsDatabase.instance.getSalesReturnItemBySalesId(sale.id!);
    log('==========================================================================================');

    //==================== Adding sold items to UI ====================
    for (var index = 0; index < soldItems.length; index++) {
      SalesItemsModel soldItem = soldItems[index];
      final ItemMasterModel item = await ItemMasterDatabase.instance.getProductById(soldItem.productId);

      final List<SalesReturnItemsModel> returnedItems =
          salesReturnedItems.where((returnedItem) => returnedItem.productId == soldItem.productId).toList();

      log('Returnned Items =+==+= ' + returnedItems.toString());

      //==================== Calculating Returned Items and Quantity from Sold Items ====================
      for (var i2 = 0; i2 < returnedItems.length; i2++) {
        final soldQty = num.parse(soldItem.quantity);
        final num returnedQty = num.parse(returnedItems[i2].quantity);
        log('sold Qty = $soldQty');
        log('returned Qty = $returnedQty');
        soldItem = soldItem.copyWith(quantity: (soldQty - returnedQty).toString());
      }

      // log('item Id == ' '${item.id}');
      // log('item Name == ' + item.itemName);
      // log('Category Id ==  ${soldItem.categoryId}');
      // log('Product Code == ' + soldItem.productCode);
      // log('Cost == ' + soldItem.productCost);
      // log('Unit Price == ' + soldItem.unitPrice);
      // log('Net Unit Price == ' + soldItem.netUnitPrice);
      // log('Quantity == ' + soldItem.quantity);
      // log('Unit Code == ' + soldItem.unitCode);
      // log('Vat Id == ${soldItem.vatId}');
      // log('Vat Rate == ${soldItem.vatRate}');
      // log('Products Vat Method == ' + soldItem.vatMethod);
      // log('Vat Method == ' + soldItem.vatMethod);
      // log('Vat Percentage == ' + soldItem.vatPercentage);
      // log('Vat Total == ' + soldItem.vatTotal);

      final finalQty = num.parse(soldItem.quantity);

      if (finalQty > 0) {
        remainingsoldItems.add(ItemMasterModel(
          id: item.id,
          productType: item.productType,
          itemName: item.itemName,
          itemNameArabic: item.itemNameArabic,
          itemCode: soldItem.productCode,
          itemCategoryId: soldItem.categoryId,
          itemSubCategoryId: item.itemSubCategoryId,
          itemBrandId: item.itemBrandId,
          itemCost: soldItem.productCost,
          sellingPrice: soldItem.unitPrice,
          secondarySellingPrice: item.secondarySellingPrice,
          vatMethod: soldItem.vatMethod,
          productVAT: item.productVAT,
          vatId: soldItem.vatId,
          vatRate: soldItem.vatRate,
          unit: soldItem.unitCode,
          expiryDate: item.expiryDate,
          openingStock: soldItem.quantity,
          alertQuantity: item.alertQuantity,
          itemImage: item.itemImage,
        ));

        quantityNotifier.value.add(TextEditingController(text: soldItem.quantity));
        selectedProductsNotifier.value.add(remainingsoldItems[remainingsoldItems.length - 1]);
        subTotalNotifier.value.add(soldItem.unitPrice);

        getSubTotal(remainingsoldItems, remainingsoldItems.length - 1, num.parse(soldItem.quantity));
        getItemVat(vatMethod: soldItem.vatMethod, amount: soldItem.unitPrice, vatRate: soldItem.vatRate);
      }
    }

    totalItemsNotifier.value = num.parse(remainingsoldItems.length.toString());
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
    customerNotifier.notifyListeners();
    originalSaleNotifier.notifyListeners();
  }

  //==================== Reset All Values ====================
  void resetSalesReturn({bool notify = false}) {
    selectedProductsNotifier.value.clear();
    subTotalNotifier.value.clear();
    itemTotalVatNotifier.value.clear();
    customerController.clear();
    saleInvoiceController.clear();
    quantityNotifier.value.clear();
    totalItemsNotifier.value = 0;
    totalQuantityNotifier.value = 0;
    totalAmountNotifier.value = 0;
    totalVatNotifier.value = 0;
    totalPayableNotifier.value = 0;
    customerNotifier.value = null;
    originalSaleNotifier.value = null;
    // SalesReturnProductSideWidget.itemsNotifier.value.clear();

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
      customerNotifier.notifyListeners();
      originalSaleNotifier.notifyListeners();
    }

    log('========== Sales Return values has been cleared! ==========');
  }
}
