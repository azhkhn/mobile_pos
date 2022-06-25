// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/purchase/pages/screen_list_purchases.dart';

class PurchaseListFilter extends StatelessWidget {
  PurchaseListFilter({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final purchaseDB = PurchaseDatabase.instance;
  final supplierDB = SupplierDatabase.instance;

  //========== Global Keys ==========
  final GlobalKey<FormState> _formKey = GlobalKey();

  //========== Lists ==========
  List<PurchaseModel> purchaseList = [], purchaseBySupllierList = [], purchaseByInvoiceList = [];

  //========== TextEditing Controllers ==========
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  //========== Value Notifiers ==========
  final purchaseNotifier = PurchasesList.purchasesNotifier;

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
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: const Icon(Icons.clear),
                          onTap: () async {
                            _invoiceController.clear();
                            purchaseByInvoiceList = [];
                            if (purchaseBySupllierList.isNotEmpty) {
                              purchaseNotifier.value = purchaseBySupllierList;
                            } else {
                              if (purchaseList.isNotEmpty) {
                                purchaseNotifier.value = purchaseList;
                              } else {
                                purchaseList = await purchaseDB.getAllPurchases();
                                purchaseNotifier.value = purchaseList;
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
                  // if (purchaseList.isNotEmpty) {
                  //   log('old again!!');
                  //   return purchaseList.where((purchase) => [
                  //         purchase.invoiceNumber!.toLowerCase(),
                  //         purchase.referenceNumber.toLowerCase()
                  //       ].contains(pattern));
                  // }

                  return await purchaseDB.getPurchaseByInvoiceSuggestions(pattern);
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
                  _invoiceController.text = suggestion.invoiceNumber!;
                  purchaseByInvoiceList = [suggestion];
                  purchaseNotifier.value = [suggestion];

                  log(suggestion.invoiceNumber!);
                },
              ),
            ),

            kWidth10,

            //==================== Get All Supplier Search Field ====================
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
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: const Icon(Icons.clear),
                          onTap: () async {
                            _supplierController.clear();
                            purchaseBySupllierList = [];
                            if (purchaseByInvoiceList.isNotEmpty) {
                              purchaseNotifier.value = purchaseByInvoiceList;
                            } else {
                              if (purchaseList.isNotEmpty) {
                                purchaseNotifier.value = purchaseList;
                              } else {
                                purchaseList = await purchaseDB.getAllPurchases();
                                purchaseNotifier.value = purchaseList;
                              }
                            }
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintText: 'Supplier',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                    )),
                noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Supplier Found!', style: kText12))),
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
                  final supplierId = suggestion.id;
                  purchaseBySupllierList = await purchaseDB.getPurchasesBySupplierId('$supplierId');
                  purchaseNotifier.value = purchaseBySupllierList;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
