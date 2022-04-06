// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/converters.dart';
import 'package:shop_ez/db/db_functions/customer_database/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/pos/screen_pos.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/pos/widgets/price_section_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
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

  static final ValueNotifier<int?> _customerIdNotifier = ValueNotifier(null);
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
        _customerIdNotifier.value = null;
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
                                _customerIdNotifier.value = null;
                                _customerController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Cash Customer',
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
                        title: AutoSizeText(suggestion.customer,
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            )),
                      );
                    },
                    onSuggestionSelected: (CustomerModel suggestion) {
                      _customerController.text = suggestion.customer;
                      _customerIdNotifier.value = suggestion.id;
                      log(suggestion.company);
                    },
                  ),
                ),
                kWidth5,

                //========== View Customer Button ==========
                Flexible(
                  flex: 1,
                  child: IconButton(
                      color: kBlack,
                      onPressed: () {
                        if (_customerIdNotifier.value != null) {
                          log('$_customerIdNotifier');

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
                                        customerId: _customerIdNotifier.value),
                                  ));
                        } else {
                          showSnackBar(
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
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.blue,
                      )),
                ),
              ],
            ),

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
                          return TableRow(children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.white,
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                selectedProducts[index].itemName,
                                softWrap: true,
                                style: const TextStyle(fontSize: 9),
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 8,
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
                                selectedProducts[index].vatMethod == 'Inclusive'
                                    ? Converter.roundNumber.format(
                                        getExclusiveAmount(
                                            selectedProducts[index]))
                                    : selectedProducts[index].itemCost,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 9),
                                minFontSize: 8,
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
                                style:
                                    const TextStyle(fontSize: 9, color: kBlack),
                                onChanged: (value) {
                                  final qty = num.tryParse(value);
                                  if (qty != null) {
                                    log('$qty');
                                    getSubTotal(selectedProducts, index, qty);
                                    getTotalQuantity();
                                    getTotalAmount();
                                    getTotalVAT();
                                    getTotalPayable();
                                  }
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
                                        selectedProducts[index].vatMethod ==
                                                'Inclusive'
                                            ? Converter.roundNumber.format(
                                                num.tryParse(subTotal[index]))
                                            : subTotal[index],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 9),
                                        minFontSize: 8,
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

  //==================== Get SubTotal Amount ====================
  void getSubTotal(List<ItemMasterModel> selectedProducts, int index, num qty) {
    final cost = num.tryParse(
        selectedProducts[index].itemCost.replaceAll(RegExp(r','), ''));
    if (selectedProducts[index].vatMethod == 'Inclusive') {
      final _exclusiveCost = getExclusiveAmount(selectedProducts[index]);
      final _subTotal = _exclusiveCost * qty;
      log('$_subTotal');
      subTotalNotifier.value[index] = '$_subTotal';
      log('inclusive');
    } else {
      final _subTotal = cost! * qty;
      subTotalNotifier.value[index] = '$_subTotal';
      log('exclusive');
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
          subTotal = num.tryParse(
              subTotalNotifier.value[i].replaceAll(RegExp(r','), ''));
        }

        log('subtotal ==  $subTotal');

        _totalAmount = _totalAmount! + subTotal!;
        totalAmountNotifier.value = _totalAmount;
      }
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
          log('Inclusive VAT Calculation...');
          _subTotal = num.tryParse(
              subTotalNotifier.value[i].replaceAll(RegExp(r','), ''));
        } else {
          log('Exclusive VAT Calculation...');
          _subTotal = num.tryParse(
              subTotalNotifier.value[i].replaceAll(RegExp(r','), ''));
        }

        _totalVAT += _subTotal! * 15 / 100;
        log('_totalVAT == ${_subTotal * 15 / 100}');
      }

      totalVatNotifier.value = _totalVAT;
    }
  }

  //==================== Calculate Exclusive Amount from Inclusive Amount ====================
  num getExclusiveAmount(ItemMasterModel item) {
    num _exclusiveAmount = 0;

    final _inclusiveAmount =
        num.tryParse(item.itemCost.replaceAll(RegExp(r','), ''));

    _exclusiveAmount = _inclusiveAmount! * 100 / 115;

    log('VAT == ' '${_inclusiveAmount * 15 / 115}');
    // log('Exclusive == ' '${_inclusiveAmount * 100 / 115}');
    // log('Inclusive == ' '${_inclusiveAmount * 115 / 100}');

    return _exclusiveAmount;
  }

//==================== Get Total VAT ====================
  void getTotalPayable() {
    totalPayableNotifier.value =
        totalAmountNotifier.value + totalVatNotifier.value;
  }
}
