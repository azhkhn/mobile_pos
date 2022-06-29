// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/item_master/widgets/item_card_widget.dart';
import 'package:shop_ez/widgets/alertdialog/custom_popup_options.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';

class ScreenItemMasterManage extends StatelessWidget {
  ScreenItemMasterManage({Key? key}) : super(key: key);

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
        appBar: AppBarWidget(title: 'Manage Item Master'),
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
                      onSuggestionSelected: (ItemMasterModel suggestion) {
                        productsNotifier.value = [suggestion];
                      },
                    ),
                  ),
                  kWidth5,

                  //     //========== View Supplier Button ==========
                  //     Flexible(
                  //       flex: 1,
                  //       child: FittedBox(
                  //         child: IconButton(
                  //             padding: const EdgeInsets.all(5),
                  //             alignment: Alignment.center,
                  //             constraints: const BoxConstraints(
                  //               minHeight: 30,
                  //               maxHeight: 30,
                  //             ),
                  //             onPressed: () {
                  //               if (supplierIdNotifier.value != null) {
                  //                 log('Supplier Id == ${supplierIdNotifier.value}');

                  //                 showModalBottomSheet(
                  //                     context: context,
                  //                     isScrollControlled: true,
                  //                     backgroundColor: kTransparentColor,
                  //                     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  //                     builder: (context) => DismissibleWidget(
                  //                           context: context,
                  //                           child: CustomBottomSheetWidget(supplier: true, model: supplierNotifer.value.first),
                  //                         ));
                  //               } else {
                  //                 kSnackBar(context: context, content: 'Please select any Supplier to show details!');
                  //               }
                  //             },
                  //             icon: const Icon(
                  //               Icons.visibility,
                  //               color: Colors.blue,
                  //               size: 25,
                  //             )),
                  //       ),
                  //     ),

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
                              await Navigator.pushNamed(context, routeItemMaster, arguments: {'from': true}) as ItemMasterModel;

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
                                    ? ListView.separated(
                                        itemCount: items.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
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
                                                          // {
                                                          //   'title': 'View Item',
                                                          //   'color': Colors.blueGrey[400],
                                                          //   'icon': Icons.person_search_outlined,
                                                          //   'action': () {
                                                          //     return showModalBottomSheet(
                                                          //         context: context,
                                                          //         isScrollControlled: true,
                                                          //         backgroundColor: kTransparentColor,
                                                          //         shape: const RoundedRectangleBorder(
                                                          //             borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                                          //         builder: (context) => DismissibleWidget(
                                                          //               context: context,
                                                          //               child: CustomBottomSheetWidget(model: items[index], supplier: true),
                                                          //             ));
                                                          //   },
                                                          // },
                                                          {
                                                            'title': 'Edit Item',
                                                            'color': Colors.teal[400],
                                                            'icon': Icons.personal_injury,
                                                            'action': () async {
                                                              final updatedItem = await Navigator.pushNamed(context, routeItemMaster, arguments: {
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
