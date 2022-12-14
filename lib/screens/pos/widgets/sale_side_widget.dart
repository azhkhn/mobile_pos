// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_alert.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/debouncer/debouncer.dart';
import 'package:mobile_pos/core/utils/validators/validators.dart';
import 'package:mobile_pos/db/db_functions/customer/customer_database.dart';
import 'package:mobile_pos/model/customer/customer_model.dart';
import 'package:mobile_pos/model/item_master/item_master_model.dart';
import 'package:mobile_pos/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:mobile_pos/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:mobile_pos/screens/pos/widgets/price_section_widget.dart';
import 'package:mobile_pos/screens/pos/widgets/product_side_widget.dart';
import 'package:mobile_pos/screens/pos/widgets/sales_table_header_widget.dart';
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
  static final ValueNotifier<List<int>> vatRateNotifier = ValueNotifier([]);

  static final ValueNotifier<CustomerModel?> customerNotifier = ValueNotifier(null);
  static final ValueNotifier<num> totalItemsNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalQuantityNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalAmountNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalVatNotifier = ValueNotifier(0);
  static final ValueNotifier<num> totalPayableNotifier = ValueNotifier(0);

  //==================== TextEditing Controllers ====================
  static final TextEditingController customerController = TextEditingController();

  //==================== Global Keys ====================
  // static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = DeviceUtil.screenSize(context);
    final bool isSmall = DeviceUtil.isSmall;
    return WillPopScope(
      onWillPop: () async {
        if (selectedProductsNotifier.value.isEmpty) {
          resetPos();

          return true;
        } else {
          showDialog(
              context: context,
              builder: (context) => KAlertDialog(
                    content: const Text('Are you sure want to cancel the sale?'),
                    submitAction: () async {
                      Navigator.pop(context);
                      resetPos();
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
                            minCharsForSuggestions: 0,
                            debounceDuration: const Duration(milliseconds: 500),
                            hideSuggestionsOnKeyboardHide: true,
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: customerController,
                                style: kText_10_12,
                                decoration: InputDecoration(
                                  // constraints: const BoxConstraints(maxHeight: 35),
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
                            noItemsFoundBuilder: (context) =>
                                const SizedBox(height: 50, child: Center(child: Text('No Customer Found!', style: kText12))),
                            suggestionsCallback: (pattern) async {
                              return CustomerDatabase.instance.getCustomerSuggestions(pattern);
                            },
                            itemBuilder: (context, CustomerModel suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion.customer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10),
                                ),
                              );
                            },
                            onSuggestionSelected: (CustomerModel suggestion) {
                              customerController.text = suggestion.customer;
                              customerNotifier.value = suggestion;
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
                                  minHeight: 20,
                                  maxHeight: 20,
                                ),
                                onPressed: () {
                                  if (customerNotifier.value != null) {
                                    log('Customer Id == ${customerNotifier.value}');

                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: kTransparentColor,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                        builder: (context) => DismissibleWidget(
                                              context: context,
                                              child: CustomBottomSheetWidget(model: customerNotifier.value),
                                            ));
                                  } else {
                                    kSnackBar(context: context, content: 'Please select any Customer to show details!');
                                  }
                                },
                                icon: Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                  size: isSmall ? 22 : 25,
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
                                minHeight: 20,
                                maxHeight: 20,
                              ),
                              onPressed: () async {
                                // OrientationMode.isLandscape = false;
                                // await OrientationMode.toPortrait();
                                final CustomerModel? addedCustomer =
                                    await Navigator.pushNamed(context, routeAddCustomer, arguments: {'from': true}) as CustomerModel;

                                if (addedCustomer != null) {
                                  customerController.text = addedCustomer.customer;
                                  customerNotifier.value = addedCustomer;
                                  log(addedCustomer.company);
                                }

                                // await OrientationMode.toLandscape();
                              },
                              icon: Icon(
                                Icons.person_add,
                                color: Colors.blue,
                                size: isSmall ? 22 : 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              if (!isVertical) kHeight3,
              //==================== Table Header ====================
              const SalesTableHeaderWidget(),

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
                          selectedProductsNotifier.value.length,
                          (index) {
                            final ItemMasterModel _product = selectedProducts[index];
                            return TableRow(children: [
                              //==================== Item Name ====================
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

                              //==================== Unit Price ====================
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: isSmall ? 25 : 30,
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
                                    if (value == null || value.isEmpty || value == '.') {
                                      return '*';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final int itemId = selectedProducts[index].id!;
                                    if (num.tryParse(value) != null) {
                                      if (num.parse(value) <= 0) {
                                        quantityNotifier.value[index].clear();
                                      } else {
                                        Debouncer().run(() {
                                          if (value.isNotEmpty && value != '.') {
                                            final num _newQuantity = num.parse(value);

                                            onItemQuantityChanged(value, selectedProducts, index);

                                            log('new Quantity == ' + _newQuantity.toString());

                                            ProductSideWidget.notifyStock(itemId: itemId, bulk: true, quantity: _newQuantity);
                                          }
                                        });
                                      }
                                    } else {
                                      if (value.isEmpty) {
                                        onItemQuantityChanged('0', selectedProducts, index);
                                        ProductSideWidget.notifyStock(itemId: itemId, bulk: true, reset: true);
                                      }
                                    }
                                  },
                                ),
                              ),
                              //==================== Sub Total ====================
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
                              //==================== Delete Icon ====================
                              Container(
                                  color: Colors.white,
                                  height: isSmall ? 25 : 30,
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    onPressed: () {
                                      final int itemId = selectedProducts[index].id!;
                                      log('id = $itemId');
                                      selectedProducts.removeAt(index);
                                      subTotalNotifier.value.removeAt(index);
                                      vatRateNotifier.value.removeAt(index);
                                      itemTotalVatNotifier.value.removeAt(index);
                                      quantityNotifier.value.removeAt(index);
                                      unitPriceNotifier.value.removeAt(index);
                                      // selectedProductsNotifier.value.removeAt(index);

                                      subTotalNotifier.notifyListeners();
                                      selectedProductsNotifier.notifyListeners();
                                      totalItemsNotifier.value -= 1;
                                      getTotalQuantity();
                                      getTotalAmount();
                                      getTotalVAT();
                                      getTotalPayable();
                                      ProductSideWidget.notifyStock(itemId: itemId, bulk: true, reset: true);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: isSmall ? 12 : 16,
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
  void getSubTotal(List<ItemMasterModel> selectedProducts, int i, num qty) async {
    final cost = num.tryParse(selectedProducts[i].sellingPrice);

    final vatRate = vatRateNotifier.value[i];
    if (selectedProducts[i].vatMethod == 'Inclusive') {
      final _exclusiveCost = getExclusiveAmount(sellingPrice: selectedProducts[i].sellingPrice, vatRate: vatRate);
      final _subTotal = _exclusiveCost * qty;
      subTotalNotifier.value[i] = '$_subTotal';
    } else {
      final _subTotal = cost! * qty;
      subTotalNotifier.value[i] = '$_subTotal';
    }

    subTotalNotifier.notifyListeners();
  }

  //==================== Get Total Quantity ====================
  void getTotalQuantity() async {
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
    num sellingPrice = num.parse(amount);

    if (vatMethod == 'Inclusive') {
      sellingPrice = getExclusiveAmount(sellingPrice: '$sellingPrice', vatRate: vatRate);
    }

    itemTotalVat = sellingPrice * vatRate / 100;
    log('Item VAT == $itemTotalVat');
    itemTotalVatNotifier.value.add('$itemTotalVat');
  }

  //==================== Get Total VAT ====================
  void getTotalVAT() async {
    num _totalVAT = 0;
    int _vatRate;
    num _subTotal;

    if (subTotalNotifier.value.isEmpty) {
      totalVatNotifier.value = 0;
    } else {
      for (var i = 0; i < subTotalNotifier.value.length; i++) {
        _subTotal = num.parse(subTotalNotifier.value[i]);

        _vatRate = vatRateNotifier.value[i];
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
  void resetPos({bool notify = false}) {
    selectedProductsNotifier.value.clear();
    subTotalNotifier.value.clear();
    vatRateNotifier.value.clear();
    itemTotalVatNotifier.value.clear();
    customerController.clear();
    quantityNotifier.value.clear();
    unitPriceNotifier.value.clear();
    totalItemsNotifier.value = 0;
    totalQuantityNotifier.value = 0;
    totalAmountNotifier.value = 0;
    totalVatNotifier.value = 0;
    totalPayableNotifier.value = 0;
    customerNotifier.value = null;
    ProductSideWidget.itemsNotifier.value.clear();
    ProductSideWidget.stableItemsNotifier.value.clear();
    ProductSideWidget.builderModel = null;

    if (notify) {
      selectedProductsNotifier.notifyListeners();
      subTotalNotifier.notifyListeners();
      vatRateNotifier.notifyListeners();
      itemTotalVatNotifier.notifyListeners();
      unitPriceNotifier.notifyListeners();
      quantityNotifier.notifyListeners();
      totalItemsNotifier.notifyListeners();
      totalQuantityNotifier.notifyListeners();
      totalAmountNotifier.notifyListeners();
      totalVatNotifier.notifyListeners();
      totalPayableNotifier.notifyListeners();
      customerNotifier.notifyListeners();
      ProductSideWidget.itemsNotifier.notifyListeners();
      ProductSideWidget.stableItemsNotifier.notifyListeners();
    }
  }
}
