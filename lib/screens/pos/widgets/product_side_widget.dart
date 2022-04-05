import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../db/db_functions/brand_database/brand_database.dart';
import '../../../db/db_functions/category_database/category_db.dart';
import '../../../db/db_functions/item_master_database/item_master_database.dart';
import '../../../db/db_functions/sub-category_database/sub_category_db.dart';
import '../../../model/item_master/item_master_model.dart';
import '../../../widgets/button_widgets/material_button_widget.dart';

class ProductSideWidget extends StatefulWidget {
  const ProductSideWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductSideWidget> createState() => _ProductSideWidgetState();
}

class _ProductSideWidgetState extends State<ProductSideWidget> {
  //========== Database Instances ==========
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final itemMasterDB = ItemMasterDatabase.instance;

  //========== FutureBuilder Database ==========
  Future<List<dynamic>>? futureGrid = ItemMasterDatabase.instance.getAllItems();

  //========== FutureBuilder ModelClass by Integer ==========
  int? builderModel;

  //========== MediaQuery Screen Size ==========
  late Size _screenSize;

  //========== TextEditing Controllers ==========
  final _productController = TextEditingController();

  final List<ItemMasterModel> _selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: _screenSize.width / 1.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //========== Get All Products Search Field ==========
          TypeAheadField(
            debounceDuration: const Duration(milliseconds: 500),
            hideSuggestionsOnKeyboardHide: false,
            textFieldConfiguration: TextFieldConfiguration(
                controller: _productController,
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
                      onTap: () {
                        _productController.clear();
                        builderModel = null;
                        futureGrid = itemMasterDB.getAllItems();
                        setState(() {});
                      },
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'Search product by name/code',
                  border: const OutlineInputBorder(),
                )),
            noItemsFoundBuilder: (context) => const SizedBox(
                height: 50, child: Center(child: Text('No Product Found!'))),
            suggestionsCallback: (pattern) async {
              return itemMasterDB.getProductSuggestions(pattern);
            },
            itemBuilder: (context, ItemMasterModel suggestion) {
              return ListTile(
                title: AutoSizeText(suggestion.itemName,
                    maxLines: 1,
                    minFontSize: 8,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                    )),
              );
            },
            onSuggestionSelected: (ItemMasterModel suggestion) {
              final itemId = suggestion.id;
              _productController.text = suggestion.itemName;
              futureGrid = itemMasterDB.getProductById(itemId!);
              builderModel = null;
              setState(() {});
              log(suggestion.itemName);
            },
          ),

          //==================== Quick Filter Buttons ====================
          Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomMaterialBtton(
                    buttonColor: Colors.blue,
                    onPressed: () {
                      futureGrid = categoryDB.getAllCategories();
                      builderModel = 0;
                      setState(() {});
                    },
                    buttonText: 'Categories'),
              ),
              kWidth5,
              Expanded(
                flex: 5,
                child: CustomMaterialBtton(
                    onPressed: () {
                      futureGrid = subCategoryDB.getAllSubCategories();
                      builderModel = 1;
                      setState(() {});
                    },
                    buttonColor: Colors.orange,
                    buttonText: 'Sub Categories'),
              ),
              kWidth5,
              Expanded(
                flex: 3,
                child: CustomMaterialBtton(
                  onPressed: () {
                    futureGrid = brandDB.getAllBrands();
                    builderModel = 2;
                    setState(() {});
                  },
                  buttonColor: Colors.indigo,
                  buttonText: 'Brands',
                ),
              ),
              kWidth5,
              Expanded(
                flex: 2,
                child: MaterialButton(
                  onPressed: () {
                    _productController.clear();
                    builderModel = null;
                    futureGrid = itemMasterDB.getAllItems();
                    setState(() {});
                  },
                  color: Colors.blue,
                  child: const Icon(
                    Icons.rotate_left,
                    color: kWhite,
                  ),
                ),
              )
            ],
          ),

          //==================== Product Listing Grid ====================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                  future: futureGrid,
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    final dynamic itemList;
                    if (snapshot.hasData) {
                      itemList = snapshot.data!;
                    } else {
                      itemList = [];
                    }
                    log('${itemList.length}');
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      const Center(
                        child: AutoSizeText('No Item Found!'),
                      );
                    }
                    return snapshot.hasData && itemList.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: (1 / .75),
                            ),
                            itemCount: itemList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (builderModel == 0) {
                                    log(itemList[index].category);
                                    final category = itemList[index].category;
                                    builderModel = null;
                                    futureGrid = itemMasterDB
                                        .getProductByCategory(category);
                                    setState(() {});
                                  } else if (builderModel == 1) {
                                    log(itemList[index].subCategory);
                                    final subCategory =
                                        itemList[index].subCategory;
                                    builderModel = null;
                                    futureGrid = itemMasterDB
                                        .getProductBySubCategory(subCategory);
                                    setState(() {});
                                  } else if (builderModel == 2) {
                                    log(itemList[index].brand);
                                    final brand = itemList[index].brand;
                                    builderModel = null;
                                    futureGrid =
                                        itemMasterDB.getProductByBrand(brand);
                                    setState(() {});
                                  } else {
                                    _selectedProducts.add(itemList[index]);
                                    log('length == ${_selectedProducts.length}');

                                    const sales = SaleSideWidget();
                                    sales.callback(_selectedProducts);
                                  }
                                },
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      child: builderModel == null
                                          ? Column(
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: AutoSizeText(
                                                    itemList[index].itemName ??
                                                        '',
                                                    textAlign: TextAlign.center,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontSize: 8),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 8,
                                                    maxFontSize: 10,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: FittedBox(
                                                    child: Text(
                                                      'Qty : ' +
                                                          itemList[index]
                                                              .openingStock,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 8),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: FittedBox(
                                                    child: Text(
                                                      '₹ ' +
                                                          itemList[index]
                                                              .itemCost,
                                                      style: const TextStyle(
                                                          fontSize: 8),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AutoSizeText(
                                                  builderModel == 0
                                                      ? itemList[index].category
                                                      : builderModel == 1
                                                          ? itemList[index]
                                                              .subCategory
                                                          : builderModel == 2
                                                              ? itemList[index]
                                                                  .brand
                                                              : '',
                                                  textAlign: TextAlign.center,
                                                  minFontSize: 8,
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: builderModel == 0 &&
                                                          itemList[index]
                                                              .category
                                                              .toString()
                                                              .contains(' ')
                                                      ? 2
                                                      : builderModel == 1 &&
                                                              itemList[index]
                                                                  .subCategory
                                                                  .toString()
                                                                  .contains(' ')
                                                          ? 2
                                                          : builderModel == 2 &&
                                                                  itemList[
                                                                          index]
                                                                      .brand
                                                                      .toString()
                                                                      .contains(
                                                                          ' ')
                                                              ? 2
                                                              : 1,
                                                ),
                                              ],
                                            )),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: AutoSizeText('No Item Found!'),
                          );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
