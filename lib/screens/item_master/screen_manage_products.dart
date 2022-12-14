// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/db/db_functions/item_master/item_master_database.dart';
import 'package:mobile_pos/model/item_master/item_master_model.dart';
import 'package:mobile_pos/screens/item_master/widgets/item_card_widget.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_popup_options.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';

class ScreenManageProducts extends StatelessWidget {
  ScreenManageProducts({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController productController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<int?> itemIdNotifier = ValueNotifier(null);
  final ValueNotifier<List<ItemMasterModel>> productsNotifier = ValueNotifier([]);

  //==================== List Items ====================
  List<ItemMasterModel> itemsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Manage Products'),
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
                          controller: productController,
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
                                  productController.clear();

                                  if (itemsList.isNotEmpty) {
                                    productsNotifier.value = itemsList;
                                  } else {
                                    productsNotifier.value = await ItemMasterDatabase.instance.getAllItems();
                                  }
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Product',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!'))),
                      suggestionsCallback: (pattern) async {
                        return itemsList
                            .where((item) {
                              return item.itemName.toLowerCase().contains(pattern.toLowerCase()) || item.itemCode.contains(pattern);
                            })
                            .toList()
                            .take(10);
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
                      onSuggestionSelected: (ItemMasterModel suggestion) {
                        productsNotifier.value = [suggestion];
                      },
                    ),
                  ),
                  kWidth5,

                  //========== Add Product Button ==========
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
                          final ItemMasterModel? addedProduct =
                              await Navigator.pushNamed(context, routeAddProduct, arguments: {'from': true}) as ItemMasterModel;

                          if (addedProduct != null) {
                            productsNotifier.value.add(addedProduct);
                            itemsList.add(addedProduct);
                            productsNotifier.notifyListeners();
                          }
                        },
                        icon: const Icon(
                          Icons.playlist_add,
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              kHeight10,

              //========== List Items ==========
              Expanded(
                child: FutureBuilder(
                    future: ItemMasterDatabase.instance.getAllItems(),
                    builder: (context, AsyncSnapshot<List<ItemMasterModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Products is Empty!'));
                          }
                          productsNotifier.value = snapshot.data!;

                          if (itemsList.isEmpty) {
                            itemsList = snapshot.data!;
                          }
                          return ValueListenableBuilder(
                              valueListenable: productsNotifier,
                              builder: (context, List<ItemMasterModel> items, _) {
                                return items.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: items.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: ItemCardWidget(
                                              index: index,
                                              product: items[index],
                                            ),
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => CustomPopupOptions(
                                                        options: [
                                                          {
                                                            'title': 'Edit Item',
                                                            'color': Colors.teal[400],
                                                            'icon': Icons.personal_injury,
                                                            'action': () async {
                                                              final updatedItem = await Navigator.pushNamed(context, routeAddProduct, arguments: {
                                                                'product': items[index],
                                                                'from': true,
                                                              });

                                                              if (updatedItem != null && updatedItem is ItemMasterModel) {
                                                                final int stableIndex = itemsList.indexWhere((_item) => _item.id == updatedItem.id);
                                                                log('stable Index == $stableIndex');
                                                                productsNotifier.value[index] = updatedItem;
                                                                itemsList[stableIndex] = updatedItem;
                                                                productsNotifier.notifyListeners();
                                                              }
                                                            }
                                                          },
                                                        ],
                                                      ));
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Products is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
