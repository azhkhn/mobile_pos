import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/item_master/widgets/item_card_widget.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenStockReOrderReport extends StatelessWidget {
  ScreenStockReOrderReport({Key? key}) : super(key: key);

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
      appBar: AppBarWidget(title: 'Stock Re-Order Report'),
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
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: const Icon(Icons.clear),
                        onTap: () async {
                          _productController.clear();

                          itemsNotifier.value = stableItemsNotifier.value;
                        },
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: 'Search product by name/code',
                    hintStyle: kText12,
                    border: const OutlineInputBorder(),
                  )),
              noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Product Found!', style: kText12))),
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
              onSuggestionSelected: (ItemMasterModel selectedItem) async {
                _productController.text = selectedItem.itemName;
                itemsNotifier.value = [selectedItem];

                log(selectedItem.itemName);
              },
            ),

            kHeight10,

            //========== List Items ==========
            Expanded(
              child: FutureBuilder(
                  future: ItemMasterDatabase.instance.getReOrderStock(),
                  builder: (context, AsyncSnapshot<List<ItemMasterModel>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:

                      default:
                        if (!snapshot.hasData) return const Center(child: Text('No re-order stocks!'));
                        if (snapshot.data!.isEmpty) return const Center(child: Text('No re-order stocks!'));
                        itemsNotifier.value = snapshot.data!;

                        if (stableItemsNotifier.value.isEmpty) {
                          stableItemsNotifier.value = snapshot.data!;
                        }
                        return ValueListenableBuilder(
                            valueListenable: itemsNotifier,
                            builder: (context, List<ItemMasterModel> items, _) {
                              return items.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: items.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ItemCardWidget(
                                          index: index,
                                          product: items[index],
                                        );
                                      },
                                    )
                                  : const Center(child: Text('No re-order stocks!'));
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
