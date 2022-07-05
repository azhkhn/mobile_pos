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
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sales/sales_items_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/sales/sales_items_model.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/reports/pages/sales_report/screen_sales_report.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

//==================== Providers ====================
final _paymentProvider = StateProvider.autoDispose<String?>((ref) => null);
final _fromDateControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _toDateControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _invoiceProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _customerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _productProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _fromDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final _toDateProvier = StateProvider.autoDispose<DateTime?>((ref) => null);
final _salesByCustomerListProvider = StateProvider.autoDispose<List<SalesModel>>((ref) => []);
final _salesListProvider = StateProvider.autoDispose<List<SalesModel>>((ref) => []);

//==================== Lists ====================
// List<SalesModel> _salesByCustomerList = [];
// List<SalesModel> _salesListProvider = [];

//==================== Device Utils ====================
final bool _isTablet = DeviceUtil.isTablet;

//==================== Database Instances ====================
final CustomerDatabase _customerDB = CustomerDatabase.instance;

class SalesReportFilter extends ConsumerWidget {
  const SalesReportFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_salesListProvider.notifier).state = ref.watch(ScreenSalesReport.salesListProvider);
      ref.watch(_salesByCustomerListProvider);
      ref.watch(_salesListProvider);
      ref.watch(_customerProvider);
      ref.watch(_invoiceProvider);
      ref.watch(_fromDateControllerProvider);
      ref.watch(_toDateControllerProvider);
      ref.watch(_paymentProvider);
      ref.watch(_productProvider);
      ref.watch(_fromDateProvider);
      ref.watch(_toDateProvier);
    });

    return Column(
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
                            ref.read(_salesByCustomerListProvider).clear();

                            if (ref.read(_fromDateControllerProvider).text.isEmpty) {
                              ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(_salesListProvider);
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
                  return await _customerDB.getCustomerSuggestions(pattern);
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
                  ref.refresh(_paymentProvider);
                  ref.read(_invoiceProvider).clear();
                  ref.read(_fromDateControllerProvider).clear();

                  ref.read(_customerProvider).text = selectedCustomer.customer;

                  //fetch all sales done by selected customer
                  ref.read(_salesByCustomerListProvider.notifier).state =
                      ref.read(_salesListProvider).where((sale) => sale.customerId == selectedCustomer.id).toList();

                  //Notify UI
                  ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(_salesByCustomerListProvider);
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

                            if (ref.read(_salesByCustomerListProvider).isNotEmpty) {
                              ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(_salesByCustomerListProvider);
                            } else {
                              if (ref.read(_fromDateControllerProvider).text.isEmpty) {
                                ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(_salesListProvider);
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
                  if (ref.read(_salesByCustomerListProvider).isNotEmpty) {
                    return ref.read(_salesByCustomerListProvider).where((sales) => sales.invoiceNumber!.toLowerCase().contains(pattern));
                  } else {
                    // return await salesDB.getSalesByInvoiceSuggestions(pattern);
                    return ref.read(_salesListProvider).where((sale) => sale.invoiceNumber!.toLowerCase().contains(pattern)).toList();
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
                  ref.refresh(_paymentProvider);
                  ref.read(_fromDateControllerProvider).clear();
                  ref.read(_invoiceProvider).text = suggestion.invoiceNumber!;

                  ref.read(ScreenSalesReport.salesProvider.notifier).state = [suggestion];

                  log(suggestion.invoiceNumber!);
                },
              ),
            ),
          ],
        ),
        kHeight5,
        Row(
          children: [
            //========== Get All Products Search Field ==========
            Flexible(
              child: TypeAheadField(
                minCharsForSuggestions: 0,
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: ref.read(_productProvider),
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
                            ref.read(_productProvider).clear();
                            refreshList(ref);
                          },
                        ),
                      ),
                      contentPadding: EdgeInsets.all(DeviceUtil.isSmall ? 8 : 10),
                      hintText: 'Product',
                      hintStyle: kText12,
                      border: const OutlineInputBorder(),
                    )),
                noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!', style: kText12))),
                suggestionsCallback: (pattern) async {
                  return ItemMasterDatabase.instance.getProductSuggestions(pattern);
                },
                itemBuilder: (context, ItemMasterModel suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kText_10_12,
                    ),
                  );
                },
                onSuggestionSelected: (ItemMasterModel selectedItem) async {
                  ref.read(_productProvider).text = selectedItem.itemName;
                  ref.read(ScreenSalesReport.salesProvider.notifier).state = await getSalesByProduct(ref, selectedItem);
                  log('selectedItem = ' + selectedItem.itemName);
                },
              ),
            ),
            kWidth5,

            //==================== Payment Dropdown ====================
            Flexible(
              child: DropdownButtonFormField(
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
                  ref.read(_invoiceProvider).clear();

                  ref.read(_paymentProvider.notifier).state = payment.toString();
                  ref.read(_paymentProvider.notifier).state = payment;

                  if (payment != 'All') {
                    if (ref.read(_fromDateControllerProvider).text.isNotEmpty) {
                      ref.read(ScreenSalesReport.salesProvider.notifier).state =
                          ref.read(ScreenSalesReport.salesProvider.notifier).state.where((sale) => sale.paymentStatus == payment).toList();
                    } else if (ref.read(_salesByCustomerListProvider).isNotEmpty) {
                      ref.read(ScreenSalesReport.salesProvider.notifier).state =
                          ref.read(_salesByCustomerListProvider).where((sale) => sale.paymentStatus == payment).toList();
                    } else {
                      ref.read(ScreenSalesReport.salesProvider.notifier).state =
                          ref.read(_salesListProvider).where((sale) => sale.paymentStatus == payment).toList();
                    }
                  } else {
                    if (ref.read(_fromDateControllerProvider).text.isNotEmpty) {
                      ref.read(ScreenSalesReport.salesProvider.notifier).state =
                          ref.read(ScreenSalesReport.salesProvider.notifier).state.where((sale) => sale.paymentStatus != payment).toList();
                    } else if (ref.read(_salesByCustomerListProvider).isNotEmpty) {
                      ref.read(ScreenSalesReport.salesProvider.notifier).state =
                          ref.read(_salesByCustomerListProvider).where((sale) => sale.paymentStatus != payment).toList();
                    } else {
                      ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(_salesListProvider);
                    }
                  }

                  log('Payment filter = $payment');
                },
              ),
            ),
          ],
        ),
        kHeight5,
        Row(
          children: [
            //==================== From Date Field ====================
            Flexible(
              child: TextFeildWidget(
                hintText: 'From Date ',
                controller: ref.read(_fromDateControllerProvider),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                suffixIcon: Padding(
                  padding: kClearTextIconPadding,
                  child: InkWell(
                    child: const Icon(Icons.clear, size: 15),
                    onTap: () async {
                      // if (ref.read(_fromDateControllerProvider).text.isNotEmpty && ref.read(_salesByCustomerListProvider).isNotEmpty) {
                      //   ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(_salesByCustomerListProvider);
                      // } else if (ref.read(_fromDateControllerProvider).text.isNotEmpty) {
                      //   ref.read(ScreenSalesReport.salesProvider.notifier).state = _salesList;
                      // }

                      ref.read(_fromDateControllerProvider).clear();
                      ref.refresh(_fromDateProvider);
                      filterSalesByDate(ref);
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
                  final _selectedDate = await DateTimeUtils.instance.datePicker(context, initDate: ref.read(_fromDateProvider));

                  if (_selectedDate != null) {
                    ref.refresh(_paymentProvider);
                    ref.read(_invoiceProvider).clear();
                    final parseDate = Converter.dateFormat.format(_selectedDate);
                    ref.read(_fromDateProvider.notifier).state = _selectedDate;
                    ref.read(_fromDateControllerProvider).text = parseDate.toString();

                    filterSalesByDate(ref);

                    // final List<SalesModel> _salesByDate = [];

                    // final bool isFilter = ref.read(_salesByCustomerListProvider).isNotEmpty;

                    // for (SalesModel transaction in isFilter ? ref.read(_salesByCustomerListProvider) : _salesList) {
                    //   final DateTime _transactionDate = DateTime.parse(transaction.dateTime);

                    //   final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                    //   if (isSameDate) {
                    //     _salesByDate.add(transaction);
                    //   }
                    // }
                    // ref.read(ScreenSalesReport.salesProvider.notifier).state = _salesByDate;
                  }
                },
              ),
            ),
            kWidth5,
            //==================== To Date Field ====================
            Flexible(
              child: TextFeildWidget(
                hintText: 'To Date ',
                controller: ref.read(_toDateControllerProvider),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                suffixIcon: Padding(
                  padding: kClearTextIconPadding,
                  child: InkWell(
                    child: const Icon(Icons.clear, size: 15),
                    onTap: () async {
                      // if (ref.read(_toDateControllerProvider).text.isNotEmpty && ref.read(_salesByCustomerListProvider).isNotEmpty) {
                      //   ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(_salesByCustomerListProvider);
                      // } else if (ref.read(_toDateControllerProvider).text.isNotEmpty) {
                      //   ref.read(ScreenSalesReport.salesProvider.notifier).state = _salesList;
                      // }

                      ref.read(_toDateControllerProvider).clear();
                      ref.refresh(_toDateProvier);
                      filterSalesByDate(ref);
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
                  final DateTime? _selectedDate = await DateTimeUtils.instance.datePicker(context, initDate: ref.read(_toDateProvier), endDate: true);

                  if (_selectedDate != null) {
                    ref.refresh(_paymentProvider);
                    ref.read(_invoiceProvider).clear();
                    final parseDate = Converter.dateFormat.format(_selectedDate);
                    ref.read(_toDateProvier.notifier).state = _selectedDate;
                    ref.read(_toDateControllerProvider).text = parseDate.toString();

                    filterSalesByDate(ref);

                    // final List<SalesModel> _salesByDate = [];

                    // final bool isFilter = ref.read(_salesByCustomerListProvider).isNotEmpty;

                    // for (SalesModel sale in isFilter ? ref.read(_salesByCustomerListProvider) : _salesList) {
                    //   final DateTime _transactionDate = DateTime.parse(sale.dateTime);

                    //   // final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

                    //   if (_transactionDate.isAfter(_selectedDate)) {
                    //     _salesByDate.add(sale);
                    //   }
                    // }
                    // ref.read(ScreenSalesReport.salesProvider.notifier).state = _salesByDate;
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  //== == == == == Get Sales by Product Id == == == == == ==
  Future<List<SalesModel>> getSalesByProduct(WidgetRef ref, ItemMasterModel item) async {
    final bool filter = ref.read(_salesByCustomerListProvider).isNotEmpty;

    log('filter == $filter');

    final List<SalesModel> sales = ref.read(ScreenSalesReport.salesProvider);
    // final List<SalesModel> sales = filter ? ref.read(_salesByCustomerListProvider) : ref.read(_salesListProvider);
    final List<SalesModel> salesByProduct = [];
    for (var sale in sales) {
      final List<SalesItemsModel> saleItems = await SalesItemsDatabase.instance.getSalesItemBySaleId(sale.id!);

      for (SalesItemsModel soldItem in saleItems) {
        if (soldItem.productCode == item.itemCode) {
          salesByProduct.add(sale);
          break;
        }
      }
    }
    log('Sales by Product == $salesByProduct');
    return salesByProduct;
  }

  //== == == == == Get Sale By Date == == == == == ==
  void filterSalesByDate(WidgetRef ref) {
    log('filterSalesByDate');
    final DateTime? _fromDate = ref.read(_fromDateProvider);
    final DateTime? _toDate = ref.read(_toDateProvier);

    final List<SalesModel> salesList =
        ref.read(_salesByCustomerListProvider).isNotEmpty ? ref.read(_salesByCustomerListProvider) : ref.read(_salesListProvider);

    final List<SalesModel> salesByDate = [];

    if (_fromDate != null || _toDate != null) {
      if (_fromDate != null) log('From Date = ' + Converter.dateTimeFormatAmPm.format(_fromDate));
      if (_toDate != null) log('To Date = ' + Converter.dateTimeFormatAmPm.format(_toDate));

      //Sales Tax Summary ~ Filter
      for (SalesModel sale in salesList) {
        final DateTime _date = DateTime.parse(sale.dateTime);

        // if fromDate and toDate is selected
        if (_fromDate != null && _toDate != null) {
          log('Sold Date = ' + Converter.dateTimeFormatAmPm.format(_date));

          if (_fromDate.isAtSameMomentAs(_toDate)) {
            if (Converter.isSameDate(_fromDate, _date)) {
              salesByDate.add(sale);
            }
          } else if (_date.isAfter(_fromDate) && _date.isBefore(_toDate)) {
            salesByDate.add(sale);
          }
        }

        // if only fromDate is selected
        else if (_fromDate != null) {
          if (_date.isAfter(_fromDate)) salesByDate.add(sale);
        }

        // if only toDate is selected
        else if (_toDate != null) {
          if (_date.isBefore(_toDate)) salesByDate.add(sale);
        }
      }

      ref.read(ScreenSalesReport.salesProvider.notifier).state = salesByDate;
    } else {
      ref.read(ScreenSalesReport.salesProvider.notifier).state = salesList;
    }
  }

//== == == == == Refresh List Using Filter == == == == ==
  void refreshList(WidgetRef ref) {
    final bool filter = ref.read(_salesByCustomerListProvider).isNotEmpty;

    ref.read(ScreenSalesReport.salesProvider.notifier).state = filter ? ref.read(_salesByCustomerListProvider) : ref.read(_salesListProvider);
  }
}
