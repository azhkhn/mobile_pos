// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/alertdialog/custom_alert.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/debouncer/debouncer.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/pos/widgets/price_section_widget.dart';
import 'package:shop_ez/screens/pos/widgets/product_side_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../core/utils/snackbar/snackbar.dart';
import '../../../widgets/gesture_dismissible_widget/dismissible_widget.dart';

class SaleSideWidget extends StatelessWidget {
  const SaleSideWidget({
    Key? key,
    this.isVertical = false,
  }) : super(key: key);

  final bool isVertical;

  //==================== Value Notifiers ====================
  static final ValueNotifier<List<ItemMasterModel>> selectedProductsNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> subTotalNotifier = ValueNotifier([]);
  static final ValueNotifier<List<String>> itemTotalVatNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> quantityNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> unitPriceNotifier = ValueNotifier([]);

  static final ValueNotifier<int?> customerIdNotifier = ValueNotifier(null);
  static final ValueNotifier<String?> customerNameNotifier = ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalVatNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalPayableNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final customerController = TextEditingController();

  //==================== Global Keys ====================
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (selectedProductsNotifier.value.isEmpty) {
          selectedProductsNotifier.value.clear();
          subTotalNotifier.value.clear();
          itemTotalVatNotifier.value.clear();
          customerController.clear();
          quantityNotifier.value.clear();
          unitPriceNotifier.value.clear();
          totalItemsNotifier.value = 0;
          totalQuantityNotifier.value = 0;
          totalAmountNotifier.value = 0;
          totalVatNotifier.value = 0;
          totalPayableNotifier.value = 0;
          customerIdNotifier.value = null;
          customerNameNotifier.value = null;
          ProductSideWidget.itemsNotifier.value.clear();
          return true;
        } else {
          showDialog(
              context: context,
              builder: (context) => KAlertDialog(
                    content: const Text('Are you sure want to cancel the sale?'),
                    submitAction: () {
                      selectedProductsNotifier.value.clear();
                      subTotalNotifier.value.clear();
                      itemTotalVatNotifier.value.clear();
                      customerController.clear();
                      quantityNotifier.value.clear();
                      unitPriceNotifier.value.clear();
                      totalItemsNotifier.value = 0;
                      totalQuantityNotifier.value = 0;
                      totalAmountNotifier.value = 0;
                      totalVatNotifier.value = 0;
                      totalPayableNotifier.value = 0;
                      customerIdNotifier.value = null;
                      customerNameNotifier.value = null;
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ));
          return false;
        }
      },
      child: Expanded(
        child: SizedBox(
          width: isVertical ? double.infinity : _screenSize.width / 2.5,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isVertical
                  ? kNone
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //==================== Get All Customers Search Field ====================
                        Flexible(
                          flex: 8,
                          child: TypeAheadField(
                            debounceDuration: const Duration(milliseconds: 500),
                            hideSuggestionsOnKeyboardHide: true,
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: customerController,
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
                                        customerIdNotifier.value = null;
                                        customerController.clear();
                                      },
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: 'Customer',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: const OutlineInputBorder(),
                                )),
                            noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Customer Found!'))),
                            suggestionsCallback: (pattern) async {
                              return CustomerDatabase.instance.getCustomerSuggestions(pattern);
                            },
                            itemBuilder: (context, CustomerModel suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion.customer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kText_10_12,
                                ),
                              );
                            },
                            onSuggestionSelected: (CustomerModel suggestion) {
                              customerController.text = suggestion.customer;
                              customerNameNotifier.value = suggestion.customer;
                              customerIdNotifier.value = suggestion.id;
                              log(suggestion.company);
                            },
                          ),
                        ),
                        kWidth5,

                        //========== View Customer Button ==========
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
                                  if (customerIdNotifier.value != null) {
                                    log(' Customer Id == ${customerIdNotifier.value}');

                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: kTransparentColor,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                        builder: (context) => DismissibleWidget(
                                              context: context,
                                              child: CustomBottomSheetWidget(id: customerIdNotifier.value),
                                            ));
                                  } else {
                                    kSnackBar(context: context, content: 'Please select any Customer to show details!');
                                  }
                                },
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                  size: 25,
                                )),
                          ),
                        ),

                        //========== Add Customer Button ==========
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
                                final id = await Navigator.pushNamed(context, routeAddCustomer, arguments: true);

                                if (id != null) {
                                  final addedCustomer = await CustomerDatabase.instance.getCustomerById(id as int);

                                  customerController.text = addedCustomer.customer;
                                  customerNameNotifier.value = addedCustomer.customer;
                                  customerIdNotifier.value = addedCustomer.id;
                                  log(addedCustomer.company);
                                }

                                // await OrientationMode.toLandscape();
                              },
                              icon: const Icon(
                                Icons.person_add,
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

              kHeight5,
              //==================== Table Header ====================
              const SalesTableHeaderWidget(),

              //==================== Product Items Table ====================
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
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
                                  child: Text(
                                    _product.itemName,
                                    softWrap: true,
                                    style: kItemsTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),

                                //==================== Unit Price ====================
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  color: Colors.white,
                                  height: 30,
                                  alignment: Alignment.topCenter,
                                  child: TextFormField(
                                    controller: unitPriceNotifier.value[index],
                                    keyboardType: TextInputType.number,
                                    inputFormatters: Validators.digitsOnly,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    style: kItemsTextStyle,
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
                                          onItemUnitPriceChanged(unitPrice: value, index: index);
                                        });
                                      } else {
                                        onItemUnitPriceChanged(unitPrice: '0', index: index);
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
                                    style: kItemsTextStyle,
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
                                          return Text(
                                            Converter.currency.format(num.tryParse(subTotal[index])),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kItemsTextStyle,
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
                                        quantityNotifier.value.removeAt(index);
                                        unitPriceNotifier.value.removeAt(index);
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
                                        color: kTextColor,
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
              ),
              kHeight5,

              //==================== Price Sections ====================
              PriceSectionWidget(isVertical: isVertical),

              //==================== Payment Buttons Widget ====================
              PaymentButtonsWidget(isVertical: isVertical)
            ],
          ),
        ),
      ),
    );
  }

  //==================== On Item Unit Price Changed ====================
  void onItemUnitPriceChanged({required String unitPrice, required int index}) {
    final qty = num.tryParse(quantityNotifier.value[index].text);
    final unit = num.tryParse(unitPrice);

    log('Unit Price == ' + selectedProductsNotifier.value[index].sellingPrice);

    if (qty != null && unit != null) {
      selectedProductsNotifier.value[index] = selectedProductsNotifier.value[index].copyWith(sellingPrice: unitPrice);
      selectedProductsNotifier.notifyListeners();
      log('Unit Price == ' + selectedProductsNotifier.value[index].sellingPrice);
      getSubTotal(selectedProductsNotifier.value, index, qty);
      getTotalAmount();
      getTotalVAT();
      getTotalPayable();
    }
  }

  //==================== On Item Quantity Changed ====================
  void onItemQuantityChanged(String quantity, List<ItemMasterModel> selectedProducts, int index) {
    final qty = num.tryParse(quantity);
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
      totalVatNotifier.value = _totalVAT;
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
    totalPayableNotifier.value = _totalPayable;
    log('Total Payable == $_totalPayable');
  }

//==================== Reset All Values ====================
  void resetPos() {
    selectedProductsNotifier.value.clear();
    subTotalNotifier.value.clear();
    itemTotalVatNotifier.value.clear();
    customerController.clear();
    unitPriceNotifier.value.clear();
    quantityNotifier.value.clear();
    totalItemsNotifier.value = 0;
    totalQuantityNotifier.value = 0;
    totalAmountNotifier.value = 0;
    totalVatNotifier.value = 0;
    totalPayableNotifier.value = 0;
    customerIdNotifier.value = null;
    customerNameNotifier.value = null;

    selectedProductsNotifier.notifyListeners();
    subTotalNotifier.notifyListeners();
    itemTotalVatNotifier.notifyListeners();
    unitPriceNotifier.notifyListeners();
    quantityNotifier.notifyListeners();
    totalItemsNotifier.notifyListeners();
    totalQuantityNotifier.notifyListeners();
    totalAmountNotifier.notifyListeners();
    totalVatNotifier.notifyListeners();
    totalPayableNotifier.notifyListeners();
    customerIdNotifier.notifyListeners();
    customerNameNotifier.notifyListeners();
  }
}
