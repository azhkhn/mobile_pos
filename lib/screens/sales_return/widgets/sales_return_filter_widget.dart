// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/sales_return/sales_return_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales_return/sales_return_model.dart';
import 'package:shop_ez/screens/sales_return/pages/screen_sales_return_list.dart';

class SalesReturnListFilter extends StatelessWidget {
  SalesReturnListFilter({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final salesReturnDB = SalesReturnDatabase.instance;
  final customerDB = CustomerDatabase.instance;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey();

  //========== Lists ==========
  List<SalesReturnModal> salesList = [], salesReturnsByCustomerList = [], salesReturnByInvoiceList = [];

  //========== TextEditing Controllers ==========
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();

  //========== Value Notifiers ==========
  final salesReturnNotifier = SalesReturnList.salesReturnNotifier;

  //========== Device Utils ==========
  final bool _isTablet = DeviceUtil.isTablet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //==================== Get All Invoice Search Field ====================
            Expanded(
              child: TypeAheadField(
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _invoiceController,
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
                          child: const Icon(
                            Icons.clear,
                            size: 15,
                          ),
                          onTap: () async {
                            _invoiceController.clear();
                            salesReturnByInvoiceList = [];
                            if (salesReturnsByCustomerList.isNotEmpty) {
                              salesReturnNotifier.value = salesReturnsByCustomerList;
                            } else {
                              if (salesList.isNotEmpty) {
                                salesReturnNotifier.value = salesList;
                              } else {
                                salesList = await salesReturnDB.getAllSalesReturns();
                                salesReturnNotifier.value = salesList;
                              }
                            }
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintText: 'Invoice number',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                    )),
                noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Invoice Found!', style: kText12))),
                suggestionsCallback: (pattern) async {
                  if (salesReturnsByCustomerList.isNotEmpty) {
                    return salesReturnsByCustomerList.where((sales) => sales.invoiceNumber!.toLowerCase().contains(pattern));
                  } else {
                    return await salesReturnDB.getSalesReturnByInvoiceSuggestions(pattern);
                  }
                },
                itemBuilder: (context, SalesReturnModal suggestion) {
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
                onSuggestionSelected: (SalesReturnModal suggestion) {
                  _invoiceController.text = suggestion.invoiceNumber!;
                  salesReturnByInvoiceList = [suggestion];
                  salesReturnNotifier.value = [suggestion];

                  log(suggestion.invoiceNumber!);
                },
              ),
            ),

            kWidth10,

            //==================== Get All Customer Search Field ====================
            Expanded(
              child: TypeAheadField(
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _customerController,
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
                          child: const Icon(
                            Icons.clear,
                            size: 15,
                          ),
                          onTap: () async {
                            _customerController.clear();
                            salesReturnsByCustomerList = [];
                            if (salesReturnByInvoiceList.isNotEmpty) {
                              salesReturnNotifier.value = salesReturnByInvoiceList;
                            } else {
                              if (salesList.isNotEmpty) {
                                salesReturnNotifier.value = salesList;
                              } else {
                                salesList = await salesReturnDB.getAllSalesReturns();
                                salesReturnNotifier.value = salesList;
                              }
                            }
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintText: 'Customer',
                      hintStyle: const TextStyle(fontSize: 12),
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
                onSuggestionSelected: (CustomerModel suggestion) async {
                  _invoiceController.clear();
                  _customerController.text = suggestion.customer;
                  final customerId = suggestion.id;
                  salesReturnsByCustomerList = await salesReturnDB.getSalesByCustomerId('$customerId');
                  salesReturnNotifier.value = salesReturnsByCustomerList;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
