import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/brand_database/brand_database.dart';
import 'package:shop_ez/db/db_functions/category_database/category_db.dart';
import 'package:shop_ez/db/db_functions/sub-category_database/sub_category_db.dart';
import 'package:shop_ez/db/db_functions/unit_database/unit_database.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenItemMaster extends StatefulWidget {
  const ScreenItemMaster({Key? key}) : super(key: key);

  static const vatMethodList = ['Exclusive', 'Inclusive'];
  static const productTypeList = ['Standard', 'Service'];
  @override
  State<ScreenItemMaster> createState() => _ScreenItemMasterState();
}

class _ScreenItemMasterState extends State<ScreenItemMaster> {
  late Size _screenSize;
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final unitDB = UnitDatabase.instance;

  String _productTypeController = 'null';
  String _itemCategoryController = 'null';
  String _itemSubCategoryController = 'null';
  String _itemBrandController = 'null';
  String _productVatController = 'null';
  String _unitController = 'null';
  String _vatMethodController = 'null';

  final _itemNameController = TextEditingController();
  final _itemNameArabicController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _itemCostController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _secondarySellingPriceController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _itemImageController = TextEditingController();
  final _alertQuantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Item Master',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //========== Product Type Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Product Type *',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  isExpanded: true,
                  items: ScreenItemMaster.productTypeList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _productTypeController = value.toString();
                    });
                  },
                  validator: (value) {
                    return null;
                  },
                ),
                kHeight10,

                //========== Item Name ==========
                TextFeildWidget(
                  labelText: 'Item Name *',
                  textInputType: TextInputType.text,
                  controller: _itemNameController,
                ),
                kHeight10,

                //========== Item Name in Arabic ==========
                TextFeildWidget(
                  labelText: 'Item Name in Arabic *',
                  textInputType: TextInputType.text,
                  controller: _itemNameArabicController,
                ),
                kHeight10,

                //========== Item Code ==========
                TextFeildWidget(
                  labelText: 'Item Code *',
                  textInputType: TextInputType.text,
                  controller: _itemCodeController,
                ),
                kHeight10,

                //========== Item Category Dropdown ==========
                FutureBuilder(
                  future: categoryDB.getAllCategories(),
                  builder: (context, dynamic snapshot) {
                    return CustomDropDownField(
                      labelText: 'Select Category *',
                      snapshot: snapshot,
                      onChanged: (value) {
                        setState(() {
                          _itemCategoryController = value.toString();
                        });
                      },
                    );
                  },
                ),
                kHeight10,

                //========== Item Sub-Category Dropdown ==========
                FutureBuilder(
                  future: subCategoryDB.getSubCategoryByCategory(
                      category: _itemCategoryController),
                  builder: (context, dynamic snapshot) {
                    return CustomDropDownField(
                      labelText: 'Item Sub-Category',
                      snapshot: snapshot,
                      onChanged: (value) {
                        _itemSubCategoryController = value.toString();
                      },
                    );
                  },
                ),
                kHeight10,

                //========== Item Brand Dropdown ==========
                FutureBuilder(
                  future: brandDB.getAllBrands(),
                  builder: (context, dynamic snapshot) {
                    return CustomDropDownField(
                      labelText: 'Item Brand',
                      snapshot: snapshot,
                      onChanged: (value) {
                        _itemBrandController = value.toString();
                      },
                    );
                  },
                ),
                kHeight10,

                //========== Item Cost ==========
                TextFeildWidget(
                  labelText: 'Item Cost *',
                  textInputType: TextInputType.text,
                  controller: _itemCostController,
                ),
                kHeight10,

                //========== Selling Price ==========
                TextFeildWidget(
                  labelText: 'Selling Price *',
                  textInputType: TextInputType.text,
                  controller: _sellingPriceController,
                ),
                kHeight10,

                //========== Secondary Selling Price ==========
                TextFeildWidget(
                  labelText: 'Secondary Selling Price',
                  textInputType: TextInputType.text,
                  controller: _secondarySellingPriceController,
                ),
                kHeight10,

                //========== Product VAT Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Product VAT *',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  isExpanded: true,
                  items: ScreenItemMaster.productTypeList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _productVatController = value.toString();
                    });
                  },
                  validator: (value) {
                    return null;
                  },
                ),
                kHeight10,

                //========== Unit Dropdown ==========
                FutureBuilder(
                  future: unitDB.getAllUnits(),
                  builder: (context, dynamic snapshot) {
                    return CustomDropDownField(
                      labelText: 'Unit *',
                      snapshot: snapshot,
                      onChanged: (value) {
                        _unitController = value.toString();
                      },
                    );
                  },
                ),
                kHeight10,

                //========== Opening Stock ==========
                TextFeildWidget(
                  labelText: 'Opening Stock',
                  textInputType: TextInputType.text,
                  controller: _openingStockController,
                ),
                kHeight10,

                //========== Item Image ==========
                TextFeildWidget(
                  labelText: 'Item Image',
                  textInputType: TextInputType.text,
                  controller: _openingStockController,
                ),
                kHeight10,

                //========== VAT Method Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'VAT Method *',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  isExpanded: true,
                  items: ScreenItemMaster.vatMethodList.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _vatMethodController = value.toString();
                    });
                  },
                  validator: (value) {
                    return null;
                  },
                ),
                kHeight10,

                //========== Alert Quantity ==========
                TextFeildWidget(
                  labelText: 'Alert Quantity',
                  textInputType: TextInputType.text,
                  controller: _alertQuantityController,
                ),

                //========== Submit Button ==========
                kHeight20,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _screenSize.width / 10,
                  ),
                  child: CustomMaterialBtton(
                    buttonText: 'Submit',
                    onPressed: () {},
                  ),
                ),
                kHeight10,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
