import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/icons.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/db/db_functions/expense/expense_category_database.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

import '../../../core/utils/snackbar/snackbar.dart';

class ScreenAddExpenseCategory extends StatefulWidget {
  const ScreenAddExpenseCategory({Key? key}) : super(key: key);

  @override
  State<ScreenAddExpenseCategory> createState() => _ScreenAddExpenseCategoryState();
}

class _ScreenAddExpenseCategoryState extends State<ScreenAddExpenseCategory> {
  //========== Text Editing Controllers ==========
  final _expenseEditingController = TextEditingController();

  //========== Global Keys ==========
  final _formKey = GlobalKey<FormState>();

  //========== Value Notifiers ==========
  final expenseCategoryNotifiers = ExpenseCategoryDatabase.expenseCategoryNotifier;

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
                  labelText: 'Expense Category *',
                  controller: _expenseEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),
              ),
              kHeight10,

              //========== Submit Button ==========
              CustomMaterialBtton(
                buttonText: 'Submit',
                onPressed: () async {
                  final _expenseCategory = _expenseEditingController.text.trim();
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Expense Category == ' + _expenseCategory);
                    final _expenseCategoryModel = ExpenseCategoryModel(expense: _expenseCategory);

                    try {
                      await expenseCategoryDB.createExpenseCategory(_expenseCategoryModel);
                      kSnackBar(context: context, success: true, content: 'Expense "$_expenseCategory" added successfully!');
                      _expenseEditingController.clear();
                      return setState(() {});
                    } catch (e) {
                      kSnackBar(context: context, error: true, content: 'Expense "$_expenseCategory" already exist!');
                    }
                  }
                },
              ),

              kHeight15,
              //========== Expense List Field ==========
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: expenseCategoryDB.getAllExpenseCategories(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                      default:
                        if (!snapshot.hasData) {
                          return const Center(child: Text('Expense Category is Empty!'));
                        }
                        if (snapshot.hasData) {
                          expenseCategoryNotifiers.value = snapshot.data;
                        }
                        return ValueListenableBuilder(
                            valueListenable: expenseCategoryNotifiers,
                            builder: (context, List<ExpenseCategoryModel> expenseCategories, _) {
                              return expenseCategories.isNotEmpty
                                  ? ListView.separated(
                                      itemBuilder: (context, index) {
                                        final expenseCategory = expenseCategories[index];
                                        log('item == $expenseCategory');
                                        return ListTile(
                                          dense: true,
                                          leading: CircleAvatar(
                                            backgroundColor: kTransparentColor,
                                            child: Text('${index + 1}'.toString(), style: kTextNo12),
                                          ),
                                          title: Text(expenseCategory.expense),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  final _expenseCateogryController = TextEditingController(text: expenseCategories[index].expense);

                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                              content: Column(mainAxisSize: MainAxisSize.min, children: [
                                                            TextFeildWidget(
                                                              labelText: 'Expense Category Name',
                                                              controller: _expenseCateogryController,
                                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                                              inputBorder: const OutlineInputBorder(),
                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                              isDense: true,
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'This field is required*';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                            kHeight5,
                                                            CustomMaterialBtton(
                                                                onPressed: () async {
                                                                  final String expenseCategoryName = _expenseCateogryController.text.trim();
                                                                  if (expenseCategoryName == expenseCategories[index].expense) {
                                                                    return Navigator.pop(context);
                                                                  }
                                                                  await expenseCategoryDB.updateExpenseCategory(
                                                                      expenseCategory: expenseCategories[index],
                                                                      expenseCategoryName: expenseCategoryName);
                                                                  Navigator.pop(context);

                                                                  kSnackBar(
                                                                    context: context,
                                                                    content: 'Expense Category updated successfully',
                                                                    update: true,
                                                                  );
                                                                },
                                                                buttonText: 'Update')
                                                          ])));
                                                },
                                                icon: kIconEdit,
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      content: const Text('Are you sure you want to delete this item?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: kTextCancel,
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await expenseCategoryDB.deleteExpenseCategory(expenseCategory.id!);
                                                            Navigator.pop(context);

                                                            kSnackBar(
                                                              context: context,
                                                              content: 'Expense Category deleted successfully',
                                                              delete: true,
                                                            );
                                                          },
                                                          child: kTextDelete,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                icon: kIconDelete,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) => const Divider(
                                        thickness: 1,
                                      ),
                                      itemCount: snapshot.data.length,
                                    )
                                  : const Center(child: Text('Expense Category is Empty!'));
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
