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
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/sales/pages/screen_sales_list.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

//==================== Providers ====================
final _paymentProvider = StateProvider.autoDispose<String?>((ref) => null);
final _customerProvider = StateProvider.autoDispose<CustomerModel?>((ref) => null);
final _dateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

final _invoiceController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _customerController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _dateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

//========== Global Keys ==========
final GlobalKey<FormFieldState> _dropDownKey = GlobalKey();

class SalesListFilter extends ConsumerWidget {
  const SalesListFilter({Key? key}) : super(key: key);

  static final salesListProvider = StateProvider.autoDispose<List<SalesModel>>((ref) => []);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(ScreenSalesList.isLoadedProvider);
      ref.watch(salesListProvider);
      ref.watch(_customerProvider);
      ref.watch(_dateProvider);
      ref.watch(_paymentProvider);
      ref.watch(_invoiceController);
      ref.watch(_customerController);
      ref.watch(_dateController);
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //==================== Get All Invoice Search Field ====================
            Expanded(
              child: TypeAheadField(
                minCharsForSuggestions: 0,
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: ref.read(_invoiceController),
                    style: kText12,
                    onChanged: (value) {
                      if (ref.read(_invoiceController).text.isEmpty) refreshList(ref);
                    },
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
                            if (ref.read(_invoiceController).text.isNotEmpty) refreshList(ref);
                            ref.refresh(_invoiceController);
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
                  return ref.read(salesListProvider).where((sale) => sale.invoiceNumber!.toLowerCase().contains(pattern)).toList().take(10);
                },
                itemBuilder: (context, SalesModel suggestion) {
                  return ListTile(
                    title: AutoSizeText(
                      suggestion.invoiceNumber!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: isTablet ? 12 : 10),
                      minFontSize: 10,
                      maxFontSize: 12,
                    ),
                  );
                },
                onSuggestionSelected: (SalesModel suggestion) {
                  //clear all the other fields
                  ref.refresh(_customerController);
                  ref.refresh(_dateController);

                  ref.refresh(_customerProvider);
                  ref.refresh(_paymentProvider);
                  ref.refresh(_dateProvider);

                  ref.read(_invoiceController).text = suggestion.invoiceNumber!;
                  ref.read(ScreenSalesList.salesProvider.notifier).state = [suggestion];
                },
              ),
            ),

            kWidth5,

            //==================== Get All Customer Search Field ====================
            Expanded(
              child: TypeAheadField(
                minCharsForSuggestions: 0,
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: ref.read(_customerController),
                    style: kText12,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        ref.refresh(_customerProvider);

                        //Notify UI
                        filterReports(ref);
                      }
                    },
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
                            ref.refresh(_customerController);
                            ref.refresh(_customerProvider);

                            //Notify UI
                            filterReports(ref);
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
                  return await CustomerDatabase.instance.getCustomerSuggestions(pattern);
                },
                itemBuilder: (context, CustomerModel suggestion) {
                  return ListTile(
                    title: AutoSizeText(
                      suggestion.customer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: isTablet ? 12 : 10),
                      minFontSize: 10,
                      maxFontSize: 12,
                    ),
                  );
                },
                onSuggestionSelected: (CustomerModel selectedCustomer) async {
                  ref.read(_customerController).text = selectedCustomer.customer;
                  ref.read(_customerProvider.notifier).state = selectedCustomer;

                  //Notify UI
                  filterReports(ref);
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
                controller: ref.read(_dateController),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                suffixIcon: Padding(
                  padding: kClearTextIconPadding,
                  child: InkWell(
                    child: const Icon(Icons.clear, size: 15),
                    onTap: () async {
                      ref.refresh(_dateController);
                      ref.refresh(_dateProvider);
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
                    final parseDate = Converter.dateFormat.format(_selectedDate);
                    ref.read(_dateController).text = parseDate.toString();

                    ref.read(_dateProvider.notifier).state = _selectedDate;

                    //Notify UI
                    filterReports(ref);
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
                value: ref.read(_paymentProvider),
                items: ['All', 'Paid', 'Partial', 'Credit', 'Returned']
                    .map((values) => DropdownMenuItem<String>(
                          value: values,
                          child: Text(values),
                        ))
                    .toList(),
                onChanged: (String? payment) {
                  ref.read(_paymentProvider.notifier).state = payment;

                  //Notify UI
                  filterReports(ref);

                  log('Payment filter = $payment');
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  List<SalesModel> filterByDate(DateTime _selectedDate, List<SalesModel> sales) {
    final List<SalesModel> _salesByDate = [];

    for (SalesModel transaction in sales) {
      final DateTime _transactionDate = DateTime.parse(transaction.dateTime);

      final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

      if (isSameDate) {
        _salesByDate.add(transaction);
      }
    }

    return _salesByDate;
  }

  //== == == == == Payment Filter == == == == ==
  List<SalesModel> paymentFilter(String? payment, WidgetRef ref, List<SalesModel> sales) {
    if (payment != 'All') {
      return sales.where((sale) => sale.paymentStatus == payment).toList();
    } else {
      return sales;
    }
  }

//=== === === === === Sales Report Filter === === === === ===
  Future<void> filterReports(WidgetRef ref) async {
    final CustomerModel? _customer = ref.read(_customerProvider);
    final String? _payment = ref.read(_paymentProvider);
    final DateTime? _date = ref.read(_dateProvider);

    List<SalesModel> filteredSales = ref.read(salesListProvider);

    ref.refresh(_invoiceController);

    //Customer Filter
    if (_customer != null) filteredSales = filteredSales.where((sale) => sale.customerId == _customer.id).toList();

    //Date Filter
    if (_date != null) {
      filteredSales = filterByDate(_date, filteredSales);
    }

    //Payment Filter
    if (_payment != null) filteredSales = paymentFilter(_payment, ref, filteredSales);

    log('Filtered Sales = $filteredSales');

    ref.read(ScreenSalesList.salesProvider.notifier).state = filteredSales;
  }

//=== === === === === Refresh List Using Filter === === === === ===
  void refreshList(WidgetRef ref) {
    ref.refresh(_customerController);
    ref.refresh(_dateController);

    ref.refresh(_customerProvider);
    ref.refresh(_paymentProvider);
    ref.refresh(_dateProvider);

    ref.read(ScreenSalesList.salesProvider.notifier).state = ref.read(salesListProvider);
  }
}
