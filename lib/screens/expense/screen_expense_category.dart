import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/expense/expense_category_database.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../core/utils/snackbar/snackbar.dart';

class ExpenseCategory extends StatefulWidget {
  const ExpenseCategory({Key? key}) : super(key: key);

  @override
  State<ExpenseCategory> createState() => _ExpenseCategoryState();
}

class _ExpenseCategoryState extends State<ExpenseCategory> {
  //========== Text Editing Controllers ==========
  final _expenseEditingController = TextEditingController();

  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Value Notifiers ==========
  final expenseCategoryNotifiers =
      ExpenseCategoryDatabase.expenseCategoryNotifiers;

  //========== Database Instances ==========
  final expenseCategoryDB = ExpenseCategoryDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Expense Category',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Expense Field ==========
              Form(
                key: _formKey,
                child: TextFeildWidget(
                  labelText: 'Expense *',
                  controller: _expenseEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),
              ),
              kHeight20,

              //========== Submit Button ==========
              CustomMaterialBtton(
                buttonText: 'Submit',
                onPressed: () async {
                  final _expenseCategory = _expenseEditingController.text
                      .trim()
                      .replaceAll("'", "''");
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Expense Category == ' + _expenseCategory);
                    final _expenseCategoryModel =
                        ExpenseCategoryModel(expense: _expenseCategory);

                    try {
                      await expenseCategoryDB
                          .createExpenseCategory(_expenseCategoryModel);
                      kSnackBar(
                          context: context,
                          success: true,
                          content:
                              'Expense "$_expenseCategory" added successfully!');
                      _expenseEditingController.clear();
                      return setState(() {});
                    } catch (e) {
                      kSnackBar(
                          context: context,
                          error: true,
                          content:
                              'Expense "$_expenseCategory" already exist!');
                    }
                  }
                },
              ),

              //========== Expense List Field ==========
              kHeight50,
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: expenseCategoryDB.getAllExpenseCategories(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                      default:
                        if (snapshot.hasData) {
                          expenseCategoryNotifiers.value = snapshot.data;
                        }
                        return ValueListenableBuilder(
                            valueListenable: expenseCategoryNotifiers,
                            builder: (context,
                                List<ExpenseCategoryModel> expenseCategories,
                                _) {
                              return ListView.separated(
                                itemBuilder: (context, index) {
                                  final expenseCategory =
                                      expenseCategories[index];
                                  log('item == $expenseCategory');
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: kTransparentColor,
                                      child: Text(
                                        '${index + 1}'.toString(),
                                        style: const TextStyle(
                                            color: kTextColorBlack),
                                      ),
                                    ),
                                    title: Text(expenseCategory.expense),
                                    trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            content: const Text(
                                                'Are you sure you want to delete this item?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await expenseCategoryDB
                                                      .deleteExpenseCategory(
                                                          expenseCategory.id!);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  thickness: 1,
                                ),
                                itemCount: snapshot.data.length,
                              );
                            });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
