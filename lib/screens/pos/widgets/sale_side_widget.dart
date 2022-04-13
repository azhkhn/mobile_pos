// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import 'package:shop_ez/db/db_functions/customer_database/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/pos/widgets/price_section_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../core/utils/device/device.dart';
import '../../../core/utils/snackbar/snackbar.dart';
import '../../../widgets/gesture_dismissible_widget/dismissible_widget.dart';

class SaleSideWidget extends StatelessWidget {
  const SaleSideWidget({
    Key? key,
  }) : super(key: key);

  //==================== Value Notifiers ====================
  static final ValueNotifier<List<ItemMasterModel>> selectedProductsNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<String>> subTotalNotifier = ValueNotifier([]);
  static final ValueNotifier<List<TextEditingController>> quantityNotifier =
      ValueNotifier([]);

  static final ValueNotifier<int?> customerIdNotifier = ValueNotifier(null);
  static final ValueNotifier<String?> customerNameNotifier =
      ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalVatNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalPayableNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final _customerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        selectedProductsNotifier.value.clear();
        subTotalNotifier.value.clear();
        _customerController.clear();
        quantityNotifier.value.clear();
        totalItemsNotifier.value = 0;
        totalQuantityNotifier.value = 0;
        totalAmountNotifier.value = 0;
        totalVatNotifier.value = 0;
        totalPayableNotifier.value = 0;
        customerIdNotifier.value = null;
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
                //==================== Get All Customers Search Field ====================
                Flexible(
                  flex: 8,
                  child: TypeAheadField(
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: false,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _customerController,
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
                              onTap: () {
                                customerIdNotifier.value = null;
                                _customerController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Customer',
                          border: const OutlineInputBorder(),
                        )),
                    noItemsFoundBuilder: (context) => const SizedBox(
                        height: 50,
                        child: Center(child: Text('No Customer Found!'))),
                    suggestionsCallback: (pattern) async {
                      return CustomerDatabase.instance
                          .getCustomerSuggestions(pattern);
                    },
                    itemBuilder: (context, CustomerModel suggestion) {
                      return ListTile(
                        title: AutoSizeText(
                          suggestion.customer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: DeviceUtil.isTablet ? 12 : 10),
                          minFontSize: 10,
                          maxFontSize: 12,
                        ),
                      );
                    },
                    onSuggestionSelected: (CustomerModel suggestion) {
                      _customerController.text = suggestion.customer;
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
                  child: IconButton(
                      constraints: const BoxConstraints(
                        minHeight: 40,
                      ),
                      onPressed: () {
                        if (customerIdNotifier.value != null) {
                          log('$customerIdNotifier');

                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: kTransparentColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (context) => DismissibleWidget(
                                    context: context,
                                    child: CustomBottomSheetWidget(
                                        customerId: customerIdNotifier.value),
                                  ));
                        } else {
                          kSnackBar(
                              context: context,
                              content:
                                  'Please select any Customer to show details!');
                        }
                      },
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.blue,
                      )),
                ),

                //========== Add Customer Button ==========
                Flexible(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add, color: Colors.blue),
                    constraints: const BoxConstraints(
                      minHeight: 40,
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
                child: ValueListenableBuilder(
                  valueListenable: selectedProductsNotifier,
                  builder:
                      (context, List<ItemMasterModel> selectedProducts, child) {
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
                          final ItemMasterModel _product =
                              selectedProducts[index];
                          return TableRow(children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                _product.itemName,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: DeviceUtil.isTablet ? 10 : 7),
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 7,
                                maxFontSize: 10,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                _product.vatMethod == 'Exclusive'
                                    ? Converter.currency
                                        .format(num.parse(_product.itemCost))
                                    : Converter.currency
                                        .format(getExclusiveAmount(_product)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: DeviceUtil.isTablet ? 10 : 7),
                                minFontSize: 7,
                                maxFontSize: 10,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                controller: quantityNotifier.value[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                                style: TextStyle(
                                    fontSize: DeviceUtil.isTablet ? 10 : 7,
                                    color: kBlack),
                                onChanged: (value) {
                                  onItemQuantityChanged(
                                      value, selectedProducts, index);
                                },
                              ),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: ValueListenableBuilder(
                                    valueListenable: subTotalNotifier,
                                    builder: (context, List<String> subTotal,
                                        child) {
                                      return AutoSizeText(
                                        Converter.currency.format(
                                            num.tryParse(subTotal[index])),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                DeviceUtil.isTablet ? 10 : 7),
                                        minFontSize: 7,
                                        maxFontSize: 10,
                                      );
                                    })),
                            Container(
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: () {
                                    selectedProducts.removeAt(index);
                                    subTotalNotifier.value.removeAt(index);
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
            const PriceSectionWidget(),

            //==================== Payment Buttons Widget ====================
            const PaymentButtonsWidget()
          ],
        ),
      ),
    );
  }

  //==================== On Item Quantity Changed ====================
  void onItemQuantityChanged(
      String value, List<ItemMasterModel> selectedProducts, int index) {
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
    if (selectedProducts[index].vatMethod == 'Inclusive') {
      final _exclusiveCost = getExclusiveAmount(selectedProducts[index]);
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
      _totalQuantiy =
          _totalQuantiy! + num.tryParse(quantityNotifier.value[i].value.text)!;
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

  //==================== Get Total VAT ====================
  void getTotalVAT() {
    num _totalVAT = 0;
    num? _subTotal = 0;
    if (subTotalNotifier.value.isEmpty) {
      totalVatNotifier.value = 0;
    } else {
      for (var i = 0; i < subTotalNotifier.value.length; i++) {
        if (selectedProductsNotifier.value[i].vatMethod == 'Inclusive') {
          //Inclusive VAT Calculation...
          _subTotal = num.tryParse(subTotalNotifier.value[i]);
        } else {
          //Exclusive VAT Calculation...
          _subTotal = num.tryParse(subTotalNotifier.value[i]);
        }

        _totalVAT += _subTotal! * 15 / 100;
      }
      log('Total VAT == $_totalVAT');
      totalVatNotifier.value = _totalVAT;
    }
  }

  //==================== Calculate Exclusive Amount from Inclusive Amount ====================
  num getExclusiveAmount(ItemMasterModel item) {
    num _exclusiveAmount = 0;

    final _inclusiveAmount = num.tryParse(item.itemCost);

    _exclusiveAmount = _inclusiveAmount! * 100 / 115;

    // log('Product VAT == ' '${_inclusiveAmount * 15 / 115}');
    // log('Exclusive == ' '${_inclusiveAmount * 100 / 115}');
    // log('Inclusive == ' '${_inclusiveAmount * 115 / 100}');

    return _exclusiveAmount;
  }

//==================== Get Total VAT ====================
  void getTotalPayable() {
    final num _totalPayable =
        totalAmountNotifier.value + totalVatNotifier.value;
    totalPayableNotifier.value = _totalPayable;
    log('Total Payable == $_totalPayable');
  }
}
