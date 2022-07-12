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
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_items_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/purchase/purchase_items_model.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/reports/pages/purchases_report/screen_purchases_report.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

//==================== Providers ====================
final _paymentProvider = StateProvider.autoDispose<String?>((ref) => null);

final _fromDateControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _toDateControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _invoiceProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _supplierControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _productControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());

final _productProvider = StateProvider.autoDispose<ItemMasterModel?>((ref) => null);
final _supplierProvider = StateProvider.autoDispose<SupplierModel?>((ref) => null);

final _fromDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final _toDateProvier = StateProvider.autoDispose<DateTime?>((ref) => null);

//==================== Database Instances ====================
final SupplierDatabase _supplierDatabase = SupplierDatabase.instance;

class PurchasesReportFilter extends ConsumerWidget {
  const PurchasesReportFilter({Key? key}) : super(key: key);

  static final purchasesListProvider = StateProvider.autoDispose<List<PurchaseModel>>((ref) => []);

  @override
  Widget build(BuildContext context, ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(ScreenPurchasesReport.isLoadedProvider);
      ref.watch(_supplierProvider);
      ref.watch(purchasesListProvider);
      ref.watch(_supplierControllerProvider);
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
                  return ref
                      .read(purchasesListProvider)
                      .where((purchase) => purchase.invoiceNumber!.toLowerCase().contains(pattern))
                      .toList()
                      .take(10);
                },
                itemBuilder: (context, PurchaseModel suggestion) {
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
                onSuggestionSelected: (PurchaseModel suggestion) {
                  //clear all the other fields
                  ref.read(_supplierControllerProvider).clear();
                  ref.read(_productControllerProvider).clear();
                  ref.refresh(_paymentProvider);
                  ref.refresh(_fromDateControllerProvider);
                  ref.refresh(_toDateControllerProvider);

                  ref.read(_invoiceProvider).text = suggestion.invoiceNumber!;
                  ref.read(ScreenPurchasesReport.purchaseProvider.notifier).state = [suggestion];
                },
              ),
            ),

            kWidth5,

            //==================== Get All Supplier Search Field ====================
            Expanded(
              child: TypeAheadField(
                minCharsForSuggestions: 0,
                debounceDuration: const Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                textFieldConfiguration: TextFieldConfiguration(
                  controller: ref.read(_supplierControllerProvider),
                  style: kText12,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      ref.refresh(_supplierProvider);

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
                          ref.refresh(_supplierProvider);
                          ref.refresh(_supplierControllerProvider);

                          //Notify UI
                          filterReports(ref);
                        },
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Supplier',
                    hintStyle: kText12,
                    border: const OutlineInputBorder(),
                  ),
                ),
                noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Supplier Found!', style: kText12))),
                suggestionsCallback: (pattern) async {
                  return await _supplierDatabase.getSupplierSuggestions(pattern);
                },
                itemBuilder: (context, SupplierModel suggestion) {
                  return ListTile(
                    title: AutoSizeText(
                      suggestion.supplierName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: isTablet ? 12 : 10),
                      minFontSize: 10,
                      maxFontSize: 12,
                    ),
                  );
                },
                onSuggestionSelected: (SupplierModel selectedSupplier) async {
                  ref.refresh(_invoiceProvider);
                  ref.read(_supplierControllerProvider).text = selectedSupplier.supplierName;

                  //fetch all purchases done by selected supplier
                  ref.read(_supplierProvider.notifier).state = selectedSupplier;

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
  List<PurchaseModel> paymentFilter(String? payment, WidgetRef ref, List<PurchaseModel> purchases) {
    if (payment != 'All') {
      return purchases.where((purchase) => purchase.paymentStatus == payment).toList();
    } else {
      return purchases;
    }
  }

  //== == == == == Get purchases by Product Id == == == == == ==
  Future<List<PurchaseModel>> getPurchasesByProduct(WidgetRef ref, ItemMasterModel item, List<PurchaseModel> purchases) async {
    final List<PurchaseModel> purchasesByProduct = [];
    for (var purchase in purchases) {
      final List<PurchaseItemsModel> purchaseItems = await PurchaseItemsDatabase.instance.getPurchaseItemByPurchaseId(purchase.id!);

      for (PurchaseItemsModel soldItem in purchaseItems) {
        if (soldItem.productCode == item.itemCode) {
          purchasesByProduct.add(purchase);
          break;
        }
      }
    }
    return purchasesByProduct;
  }

  //=== === === === === Get purchase By Date === === === === ===
  List<PurchaseModel> filterPurchasesByDate(WidgetRef ref, List<PurchaseModel> purchases) {
    log('filterPurchasesByDate');
    final DateTime? _fromDate = ref.read(_fromDateProvider);
    final DateTime? _toDate = ref.read(_toDateProvier);

    final List<PurchaseModel> purchasesByDate = [];

    if (_fromDate != null || _toDate != null) {
      if (_fromDate != null) log('From Date = ' + Converter.dateTimeFormatAmPm.format(_fromDate));
      if (_toDate != null) log('To Date = ' + Converter.dateTimeFormatAmPm.format(_toDate));

      //purchases Tax Summary ~ Filter
      for (PurchaseModel purchase in purchases) {
        final DateTime _date = DateTime.parse(purchase.dateTime);

        // if fromDate and toDate is selected
        if (_fromDate != null && _toDate != null) {
          log('Sold Date = ' + Converter.dateTimeFormatAmPm.format(_date));

          if (_fromDate.isAtSameMomentAs(_toDate)) {
            if (Converter.isSameDate(_fromDate, _date)) {
              purchasesByDate.add(purchase);
            }
          } else if (_date.isAfter(_fromDate) && _date.isBefore(_toDate)) {
            purchasesByDate.add(purchase);
          }
        }

        // if only fromDate is selected
        else if (_fromDate != null) {
          if (_date.isAfter(_fromDate)) purchasesByDate.add(purchase);
        }

        // if only toDate is selected
        else if (_toDate != null) {
          if (_date.isBefore(_toDate)) purchasesByDate.add(purchase);
        }
      }

      return purchasesByDate;
    } else {
      return purchases;
    }
  }

//=== === === === === purchases Report Filter === === === === ===
  Future<void> filterReports(WidgetRef ref) async {
    final SupplierModel? _supplier = ref.read(_supplierProvider);

    final String? _payment = ref.read(_paymentProvider);
    final ItemMasterModel? _product = ref.read(_productProvider);
    final DateTime? _fromDate = ref.read(_fromDateProvider);
    final DateTime? _toDate = ref.read(_toDateProvier);

    List<PurchaseModel> filteredPurchases = ref.read(purchasesListProvider);

    //Supplier Filter
    if (_supplier != null) filteredPurchases = filteredPurchases.where((purchase) => purchase.supplierId == _supplier.id).toList();
    //Product Filter
    if (_product != null) {
      filteredPurchases = await getPurchasesByProduct(ref, _product, filteredPurchases);
    }

    //Date Filter
    if (_fromDate != null || _toDate != null) {
      filteredPurchases = filterPurchasesByDate(ref, filteredPurchases);
    }

    //Payment Filter
    if (_payment != null) filteredPurchases = paymentFilter(_payment, ref, filteredPurchases);

    log('Filtered purchases = $filteredPurchases');

    ref.read(ScreenPurchasesReport.purchaseProvider.notifier).state = filteredPurchases;
  }

//=== === === === === Refresh List Using Filter === === === === ===
  void refreshList(WidgetRef ref) {
    ref.refresh(_invoiceProvider);
    ref.refresh(_supplierControllerProvider);
    ref.refresh(_productControllerProvider);
    ref.refresh(_paymentProvider);
    ref.refresh(_fromDateControllerProvider);
    ref.refresh(_toDateControllerProvider);

    ref.refresh(_supplierProvider);
    ref.refresh(_fromDateProvider);
    ref.refresh(_toDateProvier);

    ref.read(ScreenPurchasesReport.purchaseProvider.notifier).state = ref.read(purchasesListProvider);
  }
}
