// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

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
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenNegativeStockReport extends StatelessWidget {
  ScreenNegativeStockReport({Key? key}) : super(key: key);

  //========== TextEditing Controllers ==========
  final TextEditingController _productController = TextEditingController();

  //========== Value Notifiers ==========
  final ValueNotifier<List<ItemMasterModel>> itemsNotifier = ValueNotifier([]);
  final ValueNotifier<List<ItemMasterModel>> stableItemsNotifier = ValueNotifier([]);

  //========== Database Instances ==========
  final ItemMasterDatabase itemMasterDB = ItemMasterDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Negative Stock Report'),
      body: SafeArea(
        child: ItemScreenPaddingWidget(
            child: Column(
          children: [
            TypeAheadField(
              minCharsForSuggestions: 0,
              debounceDuration: const Duration(milliseconds: 500),
              hideSuggestionsOnKeyboardHide: true,
              textFieldConfiguration: TextFieldConfiguration(
                  controller: _productController,
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
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: const Icon(Icons.clear),
                        onTap: () async {
                          _productController.clear();

                          if (stableItemsNotifier.value.isNotEmpty) {
                            itemsNotifier.value = stableItemsNotifier.value;
                          } else {
                            stableItemsNotifier.value = await itemMasterDB.getAllItems();
                            itemsNotifier.value = stableItemsNotifier.value;
                          }
                        },
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Search product by name/code',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                  )),
              noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!'))),
              suggestionsCallback: (pattern) async {
                return stableItemsNotifier.value.where((item) => item.itemName.contains(pattern));
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
              onSuggestionSelected: (ItemMasterModel suggestion) async {
                final itemId = suggestion.id;
                _productController.text = suggestion.itemName;
                itemsNotifier.value = await itemMasterDB.getProductById(itemId!);

                log(suggestion.itemName);
              },
            ),

            kHeight10,

            //========== List Items ==========
            Expanded(
              child: FutureBuilder(
                  future: ItemMasterDatabase.instance.getNegativeStock(),
                  builder: (context, AsyncSnapshot<List<ItemMasterModel>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:

                      default:
                        if (!snapshot.hasData) {
                          return const Center(child: Text('Products is Empty!'));
                        }
                        itemsNotifier.value = snapshot.data!;

                        if (stableItemsNotifier.value.isEmpty) {
                          stableItemsNotifier.value = snapshot.data!;
                        }
                        return ValueListenableBuilder(
                            valueListenable: itemsNotifier,
                            builder: (context, List<ItemMasterModel> items, _) {
                              return items.isNotEmpty
                                  ? ListView.separated(
                                      itemCount: items.length,
                                      separatorBuilder: (BuildContext context, int index) => kHeight5,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ItemCardWidget(
                                          index: index,
                                          product: items[index],
                                        );
                                      },
                                    )
                                  : const Center(child: Text('Products is Empty!'));
                            });
                    }
                  }),
            ),
          ],
        )),
      ),
    );
  }
}
