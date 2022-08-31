// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/snackbar/snackbar.dart';
import 'package:mobile_pos/core/utils/validators/validators.dart';
import 'package:mobile_pos/db/db_functions/brand/brand_database.dart';
import 'package:mobile_pos/db/db_functions/category/category_db.dart';
import 'package:mobile_pos/db/db_functions/item_master/item_master_database.dart';
import 'package:mobile_pos/db/db_functions/sub_category/sub_category_db.dart';
import 'package:mobile_pos/db/db_functions/unit/unit_database.dart';
import 'package:mobile_pos/db/db_functions/vat/vat_database.dart';
import 'package:mobile_pos/model/brand/brand_model.dart';
import 'package:mobile_pos/model/category/category_model.dart';
import 'package:mobile_pos/model/item_master/item_master_model.dart';
import 'package:mobile_pos/model/sub-category/sub_category_model.dart';
import 'package:mobile_pos/model/unit/unit_model.dart';
import 'package:mobile_pos/model/vat/vat_model.dart';
import 'package:mobile_pos/screens/item_master/widgets/floating_add_options_item_master.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:mobile_pos/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';

//==== ==== ==== ==== ==== Providers ==== ==== ==== ==== ====
final _selectedImageProvider = StateProvider.autoDispose<File?>((ref) => null);
final _productTypeProvider = StateProvider.autoDispose<String?>((ref) => null);
final _vatMethodProvider = StateProvider.autoDispose<String?>((ref) => null);
final _isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

class ScreenAddProduct extends ConsumerWidget {
  ScreenAddProduct({Key? key, this.from = false, this.itemMasterModel}) : super(key: key);

  //========== Bool ==========
  final bool from;

  //========== Model Calsses ==========
  final ItemMasterModel? itemMasterModel;

  //========== Value Notifiers ==========
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  //========== Providers ==========
  static final itemCategoryIdProvider = StateProvider.autoDispose<int>((ref) => 0);
  static final futureCategoriesProvider =
      FutureProvider.autoDispose<List<CategoryModel>>((ref) async => await CategoryDatabase.instance.getAllCategories());
  static final futureSubCategoriesByCategoryIdProvider = FutureProvider.autoDispose.family<List<SubCategoryModel>, int>(
      (ref, int _categoryId) async => SubCategoryDatabase.instance.getSubCategoryByCategoryId(categoryId: _categoryId));
  static final futureBrandsProvider = FutureProvider.autoDispose<List<BrandModel>>((ref) async => await BrandDatabase.instance.getAllBrands());
  static final futureVatsProvider = FutureProvider.autoDispose<List<VatModel>>((ref) async => await VatDatabase.instance.getAllVats());
  static final futureUnitsProvider = FutureProvider.autoDispose<List<UnitModel>>((ref) async => await UnitDatabase.instance.getAllUnits());

