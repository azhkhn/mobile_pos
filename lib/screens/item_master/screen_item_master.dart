// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/text/converters.dart';
import 'package:shop_ez/db/db_functions/brand/brand_database.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sub_category/sub_category_db.dart';
import 'package:shop_ez/db/db_functions/unit/unit_database.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

const vatMethodList = ['Exclusive', 'Inclusive'];
const productTypeList = ['Standard', 'Service'];

class ScreenItemMaster extends StatelessWidget {
  ScreenItemMaster({Key? key}) : super(key: key);

  //========== MediaQuery Screen Size ==========
  late Size _screenSize;

  //========== Global Keys ==========
  final _dropdownKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  //========== Database Instances ==========
  final itemMasterDB = ItemMasterDatabase.instance;
  final categoryDB = CategoryDatabase.instance;
  final subCategoryDB = SubCategoryDatabase.instance;
  final brandDB = BrandDatabase.instance;
  final unitDB = UnitDatabase.instance;
  final vatDB = VatDatabase.instance;

  //========== Text Editing Controllers ==========
  final _itemNameController = TextEditingController();
  final _itemNameArabicController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _itemCostController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _secondarySellingPriceController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _alertQuantityController = TextEditingController();
  final _dateController = TextEditingController();

  //========== Date to String ==========
  String? _selectedDate;

  //========== Dropdown Field ==========
  String? _productTypeController;
  String? _itemCategoryController;
  String? _itemSubCategoryController;
  String? _itemBrandController;
  String? _productVatController;
  String? _vatId;
  String? _unitController;
  String? _vatMethodController;

  //========== Image File Path ==========
  File? image;

  //========== Value Notifiers ==========
  ValueNotifier<File?> selectedImageNotifier = ValueNotifier(null);
  ValueNotifier<String?> itemCategoryNotifier = ValueNotifier(null);

