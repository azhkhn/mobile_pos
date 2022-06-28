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
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/reports/pages/sales_report/screen_sales_report.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class SalesReportFilter extends StatelessWidget {
  SalesReportFilter({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final SalesDatabase salesDB = SalesDatabase.instance;
  final CustomerDatabase customerDB = CustomerDatabase.instance;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> _dropDownKey = GlobalKey();

  //========== Lists ==========
  List<SalesModel> salesList = ScreenSalesReport.salesList, salesByCustomerList = [], salesByInvoiceList = [];

  //========== TextEditing Controllers ==========
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _paymentStatusController = TextEditingController();

  //========== Value Notifiers ==========
  final ValueNotifier<List<SalesModel>> salesNotifier = ScreenSalesReport.salesNotifier;

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
              //==================== Get All Customer Search Field ====================
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
                              salesByCustomerList.clear();
                              if (salesByInvoiceList.isNotEmpty) {
                                salesNotifier.value = salesByInvoiceList;
                              } else {
                                if (_dateController.text.isEmpty) {
                                  salesNotifier.value = salesList;
                                }
                              }
                            },
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Customer',
                        hintStyle: kText12,
                        border: const OutlineInputBorder(),
                      )),
                  noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Customer Found!', style: kText12))),
                  suggestionsCallback: (pattern) async {
                    return await customerDB.getCustomerSuggestions(pattern);
                  },
                  itemBuilder: (context, CustomerModel suggestion) {
                    return ListTile(
                      title: AutoSizeText(
                        suggestion.customer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: _isTablet ? 12 : 10),
                        minFontSize: 10,
                        maxFontSize: 12,
                      ),
                    );
                  },
                  onSuggestionSelected: (CustomerModel selectedCustomer) async {
                    _dropDownKey.currentState!.reset();
                    _invoiceController.clear();
                    _dateController.clear();

                    _customerController.text = selectedCustomer.customer;

                    //fetch all sales done by selected customer
                    salesByCustomerList = salesList.where((sale) => sale.customerId == selectedCustomer.id).toList();

                    //Notify UI
                    salesNotifier.value = salesByCustomerList;
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
                              salesByInvoiceList.clear();
                              if (salesByCustomerList.isNotEmpty) {
                                salesNotifier.value = salesByCustomerList;
                              } else {
                                if (_dateController.text.isEmpty) {
                                  salesNotifier.value = salesList;
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
                  noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Invoice Found!', style: kText12))),
                  suggestionsCallback: (pattern) async {
                    if (salesByCustomerList.isNotEmpty) {
                      return salesByCustomerList.where((sales) => sales.invoiceNumber!.toLowerCase().contains(pattern));
                    } else {
                      // return await salesDB.getSalesByInvoiceSuggestions(pattern);
                      return salesList.where((sale) => sale.invoiceNumber!.toLowerCase().contains(pattern)).toList();
                    }
                  },
                  itemBuilder: (context, SalesModel suggestion) {
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
                  onSuggestionSelected: (SalesModel suggestion) {
                    _dropDownKey.currentState!.reset();
                    _dateController.clear();
                    _invoiceController.text = suggestion.invoiceNumber!;
                    salesByInvoiceList = [suggestion];
                    salesNotifier.value = [suggestion];

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
                        if (_dateController.text.isNotEmpty && salesByCustomerList.isNotEmpty) {
                          salesNotifier.value = salesByCustomerList;
                        } else if (_dateController.text.isNotEmpty) {
                          salesNotifier.value = salesList;
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

                      final List<SalesModel> _salesByDate = [];

                      final bool isFilter = salesByCustomerList.isNotEmpty;

                      for (SalesModel transaction in isFilter ? salesByCustomerList : salesList) {
                        final DateTime _transactionDate = DateTime.parse(transaction.dateTime);

                        final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                        if (isSameDate) {
                          _salesByDate.add(transaction);
                        }
                      }
                      salesNotifier.value = _salesByDate;
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
                    salesByInvoiceList.clear();
                    _paymentStatusController.text = payment.toString();

                    if (payment != 'All') {
                      if (_dateController.text.isNotEmpty) {
                        salesNotifier.value = salesNotifier.value.where((sale) => sale.paymentStatus == payment).toList();
                      } else if (salesByCustomerList.isNotEmpty) {
                        salesNotifier.value = salesByCustomerList.where((sale) => sale.paymentStatus == payment).toList();
                      } else {
                        salesNotifier.value = salesList.where((sale) => sale.paymentStatus == payment).toList();
                      }
                    } else {
                      if (_dateController.text.isNotEmpty) {
                        salesNotifier.value = salesNotifier.value.where((sale) => sale.paymentStatus != payment).toList();
                      } else if (salesByCustomerList.isNotEmpty) {
                        salesNotifier.value = salesByCustomerList.where((sale) => sale.paymentStatus != payment).toList();
                      } else {
                        salesNotifier.value = salesList.where((sale) => sale.paymentStatus != payment).toList();
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