  //========== Global Keys ==========
  final GlobalKey<FormFieldState> _subCategoryDropdownKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  //========== Focus Node for TextFields ==========
  FocusNode itemNameFocusNode = FocusNode();
  FocusNode itemNameArabicFocusNode = FocusNode();
  FocusNode itemCodeFocusNode = FocusNode();
  FocusNode itemCostFocusNode = FocusNode();
  FocusNode sellingPriceFocusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bool _isLoaded = ref.watch(_isLoadedProvider);
      if (itemMasterModel != null && !_isLoaded) await getProductDetails(itemMasterModel!, ref);
    });
    final Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: itemMasterModel == null ? 'Add Product' : 'Edit Product',
        ),
        body: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //========== Product Type Dropdown ==========
                  Consumer(
                    builder: (context, productType, _) {
                      final String? _productType = ref.watch(_productTypeProvider);
                      return DropdownButtonFormField(
                        decoration: const InputDecoration(
                          label: Text(
                            'Product Type *',
                            style: TextStyle(color: klabelColorGrey),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        isExpanded: true,
                        value: _productType,
                        items: productTypeList.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          ref.read(_productTypeProvider.notifier).state = value.toString();
                        },
                        validator: (value) {
                          if (value == null || _productType == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      );
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
                  Consumer(
                    builder: (context, ref, _) {
                      final futureCategory = ref.watch(futureCategoriesProvider);
                      return futureCategory.when(
                        data: (value) {
                          final List<CategoryModel> _categories = value;
                          if (!_categories.any((category) => category.id == _itemCategoryId)) _itemCategoryId = null;

                          return CustomDropDownField(
                            labelText: 'Item Category *',
                            snapshot: _categories,
                            value: _itemCategoryId != null ? jsonEncode(_categories.where((cat) => cat.id == _itemCategoryId).toList().first) : null,
                            contentPadding: const EdgeInsets.all(10),
                            onChanged: (value) {
                              _subCategoryDropdownKey.currentState?.reset();
                              final CategoryModel category = CategoryModel.fromJson(jsonDecode(value!));
                              log('Category Id == ' + category.id.toString());
                              log('Category == ' + category.category);
                              _itemCategoryId = category.id;
                              ref.read(itemCategoryIdProvider.notifier).state = category.id!;
                            },
                            validator: (value) {
                              if (value == null || _itemCategoryId == null) {
                                return 'This field is required*';
                              }
                              return null;
                            },
                          );
                        },
                        error: (_, __) => const Text('Something went wrong!'),
                        loading: () => const SingleChildScrollView(),
                      );
                    },
                  ),
                  kHeight10,

                  //========== Item Sub-Category Dropdown ==========
                  Consumer(
                    builder: (context, ref, _) {
                      final int _categoryId = ref.watch(itemCategoryIdProvider);
                      final _futureSubCategories = ref.watch(futureSubCategoriesByCategoryIdProvider(_categoryId));

                      return _futureSubCategories.when(
                        data: (value) {
                          final List<SubCategoryModel> _subCategories = value;
                          final List<SubCategoryModel> subCat = _subCategories.where((subCat) => subCat.id == _itemSubCategoryId).toList();
                          if (!_subCategories.any((subCategory) => subCategory.id == _itemSubCategoryId)) _itemSubCategoryId = null;
                          return CustomDropDownField(
                            dropdownKey: _subCategoryDropdownKey,
                            labelText: 'Item Sub-Category',
                            snapshot: _subCategories,
                            value: _itemSubCategoryId != null && subCat.isNotEmpty ? jsonEncode(subCat.first) : null,
                            contentPadding: const EdgeInsets.all(10),
                            onChanged: (value) {
                              final SubCategoryModel subCategory = SubCategoryModel.fromJson(jsonDecode(value!));
                              log('Sub Category Id == ' + subCategory.id.toString());
                              log('Sub Category == ' + subCategory.subCategory);
                              _itemSubCategoryId = subCategory.id;
                            },
                          );
                        },
                        error: (_, __) => const Text('Something went wrong!'),
                        loading: () => const SingleChildScrollView(),
                      );
                    },
                  ),
                  kHeight10,

                  //========== Item Brand Dropdown ==========
                  Consumer(
                    builder: (context, ref, _) {
                      final _futureBrands = ref.watch(futureBrandsProvider);

                      return _futureBrands.when(
                        data: (value) {
                          final List<BrandModel> _brands = value;
                          if (!_brands.any((_brand) => _brand.id == _itemBrandId)) _itemBrandId = null;

                          return CustomDropDownField(
                            labelText: 'Item Brand',
                            snapshot: _brands,
                            value: _itemBrandId != null ? jsonEncode(_brands.where((brand) => brand.id == _itemBrandId).toList().first) : null,
                            contentPadding: const EdgeInsets.all(10),
                            onChanged: (value) {
                              final BrandModel brand = BrandModel.fromJson(jsonDecode(value!));
                              log('Brand Is == ' + brand.id.toString());
                              log('Brand == ' + brand.brand);
                              _itemBrandId = brand.id;
                            },
                          );
                        },
                        error: (_, __) => const Text('Something went wrong!'),
                        loading: () => const SingleChildScrollView(),
                      );
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

                  Consumer(
                    builder: (context, ref, _) {
                      final _futureVats = ref.watch(futureVatsProvider);

                      return _futureVats.when(
                        data: (value) {
                          final List<VatModel> _vats = value;
                          if (!_vats.any((_vat) => _vat.id == _itemVatId)) _itemVatId = null;

                          return CustomDropDownField(
                            labelText: 'Product VAT *',
                            snapshot: _vats,
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
                        },
                        error: (_, __) => const Text('Something went wrong!'),
                        loading: () => const SingleChildScrollView(),
                      );
                    },
                  ),
                  kHeight10,

                  //========== VAT Method Dropdown ==========
                  Consumer(
                    builder: (context, ref, _) {
                      final String? _vatMethod = ref.watch(_vatMethodProvider);
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
                          ref.read(_vatMethodProvider.notifier).state = value.toString();
                        },
                        validator: (value) {
                          if (value == null || ref.read(_vatMethodProvider) == null) {
                            return 'This field is required*';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  kHeight10,

                  //========== Unit Dropdown ==========

                  Consumer(
                    builder: (context, ref, _) {
                      final _futureUnits = ref.watch(futureUnitsProvider);

                      return _futureUnits.when(
                        data: (value) {
                          final List<UnitModel> _units = value;
                          if (!_units.any((_unit) => Converter.modelToJsonString(_unit) == _itemUnit)) _itemUnit = null;

                          return CustomDropDownField(
                            labelText: 'Unit *',
                            snapshot: _units,
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
                        },
                        error: (_, __) => const Text('Something went wrong!'),
                        loading: () => const SingleChildScrollView(),
                      );
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
                      Consumer(builder: (context, ref, _) {
                        File? selectedImage = ref.watch(_selectedImageProvider);
                        return InkWell(
                          onTap: () => imagePopUp(context, ref),
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
                    buttonText: itemMasterModel == null ? 'Add Product' : 'Update Product',
                    onPressed: () async {
                      if (itemMasterModel == null) {
                        return await addItem(context, ref);
                      } else {
                        return await addItem(context, ref, isUpdate: true);
                      }
                    },
                  ),
                  kHeight10,
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingAddOptionsAddProduct(isDialOpen: isDialOpen),
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
  void imagePopUp(BuildContext context, WidgetRef ref) async {
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
                imagePicker(ImageSource.camera, ref);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Gallery'),
              onTap: () {
                imagePicker(ImageSource.gallery, ref);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

//========== Image Picker ==========
  void imagePicker(ImageSource imageSource, WidgetRef ref) async {
    final imagePicker = ImagePicker();
    try {
      final imageFile = await imagePicker.pickImage(source: imageSource);
      if (imageFile == null) return;

      final selectedImage = ref.read(_selectedImageProvider.notifier);

      selectedImage.state = File(imageFile.path);
      log('selected Image = ${selectedImage.state}');

      // blobImage = await selectedImage.readAsBytes();
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }

  //========== Add Item ==========
  Future<void> addItem(BuildContext context, WidgetRef ref, {final bool isUpdate = false}) async {
    final int itemCategoryId, vatRate, vatId;
    final int? itemSubCategoryId, itemBrandId;
    final String? expiryDate;
    final String productType,
        itemName,
        itemNameArabic,
        itemCode,
        itemCost,
        sellingPrice,
        secondarySellingPrice,
        productVAT,
        openingStock,
        vatMethod,
        unit,
        alertQuantity,
        itemImage;

    final File? selectedImage = ref.read(_selectedImageProvider);

    //========== Validating Text Form Fields ==========
    final FormState _formState = _formKey.currentState!;

    if (_formState.validate()) {
      //Retieving values from TextFields to String
      productType = ref.read(_productTypeProvider)!;
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
      vatMethod = ref.read(_vatMethodProvider)!;
      alertQuantity = _alertQuantityController.text.trim();

      if (selectedImage != null) {
        //========== Getting Directory Path ==========
        final Directory extDir = await getApplicationDocumentsDirectory();
        final String dirPath = extDir.path;
        final fileName = DateTime.now().microsecondsSinceEpoch.toString();
        // final fileName = basename(selectedImage!.path);
        final String filePath = '$dirPath/$fileName.jpg';

        //========== Coping Image to new path ==========
        if (itemMasterModel != null && itemMasterModel?.itemImage == selectedImage.path) {
          itemImage = itemMasterModel?.itemImage ?? '';
        } else {
          image = await selectedImage.copy(filePath);
          itemImage = image!.path;
        }
      } else {
        itemImage = '';
      }

      final _itemMasterModel = ItemMasterModel(
        id: itemMasterModel?.id,
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
          //Reset Item Master fields..
          resetItemMaster(ref);
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
  Future<void> getProductDetails(ItemMasterModel product, WidgetRef ref) async {
    //retieving values from Database to TextFields

    log('Product == ' + product.toString());

    ref.read(_productTypeProvider.notifier).state = product.productType;
    _itemNameController.text = product.itemName;
    _itemNameArabicController.text = product.itemNameArabic;
    _itemCodeController.text = product.itemCode;

    _itemCategoryId = product.itemCategoryId;
    ref.read(itemCategoryIdProvider.notifier).state = _itemCategoryId!;

    _itemSubCategoryId = product.itemSubCategoryId;
    _itemBrandId = product.itemBrandId;
    _itemCostController.text = product.itemCost;
    _sellingPriceController.text = product.sellingPrice;
    _productVatController = product.productVAT;
    _itemVatId = product.vatId;
    _itemVatRate = product.vatRate;
    ref.read(_vatMethodProvider.notifier).state = product.vatMethod;
    _itemUnit = product.unit;
    _selectedDate = product.expiryDate;
    _dateController.text = Converter.dateFormat.format(DateTime.parse(_selectedDate!));
    _openingStockController.text = product.openingStock;
    _alertQuantityController.text = product.alertQuantity ?? '';
    if (await File(product.itemImage!).exists()) {
      ref.read(_selectedImageProvider.notifier).state = File(product.itemImage!);
    }

    ref.read(_isLoadedProvider.notifier).state = true;
  }

//=== === === === === Reset Item Master === === === === ===
  void resetItemMaster(WidgetRef ref) {
    _itemCategoryId = null;
    _itemSubCategoryId = null;
    _itemBrandId = null;
    _itemVatId = null;
    _itemVatRate = null;
    _productVatController = null;
    _itemUnit = null;
    _selectedDate = null;

    ref.refresh(_productTypeProvider);
    ref.refresh(itemCategoryIdProvider);
    ref.refresh(_selectedImageProvider);
    ref.refresh(_vatMethodProvider);
    ref.refresh(futureCategoriesProvider);
    ref.refresh(futureSubCategoriesByCategoryIdProvider(0));
    ref.refresh(futureBrandsProvider);
    ref.refresh(futureVatsProvider);
    ref.refresh(futureUnitsProvider);

    _itemNameController.clear();
    _itemNameArabicController.clear();
    _itemCodeController.clear();
    _itemCostController.clear();
    _sellingPriceController.clear();
    _dateController.clear();
    _openingStockController.clear();
    _alertQuantityController.clear();
  }
}