  //========== Focus Node for TextFields ==========
  FocusNode itemNameFocusNode = FocusNode();
  FocusNode itemNameArabicFocusNode = FocusNode();
  FocusNode itemCodeFocusNode = FocusNode();
  FocusNode itemCostFocusNode = FocusNode();
  FocusNode sellingPriceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // itemMasterDB.getAllItems();
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
                      contentPadding: EdgeInsets.all(10),
                    ),
                    isExpanded: true,
                    items: productTypeList.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _productTypeController = value.toString();
                    },
                    validator: (value) {
                      if (value == null || _productTypeController == null) {
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
                        contentPadding: const EdgeInsets.all(10),
                        onChanged: (value) {
                          _dropdownKey.currentState!.reset();
                          _itemCategoryController = value.toString();
                          itemCategoryNotifier.value = value.toString();
                        },
                        validator: (value) {
                          if (value == null ||
                              _itemCategoryController == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  kHeight10,

                  //========== Item Sub-Category Dropdown ==========
                  ValueListenableBuilder(
                      valueListenable: itemCategoryNotifier,
                      builder: (context, String? category, _) {
                        return FutureBuilder(
                          future: subCategoryDB.getSubCategoryByCategory(
                              category: category ?? ''),
                          builder: (context, dynamic snapshot) {
                            return CustomDropDownField(
                              dropdownKey: _dropdownKey,
                              labelText: 'Item Sub-Category',
                              snapshot: snapshot,
                              contentPadding: const EdgeInsets.all(10),
                              onChanged: (value) {
                                _itemSubCategoryController = value.toString();
                              },
                            );
                          },
                        );
                      }),
                  kHeight10,

                  //========== Item Brand Dropdown ==========
                  FutureBuilder(
                    future: brandDB.getAllBrands(),
                    builder: (context, dynamic snapshot) {
                      return CustomDropDownField(
                        labelText: 'Item Brand',
                        snapshot: snapshot,
                        contentPadding: const EdgeInsets.all(10),
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
                    textInputType: TextInputType.number,
                    inputFormatters: Converter.digitsOnly,
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
                    textInputType: TextInputType.number,
                    inputFormatters: Converter.digitsOnly,
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
                    textInputType: TextInputType.number,
                    inputFormatters: Converter.digitsOnly,
                    controller: _secondarySellingPriceController,
                  ),
                  kHeight10,

                  //========== Product VAT Dropdown ==========
                  FutureBuilder(
                    future: vatDB.getAllVats(),
                    builder: (context, dynamic snapshot) {
                      return CustomDropDownField(
                        labelText: 'Product VAT *',
                        snapshot: snapshot,
                        contentPadding: const EdgeInsets.all(10),
                        onChanged: (value) async {
                          _productVatController = value.toString();
                          final _vat = await vatDB.getVatByName(value!);
                          _vatId = '${_vat.id}';
                          log('VAT id = $_vatId');
                        },
                        validator: (value) {
                          if (value == null || _productVatController == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  kHeight10,

                  //========== VAT Method Dropdown ==========
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text(
                        'VAT Method *',
                        style: TextStyle(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    isExpanded: true,
                    items: vatMethodList.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _vatMethodController = value.toString();
                    },
                    validator: (value) {
                      if (value == null || _vatMethodController == null) {
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
                        contentPadding: const EdgeInsets.all(10),
                        onChanged: (value) {
                          _unitController = value.toString();
                        },
                        validator: (value) {
                          if (value == null || _unitController == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  kHeight10,

                  //========== Date ==========
                  TextFeildWidget(
                    labelText: 'Expiry Date',
                    controller: _dateController,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      color: kSuffixIconColorBlack,
                      onPressed: () {},
                    ),
                    readOnly: true,
                    onTap: () async {
                      final _date = await datePicker(context);

                      if (_date != null) {
                        //Date to String for Database
                        _selectedDate = _date.toIso8601String();

                        log('selected date == $_selectedDate');
                        log('back to time == ${DateTime.parse(_selectedDate!)}');

                        final parseDate = Converter.dateFormat.format(_date);
                        _dateController.text = parseDate.toString();
                      }
                    },
                  ),
                  kHeight10,

                  //========== Opening Stock ==========
                  TextFeildWidget(
                    labelText: 'Opening Stock',
                    textInputType: TextInputType.number,
                    inputFormatters: Converter.digitsOnly,
                    controller: _openingStockController,
                  ),
                  kHeight10,

                  //========== Alert Quantity ==========
                  TextFeildWidget(
                    labelText: 'Alert Quantity',
                    textInputType: TextInputType.text,
                    inputFormatters: Converter.digitsOnly,
                    controller: _alertQuantityController,
                  ),
                  kHeight20,

                  //========== Item Image ==========
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kHeight10,
                      ValueListenableBuilder(
                          valueListenable: selectedImageNotifier,
                          builder: (context, File? selectedImage, _) {
                            return InkWell(
                              onTap: () => imagePopUp(context),
                              child: selectedImage != null
                                  ? Image.file(
                                      selectedImage,
                                      width: _screenSize.width / 2.5,
                                      height: _screenSize.width / 2.5,
                                      fit: BoxFit.fill,
                                    )
                                  : Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: _screenSize.width / 10,
                                    ),
                            );
                          }),
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

                  //========== Submit Button ==========
                  kHeight20,
                  CustomMaterialBtton(
                    buttonText: 'Submit',
                    onPressed: () => addItem(context: context),
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

  //========== Date Picker ==========
  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ),
      lastDate: DateTime.now().add(const Duration(days: 36500)),
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

      selectedImageNotifier.value = File(imageFile.path);
      log('selected Image = ${selectedImageNotifier.value}');

      // blobImage = await selectedImage.readAsBytes();
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
        vatId,
        productVAT,
        unit,
        expiryDate,
        openingStock,
        vatMethod,
        alertQuantity,
        itemImage;

    //========== Validating Text Form Fields ==========
    final _formState = _formKey.currentState!;

    if (_formState.validate()) {
      //Retieving values from TextFields to String
      productType = _productTypeController!;
      itemName = _itemNameController.text.trim();
      itemNameArabic = _itemNameArabicController.text.trim();
      itemCode = _itemCodeController.text.trim();
      itemCategory = _itemCategoryController!;
      itemSubCategory = _itemSubCategoryController ?? '';
      itemBrand = _itemBrandController ?? '';
      itemCost = _itemCostController.text.trim();
      sellingPrice = _sellingPriceController.text.trim();
      secondarySellingPrice = _secondarySellingPriceController.text.trim();
      vatId = _vatId!;
      productVAT = _productVatController!;
      unit = _unitController!;
      expiryDate = _selectedDate ?? '';
      openingStock = _openingStockController.text.isEmpty
          ? '0'
          : _openingStockController.text.trim();
      vatMethod = _vatMethodController!;
      alertQuantity = _alertQuantityController.text.trim();

      if (selectedImageNotifier.value != null) {
        //========== Getting Directory Path ==========
        final Directory extDir = await getApplicationDocumentsDirectory();
        String dirPath = extDir.path;
        final fileName = DateTime.now().microsecondsSinceEpoch.toString();
        // final fileName = basename(selectedImage!.path);
        final String filePath = '$dirPath/$fileName.jpg';

        //========== Coping Image to new path ==========
        image = await selectedImageNotifier.value!.copy(filePath);
        itemImage = image!.path;
      } else {
        itemImage = '';
      }

      final _itemMasterModel = ItemMasterModel(
          productType: productType,
          itemName: itemName,
          itemNameArabic: itemNameArabic,
          itemCode: itemCode,
          itemCategory: itemCategory,
          itemSubCategory: itemSubCategory,
          itemBrand: itemBrand,
          itemCost: itemCost,
          sellingPrice: sellingPrice,
          secondarySellingPrice: secondarySellingPrice,
          vatMethod: vatMethod,
          productVAT: productVAT,
          vatId: vatId,
          unit: unit,
          expiryDate: expiryDate,
          openingStock: openingStock,
          alertQuantity: alertQuantity,
          itemImage: itemImage);
      try {
        await itemMasterDB.createItem(_itemMasterModel);
        log('Item $itemName Added!');
        kSnackBar(
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
          kSnackBar(
            context: context,
            color: kSnackBarErrorColor,
            icon: const Icon(
              Icons.new_releases_outlined,
              color: kSnackBarIconColor,
            ),
            content: 'Item name already exist!',
          );
        } else if (e == 'ItemCode Already Exist!') {
          log('ItemCode Already Exist!');
          itemCodeFocusNode.requestFocus();
          kSnackBar(
            context: context,
            color: kSnackBarErrorColor,
            icon: const Icon(
              Icons.new_releases_outlined,
              color: kSnackBarIconColor,
            ),
            content: 'Item code already exist!',
          );
        }
      }
    } else {
      if (_itemNameController.text.isEmpty) {
        itemNameFocusNode.requestFocus();
      } else if (_itemNameArabicController.text.isEmpty) {
        itemNameArabicFocusNode.requestFocus();
      } else if (_itemCodeController.text.isEmpty) {
        itemCodeFocusNode.requestFocus();
      } else if (_itemCostController.text.isEmpty) {
        itemCostFocusNode.requestFocus();
      } else if (_sellingPriceController.text.isEmpty) {
        sellingPriceFocusNode.requestFocus();
      }
    }
  }
}
