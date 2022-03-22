import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/brand_database/brand_database.dart';
import 'package:shop_ez/db/db_functions/category_database/category_db.dart';
import 'package:shop_ez/db/db_functions/item_master_database/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sub-category_database/sub_category_db.dart';
import 'package:shop_ez/db/db_functions/unit_database/unit_database.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
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
  final _dropdownKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  final itemMasterDB = ItemMasterDatabase.instance;
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final unitDB = UnitDatabase.instance;

  final _itemNameController = TextEditingController();
  final _itemNameArabicController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _itemCostController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _secondarySellingPriceController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _alertQuantityController = TextEditingController();

  String _productTypeController = 'null';
  String _itemCategoryController = 'null';
  String _itemSubCategoryController = 'null';
  String _itemBrandController = 'null';
  String _productVatController = 'null';
  String _unitController = 'null';
  String _vatMethodController = 'null';

  File? image;

  FocusNode itemNameFocusNode = FocusNode();
  FocusNode itemNameArabicFocusNode = FocusNode();
  FocusNode itemCodeFocusNode = FocusNode();
  FocusNode itemCostFocusNode = FocusNode();
  FocusNode sellingPriceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    itemMasterDB.getAllItems();
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Item Master',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                      if (value == null || _productTypeController == 'null') {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Item Name ==========
                  TextFeildWidget(
                    labelText: 'Item Name *',
                    textInputType: TextInputType.text,
                    controller: _itemNameController,
                    focusNode: itemNameFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Item Name in Arabic ==========
                  TextFeildWidget(
                    labelText: 'Item Name in Arabic *',
                    textInputType: TextInputType.text,
                    controller: _itemNameArabicController,
                    focusNode: itemNameArabicFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Item Code ==========
                  TextFeildWidget(
                    labelText: 'Item Code *',
                    textInputType: TextInputType.text,
                    controller: _itemCodeController,
                    focusNode: itemCodeFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Item Category Dropdown ==========
                  FutureBuilder(
                    future: categoryDB.getAllCategories(),
                    builder: (context, dynamic snapshot) {
                      return CustomDropDownField(
                        labelText: 'Item Category *',
                        snapshot: snapshot,
                        onChanged: (value) {
                          setState(() {
                            _dropdownKey.currentState!.reset();
                            _itemCategoryController = value.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              _itemCategoryController == 'null') {
                            return 'This field is required*';
                          }
                          return null;
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
                        dropdownKey: _dropdownKey,
                        labelText: 'Item Sub-Category',
                        snapshot: snapshot,
                        onChanged: (value) {
                          _itemSubCategoryController = value.toString();
                        },
                        validator: (value) {
                          if (value == null ||
                              _itemSubCategoryController == 'null') {
                            return 'This field is required*';
                          }
                          return null;
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
                        validator: (value) {
                          if (value == null || _itemBrandController == 'null') {
                            return 'This field is required*';
                          }
                          return null;
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
                    focusNode: itemCostFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Selling Price ==========
                  TextFeildWidget(
                    labelText: 'Selling Price *',
                    textInputType: TextInputType.text,
                    controller: _sellingPriceController,
                    focusNode: sellingPriceFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
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
                      if (value == null || _productVatController == 'null') {
                        return 'This field is required*';
                      }
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
                        validator: (value) {
                          if (value == null || _unitController == 'null') {
                            return 'This field is required*';
                          }
                          return null;
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
                  kHeight20,

                  //========== Item Image ==========
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kHeight10,
                      InkWell(
                        onTap: () => imagePopUp(context),
                        child: image != null
                            ? Image.file(
                                image!,
                                width: _screenSize.width / 2.5,
                                height: _screenSize.width / 2.5,
                                fit: BoxFit.fill,
                              )
                            : const Icon(Icons.add_photo_alternate_outlined),
                      ),
                      kHeight10,
                      const Text(
                        'Item Image',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
                      if (value == null || _vatMethodController == 'null') {
                        return 'This field is required*';
                      }
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
                      onPressed: () => addItem(context: context),
                    ),
                  ),
                  kHeight10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//========== Image PopUp ==========
  void imagePopUp(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                imagePicker(ImageSource.camera);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Gallery'),
              onTap: () {
                imagePicker(ImageSource.gallery);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

//========== Image Picker ==========
  void imagePicker(ImageSource imageSource) async {
    final imagePicker = ImagePicker();
    try {
      final imageFile = await imagePicker.pickImage(source: imageSource);
      if (imageFile == null) return;

      File selectedImage = File(imageFile.path);

      //getting a directory path for saving
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final fileName = basename(imageFile.path);
      final String filePath = '$dirPath/$fileName';

      // copy the file to a new path
      image = await selectedImage.copy(filePath);

      // blobImage = await selectedImage.readAsBytes();
      setState(() {});
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }

  //========== Add Item ==========
  Future<void> addItem({context}) async {
    final String productType,
        itemName,
        itemNameArabic,
        itemCode,
        itemCategory,
        itemSubCategory,
        itemBrand,
        itemCost,
        sellingPrice,
        secondarySellingPrice,
        productVAT,
        unit,
        openingStock,
        vatMethod,
        alertQuantity,
        itemImage;

    //retieving values from TextFields to String
    productType = _productTypeController;
    itemName = _itemNameController.text.trim();
    itemNameArabic = _itemNameArabicController.text.trim();
    itemCode = _itemCodeController.text.trim();
    itemCategory = _itemCategoryController;
    itemSubCategory = _itemSubCategoryController;
    itemBrand = _itemBrandController;
    itemCost = _itemCostController.text.trim();
    sellingPrice = _sellingPriceController.text.trim();
    secondarySellingPrice = _secondarySellingPriceController.text.trim();
    productVAT = _productVatController;
    unit = _unitController;
    openingStock = _openingStockController.text.trim();
    vatMethod = _vatMethodController;
    alertQuantity = _alertQuantityController.text.trim();
    itemImage = image?.path ?? '';

    final _formState = _formKey.currentState!;

    if (_formState.validate()) {
      final _itemMasterModel = ItemMasterModel(
        productType: productType,
        itemName: itemName,
        itemNameArabic: itemNameArabic,
        itemCode: itemCode,
        itemCategory: itemCategory,
        itemCost: itemCost,
        sellingPrice: sellingPrice,
        productVAT: productVAT,
        unit: unit,
        vatMethod: vatMethod,
        itemSubCategory: itemSubCategory,
        itemBrand: itemBrand,
        secondarySellingPrice: secondarySellingPrice,
        openingStock: openingStock,
        alertQuantity: alertQuantity,
        itemImage: itemImage,
      );
      try {
        await itemMasterDB.createItem(_itemMasterModel);
        log('Item $itemName Added!');
        showSnackBar(
            context: context,
            color: kSnackBarSuccessColor,
            icon: const Icon(
              Icons.done,
              color: kSnackBarIconColor,
            ),
            content: 'Item "$itemName" added successfully!');
      } catch (e) {
        if (e == 'Item Already Exist!') {
          log('Item Already Exist!');
          itemNameFocusNode.requestFocus();
          showSnackBar(
            context: context,
            color: kSnackBarErrorColor,
            icon: const Icon(
              Icons.new_releases_outlined,
              color: kSnackBarIconColor,
            ),
            content: 'Item name already exist!',
          );
        }
      }
    } else {
      if (itemName.isEmpty) {
        itemNameFocusNode.requestFocus();
      } else if (itemNameArabic.isEmpty) {
        itemNameArabicFocusNode.requestFocus();
      } else if (itemCode.isEmpty) {
        itemCodeFocusNode.requestFocus();
      } else if (itemCost.isEmpty) {
        itemCostFocusNode.requestFocus();
      } else if (sellingPrice.isEmpty) {
        sellingPriceFocusNode.requestFocus();
      } else if (itemCost.isEmpty) {
        itemCostFocusNode.requestFocus();
      }
    }
  }

  //========== Show SnackBar ==========
  void showSnackBar(
      {required BuildContext context,
      required String content,
      Color? color,
      Widget? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon ?? const Text(''),
            kWidth5,
            Flexible(
              child: Text(
                content,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
