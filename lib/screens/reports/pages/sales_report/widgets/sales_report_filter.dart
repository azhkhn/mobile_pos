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
final _productControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());

final _productProvider = StateProvider.autoDispose<ItemMasterModel?>((ref) => null);

final _fromDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final _toDateProvier = StateProvider.autoDispose<DateTime?>((ref) => null);

final _salesByCustomerListProvider = StateProvider.autoDispose<List<SalesModel>>((ref) => []);

//==================== Database Instances ====================
final CustomerDatabase _customerDB = CustomerDatabase.instance;

class SalesReportFilter extends ConsumerWidget {
  const SalesReportFilter({Key? key}) : super(key: key);

  static final salesListProvider = StateProvider.autoDispose<List<SalesModel>>((ref) => []);

  @override
  Widget build(BuildContext context, ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(ScreenSalesReport.isLoadedProvider);
      ref.watch(_salesByCustomerListProvider);
      ref.watch(salesListProvider);
      ref.watch(_customerProvider);
      ref.watch(_invoiceProvider);
      ref.watch(_fromDateControllerProvider);
      ref.watch(_toDateControllerProvider);
      ref.watch(_paymentProvider);
      ref.watch(_productControllerProvider);
      ref.watch(_fromDateProvider);
      ref.watch(_toDateProvier);
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
                    controller: ref.read(_invoiceProvider),
                    style: kText12,
                    onChanged: (value) {
                      if (ref.read(_invoiceProvider).text.isEmpty) refreshList(ref);
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
                            if (ref.read(_invoiceProvider).text.isNotEmpty) refreshList(ref);
                            ref.refresh(_invoiceProvider);
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
                  ref.read(_customerProvider).clear();
                  ref.read(_productControllerProvider).clear();
                  ref.refresh(_paymentProvider);
                  ref.refresh(_fromDateControllerProvider);
                  ref.refresh(_toDateControllerProvider);

                  ref.read(_invoiceProvider).text = suggestion.invoiceNumber!;
                  ref.read(ScreenSalesReport.salesProvider.notifier).state = [suggestion];
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
                  controller: ref.read(_customerProvider),
                  style: kText12,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ref.read(_customerProvider).clear();
                      ref.read(_salesByCustomerListProvider).clear();

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
                          ref.read(_customerProvider).clear();
                          ref.read(_salesByCustomerListProvider).clear();

                          //Notify UI
                          filterReports(ref);
                        },
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Customer',
                    hintStyle: kText12,
                    border: const OutlineInputBorder(),
                  ),
                ),
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
                      style: TextStyle(fontSize: isTablet ? 12 : 10),
                      minFontSize: 10,
                      maxFontSize: 12,
                    ),
                  );
                },
                onSuggestionSelected: (CustomerModel selectedCustomer) async {
                  ref.refresh(_invoiceProvider);
                  ref.read(_customerProvider).text = selectedCustomer.customer;

                  //fetch all sales done by selected customer
                  ref.read(_salesByCustomerListProvider.notifier).state =
                      ref.read(salesListProvider).where((sale) => sale.customerId == selectedCustomer.id).toList();

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
            //==================== Get All Products Search Field ====================
            Flexible(
              child: TypeAheadField(
                minCharsForSuggestions: 0,
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                    controller: ref.read(_productControllerProvider),
                    style: kText12,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        ref.refresh(_productControllerProvider);
                        ref.refresh(_productProvider);

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
                          child: const Icon(Icons.clear, size: 15),
                          onTap: () async {
                            ref.refresh(_productControllerProvider);
                            ref.refresh(_productProvider);

                            //Notify UI
                            filterReports(ref);
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
                  ref.read(_productControllerProvider).text = selectedItem.itemName;
                  ref.read(_productProvider.notifier).state = selectedItem;

                  //Notify UI
                  filterReports(ref);
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
                  ref.refresh(_invoiceProvider);
                  ref.read(_paymentProvider.notifier).state = payment;

                  //Notify UI
                  filterReports(ref);

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
                      ref.refresh(_fromDateControllerProvider);
                      ref.refresh(_fromDateProvider);
                      //Notify UI
                      filterReports(ref);
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
                    ref.refresh(_invoiceProvider);
                    final parseDate = Converter.dateFormat.format(_selectedDate);
                    ref.read(_fromDateProvider.notifier).state = _selectedDate;
                    ref.read(_fromDateControllerProvider).text = parseDate.toString();

                    //Notify UI
                    filterReports(ref);
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
                      ref.refresh(_toDateControllerProvider);
                      ref.refresh(_toDateProvier);
                      //Notify UI
                      filterReports(ref);
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
                    ref.refresh(_invoiceProvider);
                    final parseDate = Converter.dateFormat.format(_selectedDate);
                    ref.read(_toDateProvier.notifier).state = _selectedDate;
                    ref.read(_toDateControllerProvider).text = parseDate.toString();

                    //Notify UI
                    filterReports(ref);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  //== == == == == Payment Filter == == == == ==
  List<SalesModel> paymentFilter(String? payment, WidgetRef ref, List<SalesModel> sales) {
    if (payment != 'All') {
      return sales.where((sale) => sale.paymentStatus == payment).toList();
    } else {
      return sales;
    }
  }

  //== == == == == Get Sales by Product Id == == == == == ==
  Future<List<SalesModel>> getSalesByProduct(WidgetRef ref, ItemMasterModel item, List<SalesModel> sales) async {
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
    return salesByProduct;
  }

  //=== === === === === Get Sale By Date === === === === ===
  List<SalesModel> filterSalesByDate(WidgetRef ref, List<SalesModel> sales) {
    log('filterSalesByDate');
    final DateTime? _fromDate = ref.read(_fromDateProvider);
    final DateTime? _toDate = ref.read(_toDateProvier);

    final List<SalesModel> salesByDate = [];

    if (_fromDate != null || _toDate != null) {
      if (_fromDate != null) log('From Date = ' + Converter.dateTimeFormatAmPm.format(_fromDate));
      if (_toDate != null) log('To Date = ' + Converter.dateTimeFormatAmPm.format(_toDate));

      //Sales Tax Summary ~ Filter
      for (SalesModel sale in sales) {
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

      return salesByDate;
    } else {
      return sales;
    }
  }

//=== === === === === Sales Report Filter === === === === ===
  Future<void> filterReports(WidgetRef ref) async {
    final List<SalesModel> _customerList = ref.read(_salesByCustomerListProvider);
    final String? _payment = ref.read(_paymentProvider);
    final ItemMasterModel? _product = ref.read(_productProvider);
    final DateTime? _fromDate = ref.read(_fromDateProvider);
    final DateTime? _toDate = ref.read(_toDateProvier);

    List<SalesModel> filteredSales = ref.read(salesListProvider);

    //Customer Filter
    if (_customerList.isNotEmpty) filteredSales = _customerList;

    //Product Filter
    if (_product != null) {
      filteredSales = await getSalesByProduct(ref, _product, filteredSales);
    }

    //Date Filter
    if (_fromDate != null || _toDate != null) {
      filteredSales = filterSalesByDate(ref, filteredSales);
    }

    //Payment Filter
    if (_payment != null) filteredSales = paymentFilter(_payment, ref, filteredSales);

    log('Filtered Sales = $filteredSales');

    ref.read(ScreenSalesReport.salesProvider.notifier).state = filteredSales;
  }

//=== === === === === Refresh List Using Filter === === === === ===
  void refreshList(WidgetRef ref) {
    ref.refresh(_invoiceProvider);
    ref.refresh(_customerProvider);
    ref.refresh(_productControllerProvider);
    ref.refresh(_paymentProvider);
    ref.refresh(_fromDateControllerProvider);
    ref.refresh(_toDateControllerProvider);

    ref.refresh(_salesByCustomerListProvider);
    ref.refresh(_fromDateProvider);
    ref.refresh(_toDateProvier);

    ref.read(ScreenSalesReport.salesProvider.notifier).state = ref.read(salesListProvider);
  }
}
