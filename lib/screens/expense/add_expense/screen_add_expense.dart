// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/core/utils/validators/validators.dart';
import 'package:shop_ez/core/utils/vat/vat.dart';
import 'package:shop_ez/db/db_functions/expense/expense_category_database.dart';
import 'package:shop_ez/db/db_functions/expense/expense_database.dart';
import 'package:shop_ez/db/db_functions/transactions/transactions_database.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';
import 'package:shop_ez/model/vat/vat_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../../core/utils/snackbar/snackbar.dart';

class ScreenAddExpense extends StatefulWidget {
  const ScreenAddExpense({Key? key}) : super(key: key);

  @override
  State<ScreenAddExpense> createState() => _ScreenAddExpenseState();
}

class _ScreenAddExpenseState extends State<ScreenAddExpense> {
  late Size _screenSize;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  //========== Lists ==========
  final List<String> vatMethodList = ['Exclusive', 'Inclusive'];

  //========== Databse Instances ==========
  final vatDB = VatDatabase.instance;
  final expenseDB = ExpenseDatabase.instance;
  final expenseCategoryDB = ExpenseCategoryDatabase.instance;
  final transactionDatabase = TransactionDatabase.instance;

  //========== Value Notifiers ==========
  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  final ValueNotifier<List<ExpenseCategoryModel>> expenseCategoriesNotifier = ValueNotifier([]);

  Color? textColor = Colors.black;
  dynamic selectedDocument;
  bool jpgOrNot = false;
  String documentName = 'Document';
  String? documentExtension;

  final _expenseTitleController = TextEditingController();
  final _amountController = TextEditingController();
  final _payByController = TextEditingController();
  final _noteController = TextEditingController();
  final _voucherNumberController = TextEditingController();
  final _dateController = TextEditingController();

  //========== Integers ==========
  int? _vatId, _vatRate;
  String? _vathMethod, _vatAmount;
  // final _dateController = TextEditingController();

  String _expenseCategoryController = '';
  String _selectedDate = '';

  Future<List<ExpenseCategoryModel>>? futureExpenceCategories;
  Future<List<VatModel>>? futureVat;

