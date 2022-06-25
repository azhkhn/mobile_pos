import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenPaymentReport extends StatelessWidget {
  ScreenPaymentReport({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController customerController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  //==================== ValueNotifer ====================
  final ValueNotifier<List<TransactionsModel>> transactionsNotifier = ValueNotifier([]);

  //==================== Integer ====================
  int? customerId, supplierId;

  //==================== List ====================
  List<TransactionsModel> transactionsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Payment Reports'),
      body: SafeArea(
          child: ItemScreenPaddingWidget(
        child: Column(
          children: [
            Row(
              children: [
                //==================== Customer Search Field ====================
                Flexible(
                  flex: 1,
                  child: TypeAheadField(
                    minCharsForSuggestions: 1,
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: TextEditingController(),
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
                              child: const Icon(Icons.clear, size: 15),
                              onTap: () async {
                                customerController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Customer',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: const OutlineInputBorder(),
                        )),
                    noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Customer Found!', style: kText10))),
                    suggestionsCallback: (pattern) async {
                      return CustomerDatabase.instance.getCustomerSuggestions(pattern);
                    },
                    itemBuilder: (context, CustomerModel suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.customer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kText_10_12,
                        ),
                      );
                    },
                    onSuggestionSelected: (CustomerModel suggestion) {
                      customerController.text = suggestion.customer;
                      customerId = suggestion.id;
                      log('Customer = ' + suggestion.customer);
                    },
                  ),
                ),
                kWidth5,
                //==================== Supplier Search Field ====================
                Flexible(
                  flex: 1,
                  child: TypeAheadField(
                    minCharsForSuggestions: 1,
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: TextEditingController(),
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
                              child: const Icon(Icons.clear, size: 15),
                              onTap: () async {
                                customerController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Supplier',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: const OutlineInputBorder(),
                        )),
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
                    onSuggestionSelected: (SupplierModel suggestion) {
                      customerController.text = suggestion.supplierName;
                      supplierId = suggestion.id;
                      log('Supplier = ' + suggestion.supplierName);
                    },
                  ),
                ),
              ],
            ),

            // == == == == == Transactions == == == == ==
            Expanded(
              child: FutureBuilder(
                future: futureTransactions(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:

                    default:
                      final List<TransactionsModel> _recentPayments = (snapshot.data as List<TransactionsModel>).reversed.toList();
                      transactionsNotifier.value = _recentPayments;

                      return _recentPayments.isNotEmpty
                          ? ValueListenableBuilder(
                              valueListenable: transactionsNotifier,
                              builder: (context, List<TransactionsModel> _transactions, __) {
                                return ListView.builder(
                                  itemCount: _transactions.length,
                                  itemBuilder: (ctx, index) {
                                    final _payment = _transactions[index];
                                    return Card(
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: kTransparentColor,
                                            child: Text(
                                              '${index + 1}'.toString(),
                                              style: const TextStyle(fontSize: 12, color: kTextColor),
                                            ),
                                          ),
                                          title: Text(
                                            Converter.dateTimeFormatAmPm.format(DateTime.parse(_payment.dateTime)),
                                            style: kText12Lite,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                _payment.transactionType == 'Income'
                                                    ? Converter.currency.format(num.parse(_payment.amount))
                                                    : Converter.currency.format(num.parse(_payment.amount)),
                                                style: TextStyle(
                                                    color: _payment.transactionType == 'Income' ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C)),
                                              ),
                                              kWidth10,
                                              // Icon(Icons.verified_outlined, color: _payment.transactionType == 'Income' ? kGreen : Colors.red),
                                            ],
                                          )),
                                    );
                                  },
                                );
                              })
                          : const Center(child: Text('No recent Transactions'));
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<List<TransactionsModel>> futureTransactions() async {
    if (transactionsList.isEmpty) {
      log('fetching transactions from the db');
      transactionsList = await TransactionDatabase.instance.getAllTransactions();
      return transactionsList;
    } else {
      log('fetching transactions from the list');
      return transactionsList;
    }
  }
}
