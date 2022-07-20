// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_card_widget.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenAccountPayable extends StatelessWidget {
  ScreenAccountPayable({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  //==================== ValueNotifer ====================
  final ValueNotifier<List<PurchaseModel>> payableNotifier = ValueNotifier([]);

  //==================== List ====================
  List<PurchaseModel> payableList = [];
  List<PurchaseModel> payablebySupplier = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Pending Invoice ~ Payable'),
      body: SafeArea(
          child: ItemScreenPaddingWidget(
        //=============================================================================
        //==================== Supplier and Date Filter Fields ====================
        //=============================================================================
        child: Column(
          children: [
            Row(
              children: [
                //==================== Supplier Search Field ====================
                Flexible(
                  flex: 1,
                  child: TypeAheadField(
                    minCharsForSuggestions: 0,
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: supplierController,
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
                            child: const Icon(Icons.clear, size: 15),
                            onTap: () async {
                              supplierController.clear();
                              dateController.clear();
                              payablebySupplier.clear();
                              if (payableList.isNotEmpty) {
                                payableNotifier.value = payableList;
                              } else {
                                await futurePayable();
                                payableNotifier.value = payableList;
                              }
                            },
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Supplier',
                        hintStyle: kText12,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) payablebySupplier.clear();
                      },
                    ),
                    noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Supplier Found!', style: kText10))),
                    suggestionsCallback: (pattern) async {
                      return SupplierDatabase.instance.getSupplierSuggestions(pattern);
                    },
                    itemBuilder: (context, SupplierModel suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.supplierName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kText_10_12,
                        ),
                      );
                    },
                    onSuggestionSelected: (SupplierModel selectedSupplier) async {
                      dateController.clear();
                      supplierController.text = selectedSupplier.supplierName;
                      log('Selected Supplier = ' + selectedSupplier.supplierName);

                      //Notify Transactions by selected Supplier
                      payablebySupplier = payableList.where((sale) => sale.supplierId == selectedSupplier.id).toList();
                      payableNotifier.value = payablebySupplier;
                    },
                  ),
                ),
                kWidth5,

                //==================== Date Search Field ====================
                Flexible(
                  flex: 1,
                  child: TextFeildWidget(
                    hintText: 'Date ',
                    controller: dateController,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                    suffixIcon: Padding(
                      padding: kClearTextIconPadding,
                      child: InkWell(
                        child: const Icon(Icons.clear, size: 15),
                        onTap: () async {
                          supplierController.clear();
                          dateController.clear();
                          payablebySupplier.clear();
                          if (payableList.isNotEmpty) {
                            payableNotifier.value = payableList;
                          } else {
                            await futurePayable();
                            payableNotifier.value = payableList;
                          }
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
                      final _selectedDate = await datePicker(context);

                      if (_selectedDate != null) {
                        final parseDate = Converter.dateFormat.format(_selectedDate);
                        dateController.text = parseDate.toString();

                        final List<PurchaseModel> _transactionByDate = [];

                        final bool isFilter = payablebySupplier.isNotEmpty;

                        for (PurchaseModel payable in isFilter ? payablebySupplier : payableList) {
                          final DateTime _transactionDate = DateTime.parse(payable.dateTime);

                          final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                          if (isSameDate) {
                            _transactionByDate.add(payable);
                          }
                        }
                        payableNotifier.value = _transactionByDate;
                        payableNotifier.notifyListeners();
                      }
                    },
                  ),
                ),
              ],
            ),

            kHeight10,

            // == == == == == Transactions == == == == ==
            Expanded(
              child: FutureBuilder(
                future: futurePayable(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                    default:
                      if (!snapshot.hasData) return const Center(child: Text('No recent payable'));

                      final List<PurchaseModel> _recentPayments = snapshot.data as List<PurchaseModel>;
                      payableNotifier.value = _recentPayments;

                      return _recentPayments.isNotEmpty
                          ? ValueListenableBuilder(
                              valueListenable: payableNotifier,
                              builder: (context, List<PurchaseModel> _purchases, __) {
                                return ListView.builder(
                                  itemCount: _purchases.length,
                                  itemBuilder: (ctx, index) {
                                    final PurchaseModel purchase = _purchases[index];

                                    //==================== Payment Report Card ====================
                                    return PurchaseCardWidget(index: index, purchases: purchase);
                                  },
                                );
                              })
                          : const Center(child: Text('No recent payable'));
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

//== == == == == FutureBuilder Transactions == == == == ==
  Future<List<PurchaseModel>?> futurePayable() async {
    log('FutureBuiler ()=> called!');
    if (payableList.isEmpty) {
      log('Fetching purchases from the Database..');
      payableList = await PurchaseDatabase.instance.getPendingPurchases();
      return payableList = payableList.reversed.toList();
    } else {
      log('Fetching purchases from the List..');
      return payableList = payableList.reversed.toList();
    }
  }

  //========== Date Picker ==========
  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ),
      lastDate: DateTime.now(),
    );
  }
}
