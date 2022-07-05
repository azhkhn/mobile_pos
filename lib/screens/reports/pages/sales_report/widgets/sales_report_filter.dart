// ignore_for_file: must_be_immutable

import 'dart:developer' show log;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final _paymentProvider = StateProvider.autoDispose<String?>((ref) => null);
final _dateProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _invoiceProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _customerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());

class SalesReportFilter extends ConsumerWidget {
  SalesReportFilter({Key? key}) : super(key: key);

  //========== Database Instances ==========
  final SalesDatabase salesDB = SalesDatabase.instance;
  final CustomerDatabase customerDB = CustomerDatabase.instance;

  //========== Global Keys ==========
  static final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> _dropDownKey = GlobalKey();

  //========== Lists ==========
  List<SalesModel> salesByCustomerList = [], salesByInvoiceList = [];

  //========== Device Utils ==========
  final bool _isTablet = DeviceUtil.isTablet;

  @override
  Widget build(BuildContext context, ref) {
    final List<SalesModel> salesList = ref.watch(salesListProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(_customerProvider);
      ref.watch(_invoiceProvider);
      ref.watch(_dateProvider);
      ref.watch(_paymentProvider);
    });

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
                      controller: ref.read(_customerProvider),
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
                              ref.read(_customerProvider).clear();
                              salesByCustomerList.clear();
                              if (salesByInvoiceList.isNotEmpty) {
                                ref.read(salesProvider.notifier).state = salesByInvoiceList;
                              } else {
                                if (ref.read(_dateProvider).text.isEmpty) {
                                  ref.read(salesProvider.notifier).state = salesList;
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
                    ref.read(_invoiceProvider).clear();
                    ref.read(_dateProvider).clear();

                    ref.read(_customerProvider).text = selectedCustomer.customer;

                    //fetch all sales done by selected customer
                    salesByCustomerList = salesList.where((sale) => sale.customerId == selectedCustomer.id).toList();

                    //Notify UI
                    ref.read(salesProvider.notifier).state = salesByCustomerList;
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
                      controller: ref.read(_invoiceProvider),
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
                              ref.read(_invoiceProvider).clear();
                              salesByInvoiceList.clear();
                              if (salesByCustomerList.isNotEmpty) {
                                ref.read(salesProvider.notifier).state = salesByCustomerList;
                              } else {
                                if (ref.read(_dateProvider).text.isEmpty) {
                                  ref.read(salesProvider.notifier).state = salesList;
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
                    ref.read(_dateProvider).clear();
                    ref.read(_invoiceProvider).text = suggestion.invoiceNumber!;
                    salesByInvoiceList = [suggestion];
                    ref.read(salesProvider.notifier).state = [suggestion];

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
                  controller: ref.read(_dateProvider),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 10,
                    minHeight: 10,
                  ),
                  suffixIcon: Padding(
                    padding: kClearTextIconPadding,
                    child: InkWell(
                      child: const Icon(Icons.clear, size: 15),
                      onTap: () async {
                        if (ref.read(_dateProvider).text.isNotEmpty && salesByCustomerList.isNotEmpty) {
                          ref.read(salesProvider.notifier).state = salesByCustomerList;
                        } else if (ref.read(_dateProvider).text.isNotEmpty) {
                          ref.read(salesProvider.notifier).state = salesList;
                        }

                        ref.read(_dateProvider).clear();
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
                      ref.read(_invoiceProvider).clear();
                      final parseDate = Converter.dateFormat.format(_selectedDate);
                      ref.read(_dateProvider).text = parseDate.toString();

                      final List<SalesModel> _salesByDate = [];

                      final bool isFilter = salesByCustomerList.isNotEmpty;

                      for (SalesModel transaction in isFilter ? salesByCustomerList : salesList) {
                        final DateTime _transactionDate = DateTime.parse(transaction.dateTime);

                        final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                        if (isSameDate) {
                          _salesByDate.add(transaction);
                        }
                      }
                      ref.read(salesProvider.notifier).state = _salesByDate;
                    }
                  },
                ),
              ),
              kWidth5,

              //==================== Payment Dropdown ====================
              Flexible(
                flex: 1,
                child: Consumer(builder: (context, ref, child) {
                  final val = ref.watch(_paymentProvider);
                  return DropdownButtonFormField(
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
                    value: val,
                    items: ['All', 'Paid', 'Partial', 'Credit', 'Returned']
                        .map((values) => DropdownMenuItem<String>(
                              value: values,
                              child: Text(values),
                            ))
                        .toList(),
                    onChanged: (String? payment) {
                      ref.read(_invoiceProvider).clear();
                      salesByInvoiceList.clear();
                      ref.read(_paymentProvider.notifier).state = payment.toString();
                      ref.read(_paymentProvider.notifier).state = payment;

                      if (payment != 'All') {
                        if (ref.read(_dateProvider).text.isNotEmpty) {
                          ref.read(salesProvider.notifier).state =
                              ref.read(salesProvider.notifier).state.where((sale) => sale.paymentStatus == payment).toList();
                        } else if (salesByCustomerList.isNotEmpty) {
                          ref.read(salesProvider.notifier).state = salesByCustomerList.where((sale) => sale.paymentStatus == payment).toList();
                        } else {
                          ref.read(salesProvider.notifier).state = salesList.where((sale) => sale.paymentStatus == payment).toList();
                        }
                      } else {
                        if (ref.read(_dateProvider).text.isNotEmpty) {
                          ref.read(salesProvider.notifier).state =
                              ref.read(salesProvider.notifier).state.where((sale) => sale.paymentStatus != payment).toList();
                        } else if (salesByCustomerList.isNotEmpty) {
                          ref.read(salesProvider.notifier).state = salesByCustomerList.where((sale) => sale.paymentStatus != payment).toList();
                        } else {
                          ref.read(salesProvider.notifier).state = salesList;
                        }
                      }

                      log('Payment filter = $payment');
                    },
                  );
                }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
