// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/screens/reports/pages/transactions_report/widgets/transactions_report_card.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenTransactionsReport extends StatelessWidget {
  ScreenTransactionsReport({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController customerController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController payByController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  //==================== ValueNotifer ====================
  final ValueNotifier<List<TransactionsModel>> transactionsNotifier = ValueNotifier([]);

  //==================== List ====================
  List<TransactionsModel> transactionsList = [];
  List<TransactionsModel> filteredList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Transactions Report'),
      body: SafeArea(
          child: ItemScreenPaddingWidget(
        //=============================================================================
        //==================== Customer and Supplier Filter Fields ====================
        //=============================================================================
        child: Column(
          children: [
            Row(
              children: [
                //==================== Customer Search Field ====================
                Flexible(
                  flex: 1,
                  child: TypeAheadField(
                    minCharsForSuggestions: 0,
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: customerController,
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
                                if (customerController.text.isNotEmpty) {
                                  filteredList.clear();
                                  dateController.clear();

                                  if (transactionsList.isNotEmpty) {
                                    transactionsNotifier.value = transactionsList;
                                  } else {
                                    await futureTransactions();
                                    transactionsNotifier.value = transactionsList;
                                  }
                                }
                                customerController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Customer',
                          hintStyle: kText12,
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
                    onSuggestionSelected: (CustomerModel selectedCustomer) async {
                      dateController.clear();
                      supplierController.clear();
                      payByController.clear();
                      customerController.text = selectedCustomer.customer;
                      log('Selected Customer = ' + selectedCustomer.customer);
                      filteredList = transactionsList.where((transaction) => transaction.customerId == selectedCustomer.id).toList();
                      //Notify Transactions by selected Customer
                      transactionsNotifier.value = filteredList;
                    },
                  ),
                ),
                kWidth5,
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
                                if (supplierController.text.isNotEmpty) {
                                  filteredList.clear();
                                  dateController.clear();

                                  if (transactionsList.isNotEmpty) {
                                    transactionsNotifier.value = transactionsList;
                                  } else {
                                    await futureTransactions();
                                    transactionsNotifier.value = transactionsList;
                                  }
                                }
                                supplierController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Supplier',
                          hintStyle: kText12,
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
                    onSuggestionSelected: (SupplierModel selectedSupplier) async {
                      customerController.clear();
                      dateController.clear();
                      payByController.clear();
                      supplierController.text = selectedSupplier.supplierName;
                      log('Supplier = ' + selectedSupplier.supplierName);

                      filteredList = transactionsList.where((transaction) => transaction.supplierId == selectedSupplier.id).toList();

                      //Notify Transactions by selected Supplier
                      transactionsNotifier.value = filteredList;
                    },
                  ),
                ),
              ],
            ),

            kHeight5,

            //======================================================================
            //==================== PayBy and Date Filter Fields ====================
            //======================================================================
            Row(
              children: [
                //==================== PayBy Search Field ====================
                Flexible(
                  flex: 1,
                  child: TypeAheadField(
                    minCharsForSuggestions: 0,
                    debounceDuration: const Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: payByController,
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
                                if (payByController.text.isNotEmpty) {
                                  filteredList.clear();
                                  dateController.clear();

                                  if (transactionsList.isNotEmpty) {
                                    transactionsNotifier.value = transactionsList;
                                  } else {
                                    await futureTransactions();
                                    transactionsNotifier.value = transactionsList;
                                  }
                                }

                                payByController.clear();
                              },
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'Pay By',
                          hintStyle: kText12,
                          border: const OutlineInputBorder(),
                        )),
                    noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('Not Found!', style: kText10))),
                    suggestionsCallback: (pattern) async {
                      return TransactionDatabase.instance.getPayBySuggestions(pattern);
                    },
                    itemBuilder: (context, TransactionsModel suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.payBy!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kText_10_12,
                        ),
                      );
                    },
                    onSuggestionSelected: (TransactionsModel selectedPayer) async {
                      customerController.clear();
                      supplierController.clear();
                      dateController.clear();
                      payByController.text = selectedPayer.payBy!;
                      log('Selected Payer = ' + selectedPayer.payBy.toString());

                      filteredList = transactionsList.where((transaction) => transaction.payBy == selectedPayer.payBy).toList();

                      //Notify Transactions by selected Payer
                      transactionsNotifier.value = filteredList;
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
                          if (dateController.text.isNotEmpty) {
                            if (transactionsList.isNotEmpty) {
                              transactionsNotifier.value = transactionsList;
                            } else {
                              await futureTransactions();
                              transactionsNotifier.value = transactionsList;
                            }
                            customerController.clear();
                            supplierController.clear();
                            payByController.clear();
                          }

                          dateController.clear();
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

                        final List<TransactionsModel> _transactionByDate = [];

                        final bool isFilter = filteredList.isNotEmpty;

                        for (TransactionsModel transaction in isFilter ? filteredList : transactionsList) {
                          final DateTime _transactionDate = DateTime.parse(transaction.dateTime);

                          final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                          if (isSameDate) {
                            _transactionByDate.add(transaction);
                          }
                        }
                        transactionsNotifier.value = _transactionByDate;
                        transactionsNotifier.notifyListeners();
                      }
                    },
                  ),
                )
              ],
            ),

            kHeight10,

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
                      if (!snapshot.hasData) return const Center(child: Text('No recent transactions'));

                      final List<TransactionsModel> _recentPayments = snapshot.data as List<TransactionsModel>;
                      transactionsNotifier.value = _recentPayments;

                      return _recentPayments.isNotEmpty
                          ? ValueListenableBuilder(
                              valueListenable: transactionsNotifier,
                              builder: (context, List<TransactionsModel> _transactions, __) {
                                return ListView.builder(
                                  itemCount: _transactions.length,
                                  itemBuilder: (ctx, index) {
                                    final TransactionsModel transaction = _transactions[index];

                                    //==================== Payment Report Card ====================
                                    return TransactionsReportCard(index: index, transactionsModel: transaction);
                                  },
                                );
                              })
                          : const Center(child: Text('No recent transactions'));
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
  Future<List<TransactionsModel>> futureTransactions() async {
    log('FutureBuiler ()=> called!');
    if (transactionsList.isEmpty) {
      log('Fetching transaction from the Database..');
      transactionsList = await TransactionDatabase.instance.getAllTransactions();
      return transactionsList = transactionsList.reversed.toList();
    } else {
      log('Fetching transaction from the List..');
      return transactionsList.reversed.toList();
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
