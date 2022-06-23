// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/sales/pages/screen_sales_list.dart';

class SalesListFilter extends StatelessWidget {
  SalesListFilter({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final salesDB = SalesDatabase.instance;
  final customerDB = CustomerDatabase.instance;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey();

  //========== Lists ==========
  List<SalesModel> salesList = [], salesByCustomerList = [], salesByInvoiceList = [];

  //========== TextEditing Controllers ==========
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();

  //========== Value Notifiers ==========
  final salesNotifier = SalesList.salesNotifier;

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
                            salesByInvoiceList = [];
                            if (salesByCustomerList.isNotEmpty) {
                              salesNotifier.value = salesByCustomerList;
                            } else {
                              if (salesList.isNotEmpty) {
                                salesNotifier.value = salesList;
                              } else {
                                salesList = await salesDB.getAllSales();
                                salesNotifier.value = salesList;
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
                  if (salesByCustomerList.isNotEmpty) {
                    return salesByCustomerList.where((sales) => sales.invoiceNumber!.toLowerCase().contains(pattern));
                  } else {
                    return await salesDB.getSalesByInvoiceSuggestions(pattern);
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
                  _invoiceController.text = suggestion.invoiceNumber!;
                  salesByInvoiceList = [suggestion];
                  salesNotifier.value = [suggestion];

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
                            salesByCustomerList = [];
                            if (salesByInvoiceList.isNotEmpty) {
                              salesNotifier.value = salesByInvoiceList;
                            } else {
                              if (salesList.isNotEmpty) {
                                salesNotifier.value = salesList;
                              } else {
                                salesList = await salesDB.getAllSales();
                                salesNotifier.value = salesList;
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
                  salesByCustomerList = await salesDB.getSalesByCustomerId('$customerId');
                  salesNotifier.value = salesByCustomerList;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
