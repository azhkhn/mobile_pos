// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/sales/widgets/sales_card_widget.dart';
import 'package:shop_ez/widgets/alertdialog/custom_popup_options.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenAccountReceivable extends StatelessWidget {
  ScreenAccountReceivable({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController customerController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  //==================== ValueNotifer ====================
  final ValueNotifier<List<SalesModel>> receivableNotifier = ValueNotifier([]);

  //==================== List ====================
  List<SalesModel> receivableList = [];
  List<SalesModel> receivablebyCustomer = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Pending Invoice ~ Receivable'),
      body: SafeArea(
          child: ItemScreenPaddingWidget(
        //=============================================================================
        //==================== Customer and Date Filter Fields ====================
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
                              customerController.clear();
                              dateController.clear();
                              receivablebyCustomer.clear();
                              if (receivableList.isNotEmpty) {
                                receivableNotifier.value = receivableList;
                              } else {
                                await futureReceivable();
                                receivableNotifier.value = receivableList;
                              }
                            },
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Customer',
                        hintStyle: kText12,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) receivablebyCustomer.clear();
                      },
                    ),
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
                      customerController.text = selectedCustomer.customer;
                      log('Selected Customer = ' + selectedCustomer.customer);

                      //Notify Transactions by selected Customer
                      receivablebyCustomer = receivableList.where((sale) => sale.customerId == selectedCustomer.id).toList();
                      receivableNotifier.value = receivablebyCustomer;
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
                          customerController.clear();
                          dateController.clear();
                          receivablebyCustomer.clear();
                          if (receivableList.isNotEmpty) {
                            receivableNotifier.value = receivableList;
                          } else {
                            await futureReceivable();
                            receivableNotifier.value = receivableList;
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

                        final List<SalesModel> _transactionByDate = [];

                        final bool isFilter = receivablebyCustomer.isNotEmpty;

                        for (SalesModel receivable in isFilter ? receivablebyCustomer : receivableList) {
                          final DateTime _transactionDate = DateTime.parse(receivable.dateTime);

                          final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                          if (isSameDate) {
                            _transactionByDate.add(receivable);
                          }
                        }
                        receivableNotifier.value = _transactionByDate;
                        receivableNotifier.notifyListeners();
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
                future: futureReceivable(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                    default:
                      if (!snapshot.hasData) return const Center(child: Text('No recent receivable!'));

                      final List<SalesModel> _recentPayments = snapshot.data as List<SalesModel>;
                      receivableNotifier.value = _recentPayments;

                      return _recentPayments.isNotEmpty
                          ? ValueListenableBuilder(
                              valueListenable: receivableNotifier,
                              builder: (context, List<SalesModel> _sales, __) {
                                return ListView.builder(
                                  itemCount: _sales.length,
                                  itemBuilder: (ctx, index) {
                                    final SalesModel sale = _sales[index];

                                    //==================== Payment Report Card ====================
                                    return InkWell(
                                      child: SalesCardWidget(index: index, sales: sale),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => CustomPopupOptions(
                                            options: [
                                              //========== View Invoice ==========
                                              {
                                                'title': 'View Invoice',
                                                'color': kBlueGrey400,
                                                'icon': Icons.receipt_outlined,
                                                'action': () async {
                                                  await Navigator.pushNamed(
                                                    context,
                                                    routeSalesInvoice,
                                                    arguments: [sale, false],
                                                  );
                                                },
                                              },
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              })
                          : const Center(child: Text('No recent receivable'));
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
  Future<List<SalesModel>?> futureReceivable() async {
    log('FutureBuiler ()=> called!');
    if (receivableList.isEmpty) {
      log('Fetching sales from the Database..');
      receivableList = await SalesDatabase.instance.getPendingSales();
      return receivableList = receivableList.reversed.toList();
    } else {
      log('Fetching sales from the List..');
      return receivableList = receivableList.reversed.toList();
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

// //== == == == == Receivable Amount == == == == ==
//   Future<void> getTotalReceivableAmount({bool sale = false}) async {
//     try {
//       final List<SalesModel> salesModel = await SalesDatabase.instance.getAllSales();

//       num balance = 0;

//       for (var i = 0; i < salesModel.length; i++) {
//         balance += num.parse(salesModel[i].balance);
//       }

//       log('Total Payable == $balance');
//     } catch (e) {
//       log(e.toString());
//     }
//   }
}
