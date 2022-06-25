// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/purchase_return/purchase_return_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/purchase_return/purchase_return_modal.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/purchase_return/pages/screen_purchase_return_list.dart';

class PurchaseReturnListFilter extends StatelessWidget {
  PurchaseReturnListFilter({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final purchaseReturnDB = PurchaseReturnDatabase.instance;
  final supplierDB = SupplierDatabase.instance;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey();

  //========== Lists ==========
  List<PurchaseReturnModel> purchaseReturnsList = [], purchaseReturnsByCustomerList = [], purchaseReturnByInvoiceList = [];

  //========== TextEditing Controllers ==========
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  //========== Value Notifiers ==========
  final purchaseReturnNotifier = PurchaseReturnList.purchasesReturnNotifier;

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
                minCharsForSuggestions: 0,
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
                            purchaseReturnByInvoiceList = [];
                            if (purchaseReturnsByCustomerList.isNotEmpty) {
                              purchaseReturnNotifier.value = purchaseReturnsByCustomerList;
                            } else {
                              if (purchaseReturnsList.isNotEmpty) {
                                purchaseReturnNotifier.value = purchaseReturnsList;
                              } else {
                                purchaseReturnsList = await purchaseReturnDB.getAllPurchasesReturns();
                                purchaseReturnNotifier.value = purchaseReturnsList;
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
                  if (purchaseReturnsByCustomerList.isNotEmpty) {
                    return purchaseReturnsByCustomerList.where((purchase) => purchase.invoiceNumber!.toLowerCase().contains(pattern));
                  } else {
                    return await purchaseReturnDB.getPurchasesByInvoiceSuggestions(pattern);
                  }
                },
                itemBuilder: (context, PurchaseReturnModel suggestion) {
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
                onSuggestionSelected: (PurchaseReturnModel suggestion) {
                  _invoiceController.text = suggestion.invoiceNumber!;
                  purchaseReturnByInvoiceList = [suggestion];
                  purchaseReturnNotifier.value = [suggestion];

                  log(suggestion.invoiceNumber!);
                },
              ),
            ),

            kWidth10,

            //==================== Get All Customer Search Field ====================
            Expanded(
              child: TypeAheadField(
                minCharsForSuggestions: 0,
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: _supplierController,
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
                            _supplierController.clear();
                            purchaseReturnsByCustomerList = [];
                            if (purchaseReturnByInvoiceList.isNotEmpty) {
                              purchaseReturnNotifier.value = purchaseReturnByInvoiceList;
                            } else {
                              if (purchaseReturnsList.isNotEmpty) {
                                purchaseReturnNotifier.value = purchaseReturnsList;
                              } else {
                                purchaseReturnsList = await purchaseReturnDB.getAllPurchasesReturns();
                                purchaseReturnNotifier.value = purchaseReturnsList;
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
                  return await supplierDB.getSupplierSuggestions(pattern);
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
                onSuggestionSelected: (SupplierModel suggestion) async {
                  _invoiceController.clear();
                  _supplierController.text = suggestion.supplierName;
                  final customerId = suggestion.id;
                  purchaseReturnsByCustomerList = await purchaseReturnDB.getPurchasesBySupplierId('$customerId');
                  purchaseReturnNotifier.value = purchaseReturnsByCustomerList;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
