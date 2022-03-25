import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/expense_database/expense_database.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

const expenseList = ['Travel', 'Fuel', 'Food'];

class ManageExpenseScreen extends StatefulWidget {
  const ManageExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ManageExpenseScreen> createState() => _ManageExpenseScreenState();
}

class _ManageExpenseScreenState extends State<ManageExpenseScreen> {
  late Size _screenSize;

  final _formKey = GlobalKey<FormState>();

  final expenseDB = ExpenseDatabase.instance;

  Color? textColor = Colors.black;
  dynamic selectedDocument;
  bool jpgOrNot = false;
  String documentName = 'Document';
  String? documentExtension;

  final _expenseTitleController = TextEditingController();
  final _paidByController = TextEditingController();
  final _noteController = TextEditingController();
  final _voucherNumberController = TextEditingController();
  final _dateController = TextEditingController();

  String _expenseCategoryController = '';
  String _selectedDate = '';

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    expenseDB.getAllExpense();
    return Scaffold(
      appBar: AppBarWidget(title: 'Expense'),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //========== Expense Category ==========
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        label: Text(
                      'Expense Category *',
                      style: TextStyle(color: klabelColorBlack),
                    )),
                    items: expenseList
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      _expenseCategoryController = value.toString();
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || _expenseCategoryController.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Expense Title ==========
                  TextFeildWidget(
                    labelText: 'Expense Title *',
                    controller: _expenseTitleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                  kHeight10,

                  //========== Paid By ==========
                  TextFeildWidget(
                    labelText: 'Paid By *',
                    controller: _paidByController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
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
                      DateFormat formatter = DateFormat('dd-MM-yyyy');

                      if (_date != null) {
                        //Date to String for Database
                        _selectedDate = _date.toIso8601String();

                        log('selected date == $_selectedDate');
                        log('back to time == ${DateTime.parse(_selectedDate)}');

                        final parseDate = formatter.format(_date);
                        _dateController.text = parseDate.toString();

                        setState(() {});
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
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
                        color: kSuffixIconColorBlack,
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
                  kHeight20,

                  //========== Item Image ==========
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kHeight10,
                      InkWell(
                        onTap: () => imagePopUp(context),
                        child: selectedDocument != null && jpgOrNot
                            ? Image.file(
                                File(selectedDocument!),
                                width: _screenSize.width / 2.5,
                                height: _screenSize.width / 2.5,
                                fit: BoxFit.fill,
                              )
                            : Icon(
                                Icons.add_photo_alternate_outlined,
                                size: _screenSize.width / 10,
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
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  kHeight20,

                  //========== Submit Button ==========
                  CustomMaterialBtton(
                    buttonText: 'Submit',
                    onPressed: () => addExpense(),
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

  addExpense() async {
    final String expenseCategory,
        expenseTitle,
        paidBy,
        date,
        note,
        voucherNumber,
        documents;

    //retieving values from TextFields to String
    expenseCategory = _expenseCategoryController;
    expenseTitle = _expenseTitleController.text;
    paidBy = _paidByController.text;
    date = _selectedDate;
    note = _noteController.text;
    voucherNumber = _voucherNumberController.text;

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
      documents = '';
    }

    final _formState = _formKey.currentState!;

    if (_formState.validate()) {
      final _expenseModel = ExpenseModel(
        expenseCategory: expenseCategory,
        expenseTitle: expenseTitle,
        paidBy: paidBy,
        date: date,
        note: note,
        voucherNumber: voucherNumber,
        documents: documents,
      );

      try {
        await expenseDB.createExpense(_expenseModel);
        showSnackBar(
            context: context,
            color: kSnackBarSuccessColor,
            icon: const Icon(
              Icons.done,
              color: kSnackBarIconColor,
            ),
            content: 'Expense "$expenseTitle" added!');
      } catch (e) {
        showSnackBar(
          context: context,
          color: kSnackBarErrorColor,
          icon: const Icon(
            Icons.new_releases_outlined,
            color: kSnackBarIconColor,
          ),
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
