// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/db/db_functions/brand/brand_database.dart';
import 'package:shop_ez/db/db_functions/category/category_db.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/db/db_functions/sub_category/sub_category_db.dart';
import 'package:shop_ez/db/db_functions/unit/unit_database.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/model/sub-category/sub_category_model.dart';
import 'package:shop_ez/model/unit/unit_model.dart';
import 'package:shop_ez/model/vat/vat_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenItemMaster extends StatefulWidget {
  const ScreenItemMaster({Key? key, this.from = false, this.itemMasterModel}) : super(key: key);

  //========== Bool ==========
  final bool from;

  //========== Model Calsses ==========
  final ItemMasterModel? itemMasterModel;

  @override
  State<ScreenItemMaster> createState() => _ScreenItemMasterState();
}

class _ScreenItemMasterState extends State<ScreenItemMaster> {
  //========== Global Keys ==========
  final _dropdownKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  //========== Lists ==========
  final List<String> vatMethodList = ['Exclusive', 'Inclusive'];
  final List<String> productTypeList = ['Standard', 'Service'];

  //========== Database Instances ==========
  final ItemMasterDatabase itemMasterDB = ItemMasterDatabase.instance;
  final CategoryDatabase categoryDB = CategoryDatabase.instance;
  final SubCategoryDatabase subCategoryDB = SubCategoryDatabase.instance;
  final BrandDatabase brandDB = BrandDatabase.instance;
  final UnitDatabase unitDB = UnitDatabase.instance;
  final VatDatabase vatDB = VatDatabase.instance;

  //========== Text Editing Controllers ==========
  final _itemNameController = TextEditingController();
  final _itemNameArabicController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _itemCostController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  // final _secondarySellingPriceController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _alertQuantityController = TextEditingController();
  final _dateController = TextEditingController();

  //========== Date to String ==========
  String? _selectedDate;

  //========== Dropdown Field ==========
  int? _itemCategoryId;
  int? _itemSubCategoryId;
  int? _itemBrandId;
  int? _itemVatId;
  int? _itemVatRate;
  String? _productVatController;
  String? _itemUnit;

  //========== Image File Path ==========
  File? image;

  //========== Value Notifiers ==========
  final ValueNotifier<File?> selectedImageNotifier = ValueNotifier(null);
  final ValueNotifier<int> itemCategoryNotifier = ValueNotifier(0);
  final ValueNotifier<String?> productTypeNotifier = ValueNotifier(null);
  final ValueNotifier<String?> vatMethodNotifier = ValueNotifier(null);

  //========== Focus Node for TextFields ==========
  FocusNode itemNameFocusNode = FocusNode();
  FocusNode itemNameArabicFocusNode = FocusNode();
  FocusNode itemCodeFocusNode = FocusNode();
  FocusNode itemCostFocusNode = FocusNode();
  FocusNode sellingPriceFocusNode = FocusNode();

  //========== Futures ==========
  Future<dynamic>? futureCategory;
  Future<dynamic>? futureSubCategory;
  Future<dynamic>? futureBrand;
  Future<dynamic>? futureVat;
  Future<dynamic>? futureUnit;