  @override
  void initState() {
    super.initState();
    expenseDB.getAllExpense();
    futureExpenceCategories = expenseCategoryDB.getAllExpenseCategories();
    futureVat = vatDB.getAllVats();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
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
        appBar: AppBarWidget(title: 'Expenses'),
        body: BackgroundContainerWidget(
          child: ItemScreenPaddingWidget(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //========== Expense Category ==========
                    FutureBuilder(
                      future: futureExpenceCategories,
                      builder: (context, dynamic snapshot) {
                        final snap = snapshot as AsyncSnapshot;
                        switch (snap.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          case ConnectionState.done:
                          default:
                            expenseCategoriesNotifier.value = snap.data;
                            return ValueListenableBuilder(
                                valueListenable: expenseCategoriesNotifier,
                                builder: (context, expenseCateogory, __) {
                                  return CustomDropDownField(
                                    dropdownKey: _dropdownKey,
                                    labelText: 'Choose Expense *',
                                    snapshot: expenseCategoriesNotifier.value,
                                    onChanged: (value) {
                                      final ExpenseCategoryModel expenseCategory = ExpenseCategoryModel.fromJson(jsonDecode(value));
                                      _expenseCategoryController = expenseCategory.expense.toString();
                                    },
                                    validator: (value) {
                                      if (value == null || _expenseCategoryController == 'null') {
                                        return 'This field is required*';
                                      }
                                      return null;
                                    },
                                  );
                                });
                        }
                      },
                    ),
                    kHeight10,

                    //========== Expense Title ==========
                    TextFeildWidget(
                      labelText: 'Expense Title *',
                      controller: _expenseTitleController,
                      validator: (value) => Validators.nullValidator(value),
                    ),
                    kHeight10,

                    //========== Amount ==========
                    TextFeildWidget(
                      labelText: 'Amount *',
                      controller: _amountController,
                      inputFormatters: Validators.digitsOnly,
                      textInputType: TextInputType.number,
                      validator: (value) => Validators.nullValidator(value),
                    ),
                    kHeight10,

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
                            return CustomDropDownField(
                              labelText: 'Expense VAT',
                              snapshot: snapshot.data,
                              contentPadding: const EdgeInsets.all(10),
                              onChanged: (value) async {
                                final _vat = VatModel.fromJson(jsonDecode(value!));
                                _vatId = _vat.id;
                                _vatRate = _vat.rate;

                                log('VAT id = $_vatId');
                              },
                              validator: (value) {
                                if (_vatId == null && _vathMethod != null) {
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
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text(
                          'VAT Method',
                          style: TextStyle(color: klabelColorGrey),
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
                        _vathMethod = value.toString();
                      },
                      validator: (value) {
                        if (_vathMethod == null && _vatId != null) {
                          return 'This field is required*';
                        }
                        return null;
                      },
                    ),

                    kHeight10,

                    //========== Date ==========
                    TextFeildWidget(
                      labelText: 'Date *',
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
                          log('back to time == ${DateTime.parse(_selectedDate)}');

                          final parseDate = Converter.dateFormat.format(_date);
                          _dateController.text = parseDate.toString();

                          setState(() {});
                        }
                      },
                      validator: (value) => Validators.nullValidator(value),
                    ),
                    kHeight10,

                    //========== Note ==========
                    TextFeildWidget(
                      labelText: 'Note',
                      controller: _noteController,
                      maxLines: 3,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_note,
                          color: klabelColorGrey,
                        ),
                      ),
                      inputBorder: const OutlineInputBorder(),
                    ),
                    kHeight10,

                    //========== Voucher Number ==========
                    TextFeildWidget(
                      labelText: 'Voucher Number',
                      controller: _voucherNumberController,
                    ),
                    kHeight10,
                    //========== Pay By ==========
                    TextFeildWidget(
                      labelText: 'Pay By *',
                      controller: _payByController,
                      validator: (value) => Validators.nullValidator(value),
                    ),

                    kHeight20,

                    //========== Item Image ==========
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        kHeight10,
                        SizedBox(
                          width: _screenSize.width / 2.2,
                          height: _screenSize.width / 2.4,
                          child: InkWell(
                            onTap: () {
                              if (selectedDocument != null) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    contentPadding: kPadding0,
                                    content: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  imagePopUp(context);
                                                },
                                                color: kWhite,
                                                child: const Text(
                                                  'Edit',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                )),
                                          ),
                                          Expanded(
                                            child: MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  selectedDocument = null;
                                                  documentName = 'Document';
                                                  setState(() {});
                                                },
                                                color: Colors.red[300],
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                imagePopUp(context);
                              }
                            },
                            child: selectedDocument != null && jpgOrNot
                                ? Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Image.file(
                                          File(selectedDocument!),
                                          width: _screenSize.width / 2.5,
                                          height: _screenSize.width / 2.5,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.edit,
                                          color: klabelColorGrey,
                                        ),
                                      )
                                    ],
                                  )
                                : Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: klabelColorGrey,
                                    size: _screenSize.width / 10,
                                  ),
                          ),
                        ),
                        kHeight10,
                        Text(
                          documentName,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: selectedDocument != null ? textColor : klabelColorGrey,
                          ),
                        ),
                      ],
                    ),
                    kHeight20,

                    //========== Submit Button ==========
                    CustomMaterialBtton(
                      buttonText: 'Submit',
                      onPressed: () async => await addExpense(),
                    ),
                    kHeight10,
                  ],
                ),
              ),
            ),
          ),
        ),
        // floatingActionButton: ExpenseFloatingAddOptions(isDialOpen: isDialOpen),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, routeAddExpenseCategory);
            _dropdownKey.currentState!.reset();
            expenseCategoriesNotifier.value = await expenseCategoryDB.getAllExpenseCategories();
            expenseCategoriesNotifier.notifyListeners();
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueGrey,
          tooltip: 'Add Expense Categories',
        ),
      ),
    );
  }

  Future<void> addExpense() async {
    final String? expenseCategory, expenseTitle, amount, date, note, voucherNumber, payBy, documents;

    //retieving values from TextFields to String
    expenseCategory = _expenseCategoryController.trim();
    expenseTitle = _expenseTitleController.text.trim();
    amount = _amountController.text.trim();
    date = _selectedDate.trim();
    note = _noteController.text.isEmpty ? null : _noteController.text.trim();
    voucherNumber = _voucherNumberController.text.isEmpty ? null : _voucherNumberController.text.trim();
    payBy = _payByController.text.trim();

    if (selectedDocument != null) {
      //========== Getting Directory Path ==========
      final Directory extDir = await getApplicationDocumentsDirectory();
      String dirPath = extDir.path;
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      // final fileName = basename(File(selectedDocument).path);
      log('FileName = $fileName');
      final String filePath = '$dirPath/$fileName$documentExtension';

      //========== Coping Image to new path ==========
      File image = await File(selectedDocument).copy(filePath);
      documents = image.path;
    } else {
      documents = null;
    }

    final _formState = _formKey.currentState!;

    if (_formState.validate()) {
      if (_vatId != null) {
        _vatAmount = VatCalculator.getVatAmount(vatMethod: _vathMethod!, amount: amount, vatRate: _vatRate!).toString();
        log('vat Amount == $_vatAmount');
      }

      final _expenseModel = ExpenseModel(
        expenseCategory: expenseCategory,
        expenseTitle: expenseTitle,
        amount: amount,
        vatId: _vatId,
        vatMethod: _vathMethod,
        vatAmount: _vatAmount,
        date: date,
        note: note,
        voucherNumber: voucherNumber,
        payBy: payBy,
        documents: documents,
      );

      final _transactionModel = TransactionsModel(
          category: 'Expense', transactionType: 'Expense', dateTime: date, amount: amount, status: 'Paid', description: note, payBy: payBy);

      try {
        await expenseDB.createExpense(_expenseModel);
        await transactionDatabase.createTransaction(_transactionModel);
        _formState.reset();
        expenseReset();
        kSnackBar(context: context, success: true, content: 'Expense "$expenseTitle" added!');
      } catch (e) {
        kSnackBar(
          context: context,
          error: true,
          content: 'Something went wrong, Please try again!',
        );
      }
    }
  }

  //========== Date Picker ==========
  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ),
      lastDate: DateTime.now(),
    );
  }

