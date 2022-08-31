// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/db/db_functions/supplier/supplier_database.dart';
import 'package:mobile_pos/model/supplier/supplier_model.dart';
import 'package:mobile_pos/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:mobile_pos/screens/supplier/widgets/supplier_card_widget.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_popup_options.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/gesture_dismissible_widget/dismissible_widget.dart';

class SupplierManageScreen extends StatelessWidget {
  SupplierManageScreen({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final supplierController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<int?> supplierIdNotifier = ValueNotifier(null);
  final ValueNotifier<List<SupplierModel>> supplierNotifer = ValueNotifier([]);

  //==================== List Suppliers ====================
  List<SupplierModel> suppliersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Supplier Manage'),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              //==================== Search & Filter ====================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Get All Suppliers Search Field ==========
                  Flexible(
                    flex: 8,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: supplierController,
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
                                  supplierIdNotifier.value = null;
                                  supplierController.clear();

                                  if (suppliersList.isNotEmpty) {
                                    supplierNotifer.value = suppliersList;
                                  } else {
                                    supplierNotifer.value = await SupplierDatabase.instance.getAllSuppliers();
                                  }
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Supplier',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Supplier Found!'))),
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
                        supplierNotifer.value = [suggestion];
                        supplierController.text = suggestion.supplierName;
                        supplierIdNotifier.value = suggestion.id;
                      },
                    ),
                  ),
                  kWidth5,

                  //========== View Supplier Button ==========
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      child: IconButton(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(
                            minHeight: 30,
                            maxHeight: 30,
                          ),
                          onPressed: () {
                            if (supplierIdNotifier.value != null) {
                              log('Supplier Id == ${supplierIdNotifier.value}');

                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: kTransparentColor,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                  builder: (context) => DismissibleWidget(
                                        context: context,
                                        child: CustomBottomSheetWidget(supplier: true, model: supplierNotifer.value.first),
                                      ));
                            } else {
                              kSnackBar(context: context, content: 'Please select any Supplier to show details!');
                            }
                          },
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.blue,
                            size: 25,
                          )),
                    ),
                  ),

                  //========== Add Supplier Button ==========
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      child: IconButton(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          maxHeight: 30,
                        ),
                        onPressed: () async {
                          final SupplierModel? addedSupplier =
                              await Navigator.pushNamed(context, routeAddSupplier, arguments: {'from': true}) as SupplierModel;

                          if (addedSupplier != null) {
                            supplierNotifer.value.add(addedSupplier);
                            supplierNotifer.notifyListeners();
                            // suppliersList.add(addedSupplier);
                            supplierController.text = addedSupplier.supplierName;
                            supplierIdNotifier.value = addedSupplier.id;
                          }
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              kHeight10,

              //========== List Suppliers ==========
              Expanded(
                child: FutureBuilder(
                    future: SupplierDatabase.instance.getAllSuppliers(),
                    builder: (context, AsyncSnapshot<List<SupplierModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Suppliers is Empty!'));
                          }
                          supplierNotifer.value = snapshot.data!;

                          if (suppliersList.isEmpty) {
                            suppliersList = snapshot.data!;
                          }
                          return ValueListenableBuilder(
                              valueListenable: supplierNotifer,
                              builder: (context, List<SupplierModel> supplier, _) {
                                return supplier.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: supplier.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: SupplierCardWidget(
                                              index: index,
                                              supplier: supplier,
                                            ),
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => CustomPopupOptions(
                                                        options: [
                                                          {
                                                            'title': 'View Supplier',
                                                            'color': Colors.blueGrey[400],
                                                            'icon': Icons.person_search_outlined,
                                                            'action': () {
                                                              return showModalBottomSheet(
                                                                  context: context,
                                                                  isScrollControlled: true,
                                                                  backgroundColor: kTransparentColor,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                                                  builder: (context) => DismissibleWidget(
                                                                        context: context,
                                                                        child: CustomBottomSheetWidget(model: supplier[index], supplier: true),
                                                                      ));
                                                            },
                                                          },
                                                          {
                                                            'title': 'Edit Supplier',
                                                            'color': Colors.teal[400],
                                                            'icon': Icons.personal_injury,
                                                            'action': () async {
                                                              final editedSupplier = await Navigator.pushNamed(context, routeAddSupplier, arguments: {
                                                                'supplier': supplier[index],
                                                                'from': true,
                                                              });

                                                              if (editedSupplier != null && editedSupplier is SupplierModel) {
                                                                final int stableIndex =
                                                                    suppliersList.indexWhere((_supplier) => _supplier.id == editedSupplier.id);
                                                                log('stable Index == $stableIndex');
                                                                supplierNotifer.value[index] = editedSupplier;
                                                                suppliersList[stableIndex] = editedSupplier;
                                                                supplierNotifer.notifyListeners();
                                                              }
                                                            }
                                                          },
                                                        ],
                                                      ));
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Supplier is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
