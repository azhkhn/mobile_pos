// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/date_time.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/reports/pages/purchases_report/screen_purchases_report.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class PurchasesReportFilter extends StatelessWidget {
  PurchasesReportFilter({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final PurchaseDatabase purchasesDatabase = PurchaseDatabase.instance;
  final SupplierDatabase supplierDatabase = SupplierDatabase.instance;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> _dropDownKey = GlobalKey();

  //========== Lists ==========
  List<PurchaseModel> purchasesList = ScreenPurchasesReport.purchasesList, purchasesBySupplierList = [], purchasesByInvoiceList = [];

  //========== TextEditing Controllers ==========
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _paymentStatusController = TextEditingController();

  //========== Value Notifiers ==========
  final ValueNotifier<List<PurchaseModel>> purchasesNotifier = ScreenPurchasesReport.purchasesNotifier;

  //========== Device Utils ==========
  final bool _isTablet = DeviceUtil.isTablet;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //==================== Get All Supplier Search Field ====================
              Expanded(
                child: TypeAheadField(
                  minCharsForSuggestions: 0,
                  debounceDuration: const Duration(milliseconds: 500),
                  hideSuggestionsOnKeyboardHide: true,
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _customerController,
                      style: kText12,
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
                              _customerController.clear();
                              purchasesBySupplierList.clear();
                              if (purchasesByInvoiceList.isNotEmpty) {
                                purchasesNotifier.value = purchasesByInvoiceList;
                              } else {
                                if (_dateController.text.isEmpty) {
                                  purchasesNotifier.value = purchasesList;
                                }
                              }
                            },
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Supplier',
                        hintStyle: kText12,
                        border: const OutlineInputBorder(),
                      )),
                  noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No supplier found!', style: kText12))),
                  suggestionsCallback: (pattern) async {
                    return await supplierDatabase.getSupplierSuggestions(pattern);
                  },
                  itemBuilder: (context, SupplierModel suggestion) {
                    return ListTile(
                      title: AutoSizeText(
                        suggestion.supplierName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: _isTablet ? 12 : 10),
                        minFontSize: 10,
                        maxFontSize: 12,
                      ),
                    );
                  },
                  onSuggestionSelected: (SupplierModel selectedSupplier) async {
                    _dropDownKey.currentState!.reset();
                    _invoiceController.clear();
                    _dateController.clear();

                    _customerController.text = selectedSupplier.supplierName;

                    //fetch all purchases done by selected customer
                    purchasesBySupplierList = purchasesList.where((purchase) => purchase.supplierId == selectedSupplier.id).toList();

                    //Notify UI
                    purchasesNotifier.value = purchasesBySupplierList;
                  },
                ),
              ),

              kWidth5,

              //==================== Get All Invoice Search Field ====================
              Expanded(
                child: TypeAheadField(
                  minCharsForSuggestions: 0,
                  debounceDuration: const Duration(milliseconds: 500),
                  hideSuggestionsOnKeyboardHide: true,
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _invoiceController,
                      style: kText12,
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
                              _invoiceController.clear();
                              purchasesByInvoiceList.clear();
                              if (purchasesBySupplierList.isNotEmpty) {
                                purchasesNotifier.value = purchasesBySupplierList;
                              } else {
                                if (_dateController.text.isEmpty) {
                                  purchasesNotifier.value = purchasesList;
                                }
                              }
                            },
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Invoice number',
                        hintStyle: kText12,
                        border: const OutlineInputBorder(),
                      )),
                  noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No invoice found!', style: kText12))),
                  suggestionsCallback: (pattern) async {
                    if (purchasesBySupplierList.isNotEmpty) {
                      return purchasesBySupplierList.where((purchases) => purchases.invoiceNumber!.toLowerCase().contains(pattern));
                    } else {
                      // return await purchasesDatabase.getPurchaseByInvoiceSuggestions(pattern);
                      return purchasesList.where((purchases) => purchases.invoiceNumber!.toLowerCase().contains(pattern)).toList();
                    }
                  },
                  itemBuilder: (context, PurchaseModel suggestion) {
                    return ListTile(
                      title: AutoSizeText(
                        suggestion.invoiceNumber!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: _isTablet ? 12 : 10),
                        minFontSize: 10,
                        maxFontSize: 12,
                      ),
                    );
                  },
                  onSuggestionSelected: (PurchaseModel suggestion) {
                    _dropDownKey.currentState!.reset();
                    _dateController.clear();
                    _invoiceController.text = suggestion.invoiceNumber!;
                    purchasesByInvoiceList = [suggestion];
                    purchasesNotifier.value = [suggestion];

                    log(suggestion.invoiceNumber!);
                  },
                ),
              ),
            ],
          ),
          kHeight5,
          Row(
            children: [
              Flexible(
                child: TextFeildWidget(
                  hintText: 'Date ',
                  controller: _dateController,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 10,
                    minHeight: 10,
                  ),
                  suffixIcon: Padding(
                    padding: kClearTextIconPadding,
                    child: InkWell(
                      child: const Icon(Icons.clear, size: 15),
                      onTap: () async {
                        if (_dateController.text.isNotEmpty && purchasesBySupplierList.isNotEmpty) {
                          purchasesNotifier.value = purchasesBySupplierList;
                        } else if (_dateController.text.isNotEmpty) {
                          purchasesNotifier.value = purchasesList;
                        }

                        _dateController.clear();
                      },
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  hintStyle: kText12,
                  readOnly: true,
                  isDense: true,
                  textStyle: kText12,
                  inputBorder: const OutlineInputBorder(),
                  onTap: () async {
                    final _selectedDate = await DateTimeUtils.instance.datePicker(context);

                    if (_selectedDate != null) {
                      _dropDownKey.currentState!.reset();
                      _invoiceController.clear();
                      final parseDate = Converter.dateFormat.format(_selectedDate);
                      _dateController.text = parseDate.toString();

                      final List<PurchaseModel> _purchasesByDate = [];

                      final bool isFilter = purchasesBySupplierList.isNotEmpty;

                      for (PurchaseModel transaction in isFilter ? purchasesBySupplierList : purchasesList) {
                        final DateTime _transactionDate = DateTime.parse(transaction.dateTime);

                        final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                        if (isSameDate) {
                          _purchasesByDate.add(transaction);
                        }
                      }
                      purchasesNotifier.value = _purchasesByDate;
                    }
                  },
                ),
              ),
              kWidth5,

              //========== Stock Dropdown ==========
              Flexible(
                flex: 1,
                child: DropdownButtonFormField(
                  key: _dropDownKey,
                  hint: const Text('Payment Status', style: kText12),
                  style: kText12Black,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(maxHeight: 45),
                    fillColor: kWhite,
                    filled: true,
                    isDense: true,
                    errorStyle: TextStyle(fontSize: 0.01),
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                  items: ['All', 'Paid', 'Partial', 'Credit', 'Returned']
                      .map((values) => DropdownMenuItem<String>(
                            value: values,
                            child: Text(values),
                          ))
                      .toList(),
                  onChanged: (String? payment) {
                    _invoiceController.clear();
                    purchasesByInvoiceList.clear();
                    _paymentStatusController.text = payment.toString();

                    if (payment != 'All') {
                      if (_dateController.text.isNotEmpty) {
                        purchasesNotifier.value = purchasesNotifier.value.where((purchase) => purchase.paymentStatus == payment).toList();
                      } else if (purchasesBySupplierList.isNotEmpty) {
                        purchasesNotifier.value = purchasesBySupplierList.where((purchase) => purchase.paymentStatus == payment).toList();
                      } else {
                        purchasesNotifier.value = purchasesList.where((purchase) => purchase.paymentStatus == payment).toList();
                      }
                    } else {
                      if (_dateController.text.isNotEmpty) {
                        purchasesNotifier.value = purchasesNotifier.value.where((purchase) => purchase.paymentStatus != payment).toList();
                      } else if (purchasesBySupplierList.isNotEmpty) {
                        purchasesNotifier.value = purchasesBySupplierList.where((purchase) => purchase.paymentStatus != payment).toList();
                      } else {
                        purchasesNotifier.value = purchasesList.where((purchase) => purchase.paymentStatus != payment).toList();
                      }
                    }

                    log('Payment filter = $payment');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
