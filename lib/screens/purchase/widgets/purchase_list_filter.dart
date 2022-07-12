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
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/screens/purchase/pages/screen_list_purchases.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

//==================== Providers ====================
final _paymentProvider = StateProvider.autoDispose<String?>((ref) => null);
final _supplierProvider = StateProvider.autoDispose<SupplierModel?>((ref) => null);
final _dateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

final _invoiceController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _supplierController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _dateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

//========== Global Keys ==========
final GlobalKey<FormFieldState> _dropDownKey = GlobalKey();

class PurchaseListFilter extends ConsumerWidget {
  const PurchaseListFilter({Key? key}) : super(key: key);

  static final purchasesListProvider = StateProvider.autoDispose<List<PurchaseModel>>((ref) => []);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(ScreenPurchasesList.isLoadedProvider);
      ref.watch(purchasesListProvider);
      ref.watch(_supplierProvider);
      ref.watch(_dateProvider);
      ref.watch(_paymentProvider);
      ref.watch(_invoiceController);
      ref.watch(_supplierController);
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
                  ref.refresh(_supplierController);
                  ref.refresh(_dateController);

                  ref.refresh(_supplierProvider);
                  ref.refresh(_paymentProvider);
                  ref.refresh(_dateProvider);

                  ref.read(_invoiceController).text = suggestion.invoiceNumber!;
                  ref.read(ScreenPurchasesList.purchasesProvider.notifier).state = [suggestion];
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
                    controller: ref.read(_supplierController),
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
                            ref.refresh(_supplierController);
                            ref.refresh(_supplierProvider);

                            //Notify UI
                            filterReports(ref);
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintText: 'Supplier',
                      hintStyle: kText12,
                      border: const OutlineInputBorder(),
                    )),
                noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Supplier Found!', style: kText12))),
                suggestionsCallback: (pattern) async {
                  return await SupplierDatabase.instance.getSupplierSuggestions(pattern);
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
                  ref.read(_supplierController).text = selectedSupplier.supplierName;
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

  List<PurchaseModel> filterByDate(DateTime _selectedDate, List<PurchaseModel> purchases) {
    final List<PurchaseModel> _purchasesByDate = [];

    for (PurchaseModel transaction in purchases) {
      final DateTime _transactionDate = DateTime.parse(transaction.dateTime);

      final bool isSameDate = Converter.isSameDate(_selectedDate, _transactionDate);

      if (isSameDate) {
        _purchasesByDate.add(transaction);
      }
    }

    return _purchasesByDate;
  }

  //== == == == == Payment Filter == == == == ==
  List<PurchaseModel> paymentFilter(String? payment, WidgetRef ref, List<PurchaseModel> purchases) {
    if (payment != 'All') {
      return purchases.where((purchase) => purchase.paymentStatus == payment).toList();
    } else {
      return purchases;
    }
  }

//=== === === === === Purchases Report Filter === === === === ===
  Future<void> filterReports(WidgetRef ref) async {
    final SupplierModel? _supplier = ref.read(_supplierProvider);
    final String? _payment = ref.read(_paymentProvider);
    final DateTime? _date = ref.read(_dateProvider);

    List<PurchaseModel> filteredPurchases = ref.read(purchasesListProvider);

    ref.refresh(_invoiceController);

    //Supplier Filter
    if (_supplier != null) filteredPurchases = filteredPurchases.where((purchase) => purchase.supplierId == _supplier.id).toList();

    //Date Filter
    if (_date != null) {
      filteredPurchases = filterByDate(_date, filteredPurchases);
    }

    //Payment Filter
    if (_payment != null) filteredPurchases = paymentFilter(_payment, ref, filteredPurchases);

    log('Filtered Purchases = $filteredPurchases');

    ref.read(ScreenPurchasesList.purchasesProvider.notifier).state = filteredPurchases;
  }

//=== === === === === Refresh List Using Filter === === === === ===
  void refreshList(WidgetRef ref) {
    ref.refresh(_supplierController);
    ref.refresh(_dateController);

    ref.refresh(_supplierProvider);
    ref.refresh(_paymentProvider);
    ref.refresh(_dateProvider);

    ref.read(ScreenPurchasesList.purchasesProvider.notifier).state = ref.read(purchasesListProvider);
  }
}