//========== Image PopUp ==========
  void imagePopUp(BuildContext context) async {
    return await showModalBottomSheet(
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
              leading: const Icon(Icons.folder),
              title: const Text('Files'),
              onTap: () {
                filePicker();
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

      selectedDocument = imageFile.path;
      documentName = '';
      documentExtension = '.jpg';
      jpgOrNot = true;
      log('selected Image = $selectedDocument');

      setState(() {});

      // blobImage = await selectedDocument.readAsBytes();
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }

  //========== File Picker ==========
  void filePicker() async {
    try {
      final _results = await FilePicker.platform.pickFiles();
      if (_results == null) return;

      final _file = _results.files.first;

      log('name = ${_file.name}');

      if (_file.extension == 'jpg' || _file.extension == 'JPG') {
        jpgOrNot = true;
        documentExtension = '.jpg';
      } else {
        jpgOrNot = false;
        documentExtension = '.${_file.extension}';
        textColor = Colors.blue;
      }

      selectedDocument = _file.path;
      documentName = _file.name;

      log('selected Document = $selectedDocument');

      setState(() {});

      // blobImage = await selectedDocument.readAsBytes();
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }

  expenseReset() {
    _expenseTitleController.clear();
    _amountController.clear();
    _payByController.clear();
    _noteController.clear();
    _voucherNumberController.clear();
    _dateController.clear();
    _expenseCategoryController = '';
    _selectedDate = '';
    selectedDocument = null;
    documentName = 'Document';
    setState(() {});
  }
}