  @override
  void initState() {
    super.initState();
    if (widget.itemMasterModel != null) getProductDetails(widget.itemMasterModel!);

    futureCategory = categoryDB.getAllCategories();
    futureSubCategory = subCategoryDB.getSubCategoryByCategoryId(categoryId: itemCategoryNotifier.value);
    futureBrand = brandDB.getAllBrands();
    futureVat = vatDB.getAllVats();
    futureUnit = unitDB.getAllUnits();
  }

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.itemMasterModel == null ? 'Item Master' : 'Edit Product',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //========== Product Type Dropdown ==========
                  ValueListenableBuilder(
                      valueListenable: productTypeNotifier,
                      builder: (context, productType, _) {
                        return DropdownButtonFormField(
                          decoration: const InputDecoration(
                            label: Text(
                              'Product Type *',
                              style: TextStyle(color: klabelColorGrey),
                            ),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          isExpanded: true,
                          value: productType,
                          items: productTypeList.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            productTypeNotifier.value = value.toString();
                          },
                          validator: (value) {
                            if (value == null || productTypeNotifier.value == null) {
                              return 'This field is required*';
                            }
                            return null;
                          },
                        );
                      }),
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
                    labelText: 'Item Name Arabic *',
                    textInputType: TextInputType.text,
                    controller: _itemNameArabicController,
                    textDirection: TextDirection.rtl,
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
                    future: futureCategory,
                    builder: (context, dynamic snapshot) {
                      final snap = snapshot as AsyncSnapshot;
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                        default:
                          final List<CategoryModel> _categories = snap.data;
                          return CustomDropDownField(
                            labelText: 'Item Category *',
                            snapshot: snapshot.data,
                            value: _itemCategoryId != null ? jsonEncode(_categories.where((cat) => cat.id == _itemCategoryId).toList().first) : null,
                            contentPadding: const EdgeInsets.all(10),
                            onChanged: (value) {
                              _dropdownKey.currentState!.reset();
                              final CategoryModel category = CategoryModel.fromJson(jsonDecode(value!));
                              log('Category Id == ' + category.id.toString());
                              log('Category == ' + category.category);
                              _itemCategoryId = category.id;
                              itemCategoryNotifier.value = category.id!;
                            },
                            validator: (value) {
                              if (value == null || _itemCategoryId == null) {
                                return 'This field is required*';
                              }
                              return null;
                            },
                          );
                      }
                    },
                  ),
                  kHeight10,

                  //========== Item Sub-Category Dropdown ==========
                  ValueListenableBuilder(
                      valueListenable: itemCategoryNotifier,
                      builder: (context, int categoryId, _) {
                        return FutureBuilder(
                          future: futureSubCategory,
                          builder: (context, dynamic snapshot) {
                            final snap = snapshot as AsyncSnapshot;
                            switch (snap.connectionState) {
                              case ConnectionState.waiting:
                                return const CircularProgressIndicator();
                              case ConnectionState.done:
                              default:
                                final List<SubCategoryModel> _subCategories = snap.data;
                                return CustomDropDownField(
                                  dropdownKey: _dropdownKey,
                                  labelText: 'Item Sub-Category',
                                  snapshot: snapshot.data,
                                  value: _itemSubCategoryId != null
                                      ? jsonEncode(_subCategories.where((subCat) => subCat.id == _itemSubCategoryId).toList().first)
                                      : null,
                                  contentPadding: const EdgeInsets.all(10),
                                  onChanged: (value) {
                                    final SubCategoryModel subCategory = SubCategoryModel.fromJson(jsonDecode(value!));
                                    log('Sub Category Id == ' + subCategory.id.toString());
                                    log('Sub Category == ' + subCategory.subCategory);
                                    _itemSubCategoryId = subCategory.id;
                                  },
                                );
                            }
                          },
                        );
                      }),
                  kHeight10,

                  //========== Item Brand Dropdown ==========
                  FutureBuilder(
                    future: futureBrand,
                    builder: (context, dynamic snapshot) {
                      final snap = snapshot as AsyncSnapshot;
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                        default:
                          final List<BrandModel> _brands = snap.data;

                          return CustomDropDownField(
                            labelText: 'Item Brand',
                            snapshot: snapshot.data,
                            value: _itemBrandId != null ? jsonEncode(_brands.where((brand) => brand.id == _itemBrandId).toList().first) : null,
                            contentPadding: const EdgeInsets.all(10),
                            onChanged: (value) {
                              final BrandModel brand = BrandModel.fromJson(jsonDecode(value!));
                              log('Brand Is == ' + brand.id.toString());
                              log('Brand == ' + brand.brand);
                              _itemBrandId = brand.id;
                            },
                          );
                      }
                    },
                  ),
                  kHeight10,

                  //========== Item Cost ==========
                  TextFeildWidget(
                    labelText: 'Item Cost *',
                    textInputType: TextInputType.number,
                    inputFormatters: Validators.digitsOnly,
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
                    inputFormatters: Validators.digitsOnly,
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

                  // //========== Secondary Selling Price ==========
                  // TextFeildWidget(
                  //   labelText: 'Secondary Selling Price',
                  //   textInputType: TextInputType.number,
                  //   inputFormatters: Converter.digitsOnly,
                  //   controller: _secondarySellingPriceController,
                  // ),
                  // kHeight10,

                  //========== Product VAT Dropdown ==========
                  FutureBuilder(
                    future: futureVat,
                    builder: (context, dynamic snapshot) {
                      final snap = snapshot as AsyncSnapshot;
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                        default:
                          final List<VatModel> _vats = snap.data;
                          return CustomDropDownField(
                            labelText: 'Product VAT *',
                            snapshot: snapshot.data,
                            value: _itemVatId != null ? jsonEncode(_vats.where((vat) => vat.id == _itemVatId).toList().first) : null,
                            contentPadding: const EdgeInsets.all(10),
                            onChanged: (value) async {
                              _productVatController = value.toString();
                              final _vat = VatModel.fromJson(jsonDecode(value!));
                              _itemVatId = _vat.id;
                              _itemVatRate = _vat.rate;

                              log('VAT id = $_itemVatId');
                            },
                            validator: (value) {
                              if (value == null || _productVatController == null) {
                                return 'This field is required*';
                              }
                              return null;
                            },
                          );
                      }
                    },
                  ),
                  kHeight10,

                  //========== VAT Method Dropdown ==========
                  ValueListenableBuilder(
                      valueListenable: vatMethodNotifier,
                      builder: (context, _vatMethod, _) {
                        return DropdownButtonFormField(
                          decoration: const InputDecoration(
                            label: Text(
                              'VAT Method *',
                              style: TextStyle(color: klabelColorGrey),
                            ),
                            contentPadding: EdgeInsets.all(10),
                          ),
                          isExpanded: true,
                          value: _vatMethod,
                          items: vatMethodList.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            vatMethodNotifier.value = value.toString();
                          },
                          validator: (value) {
                            if (value == null || vatMethodNotifier.value == null) {
                              return 'This field is required*';
                            }
                            return null;
                          },
                        );
                      }),
                  kHeight10,

                  //========== Unit Dropdown ==========
                  FutureBuilder(
                    future: futureUnit,
                    builder: (context, dynamic snapshot) {
                      final snap = snapshot as AsyncSnapshot;
                      switch (snap.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                        default:
                          return CustomDropDownField(
                            labelText: 'Unit *',
                            snapshot: snapshot.data,
                            value: _itemUnit,
                            contentPadding: const EdgeInsets.all(10),
                            onChanged: (value) {
                              final UnitModel unit = UnitModel.fromJson(jsonDecode(value!));
                              log('Unit Id == ' + unit.id.toString());
                              log('Unit == ' + unit.unit);
                              _itemUnit = value.toString();
                            },
                            validator: (value) {
                              if (value == null || _itemUnit == null) {
                                return 'This field is required*';
                              }
                              return null;
                            },
                          );
                      }
                    },
                  ),
                  kHeight10,

                  //========== Date ==========
                  TextFeildWidget(
                    labelText: 'Expiry Date',
                    controller: _dateController,
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: klabelColorGrey,
                      ),
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

                        _dateController.text = Converter.dateFormat.format(_date);
                      }
                    },
                  ),
                  kHeight10,

                  //========== Opening Stock ==========
                  TextFeildWidget(
                    labelText: 'Opening Stock',
                    textInputType: TextInputType.number,
                    inputFormatters: Validators.digitsOnly,
                    controller: _openingStockController,
                  ),
                  kHeight10,

                  //========== Alert Quantity ==========
                  TextFeildWidget(
                    labelText: 'Alert Quantity',
                    textInputType: TextInputType.text,
                    inputFormatters: Validators.digitsOnly,
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
                    buttonText: widget.itemMasterModel == null ? 'Add Product' : 'Update Product',
                    onPressed: () async {
                      if (widget.itemMasterModel == null) {
                        return await addItem(context);
                      } else {
                        return await addItem(context, isUpdate: true);
                      }
                    },
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
  Future<void> addItem(BuildContext context, {final bool isUpdate = false}) async {
    final int itemCategoryId, vatRate, vatId;
    final int? itemSubCategoryId, itemBrandId;
    final String productType,
        itemName,
        itemNameArabic,
        itemCode,
        itemCost,
        sellingPrice,
        secondarySellingPrice,
        productVAT,
        expiryDate,
        openingStock,
        vatMethod,
        unit,
        alertQuantity,
        itemImage;

    //========== Validating Text Form Fields ==========
    final _formState = _formKey.currentState!;

    if (_formState.validate()) {
      //Retieving values from TextFields to String
      productType = productTypeNotifier.value!;
      itemName = _itemNameController.text.trim();
      itemNameArabic = _itemNameArabicController.text.trim();
      itemCode = _itemCodeController.text.trim();
      itemCategoryId = _itemCategoryId!;
      itemSubCategoryId = _itemSubCategoryId!;
      itemBrandId = _itemBrandId;
      itemCost = _itemCostController.text.trim();
      sellingPrice = _sellingPriceController.text.trim();
      secondarySellingPrice = '';
      vatId = _itemVatId!;
      vatRate = _itemVatRate!;
      productVAT = _productVatController!;
      unit = _itemUnit!;
      expiryDate = _selectedDate ?? '';
      openingStock = _openingStockController.text.isEmpty ? '0' : _openingStockController.text.trim();
      vatMethod = vatMethodNotifier.value!;
      alertQuantity = _alertQuantityController.text.trim();

      if (selectedImageNotifier.value != null) {
        //========== Getting Directory Path ==========
        final Directory extDir = await getApplicationDocumentsDirectory();
        final String dirPath = extDir.path;
        final fileName = DateTime.now().microsecondsSinceEpoch.toString();
        // final fileName = basename(selectedImage!.path);
        final String filePath = '$dirPath/$fileName.jpg';

        //========== Coping Image to new path ==========
        if (widget.itemMasterModel != null && widget.itemMasterModel?.itemImage == selectedImageNotifier.value?.path) {
          itemImage = widget.itemMasterModel?.itemImage ?? '';
        } else {
          image = await selectedImageNotifier.value!.copy(filePath);
          itemImage = image!.path;
        }
      } else {
        itemImage = '';
      }

      final _itemMasterModel = ItemMasterModel(
        id: widget.itemMasterModel?.id,
        productType: productType,
        itemName: itemName,
        itemNameArabic: itemNameArabic,
        itemCode: itemCode,
        itemCategoryId: itemCategoryId,
        itemSubCategoryId: itemSubCategoryId,
        itemBrandId: itemBrandId,
        itemCost: itemCost,
        sellingPrice: sellingPrice,
        secondarySellingPrice: secondarySellingPrice,
        vatMethod: vatMethod,
        productVAT: productVAT,
        vatId: vatId,
        vatRate: vatRate,
        unit: unit,
        expiryDate: expiryDate,
        openingStock: openingStock,
        alertQuantity: alertQuantity,
        itemImage: itemImage,
      );
      try {
        if (!isUpdate) {
          await itemMasterDB.createItem(_itemMasterModel);
          log('Item $itemName Added!');
          kSnackBar(context: context, success: true, content: 'Product added successfully!');
        } else {
          final ItemMasterModel? _item = await itemMasterDB.updateProduct(_itemMasterModel);
          kSnackBar(context: context, update: true, content: "Product updated successfully!");
          return Navigator.pop(context, _item);
        }
      } catch (e) {
        if (e == 'Item name already exist') {
          log('Item name already exist');
          itemNameFocusNode.requestFocus();
          kSnackBar(
            context: context,
            error: true,
            content: e.toString(),
          );
        } else if (e == 'Item code already exist') {
          log('Item code already exist');
          itemCodeFocusNode.requestFocus();
          kSnackBar(
            context: context,
            error: true,
            content: e.toString(),
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

  //========== Fetch Product Details ==========
  void getProductDetails(ItemMasterModel product) async {
    //retieving values from Database to TextFields

    log('Product == ' + product.toString());

    productTypeNotifier.value = product.productType;
    _itemNameController.text = product.itemName;
    _itemNameArabicController.text = product.itemNameArabic;
    _itemCodeController.text = product.itemCode;

    _itemCategoryId = product.itemCategoryId;
    itemCategoryNotifier.value = _itemCategoryId!;

    _itemSubCategoryId = product.itemSubCategoryId;
    _itemBrandId = product.itemBrandId;
    _itemCostController.text = product.itemCost;
    _sellingPriceController.text = product.sellingPrice;
    _productVatController = product.productVAT;
    _itemVatId = product.vatId;
    _itemVatRate = product.vatRate;
    vatMethodNotifier.value = product.vatMethod;
    _itemUnit = product.unit;
    _selectedDate = product.expiryDate;
    _dateController.text = Converter.dateFormat.format(DateTime.parse(_selectedDate!));
    _openingStockController.text = product.openingStock;
    _alertQuantityController.text = product.alertQuantity ?? '';
    if (await File(product.itemImage!).exists()) {
      selectedImageNotifier.value = File(product.itemImage!);
    }
  }
}
