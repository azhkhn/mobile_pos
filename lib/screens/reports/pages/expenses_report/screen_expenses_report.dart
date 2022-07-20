// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/date_time.dart';
import 'package:shop_ez/db/db_functions/expense/expense_category_database.dart';
import 'package:shop_ez/db/db_functions/expense/expense_database.dart';
import 'package:shop_ez/model/expense/expense_category_model.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/screens/expense/manage_expense/widgets/expense_card.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenExpensesReport extends StatelessWidget {
  ScreenExpensesReport({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final expenseCategoryController = TextEditingController();
  final payByController = TextEditingController();
  final dateController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<List<ExpenseModel>> expensesNotifer = ValueNotifier([]);

  //==================== List Customers ====================
  List<ExpenseModel> expensesList = [];
  List<ExpenseModel> expensesByPayByList = [];
  List<ExpenseModel> expensesByCategoryList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Expenses Report'),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //==================== Search & Filter ====================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Expense Category Field ==========
                  Flexible(
                    flex: 1,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: expenseCategoryController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            suffixIcon: Padding(
                              padding: kClearTextIconPadding,
                              child: InkWell(
                                child: const Icon(Icons.clear, size: 15),
                                onTap: () async {
                                  if (expenseCategoryController.text.isNotEmpty) {
                                    dateController.clear();

                                    if (expensesByPayByList.isNotEmpty) {
                                      expensesNotifer.value = expensesByPayByList;
                                    } else {
                                      expensesNotifer.value = expensesList;
                                    }
                                  }
                                  expensesByCategoryList.clear();
                                  expenseCategoryController.clear();
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Expense Category',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Expense Found!'))),
                      suggestionsCallback: (pattern) async {
                        return ExpenseCategoryDatabase.instance.getExpenseCategoriesSuggestions(pattern);
                      },
                      itemBuilder: (context, ExpenseCategoryModel suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.expense,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kText_10_12,
                          ),
                        );
                      },
                      onSuggestionSelected: (ExpenseCategoryModel selectedExpense) {
                        dateController.clear();
                        payByController.clear();
                        expensesByPayByList.clear();
                        expenseCategoryController.text = selectedExpense.expense;
                        log('Selected Expense Category = ' + selectedExpense.expense);

                        //Notify Expense List
                        expensesByCategoryList = expensesList.where((expense) => expense.expenseCategory == selectedExpense.expense).toList();
                        expensesNotifer.value = expensesByCategoryList;
                      },
                    ),
                  ),

                  kWidth5,

                  //==================== Get All Pay By Search Field ====================
                  Flexible(
                    flex: 1,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: payByController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            suffixIcon: Padding(
                              padding: kClearTextIconPadding,
                              child: InkWell(
                                child: const Icon(Icons.clear, size: 15),
                                onTap: () async {
                                  if (payByController.text.isNotEmpty) {
                                    dateController.clear();

                                    if (expensesByCategoryList.isNotEmpty) {
                                      expensesNotifer.value = expensesByCategoryList;
                                    } else {
                                      expensesNotifer.value = expensesList;
                                    }
                                  }
                                  expensesByPayByList.clear();
                                  payByController.clear();
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Pay By',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Expense Found!'))),
                      suggestionsCallback: (pattern) async {
                        return ExpenseDatabase.instance.getPayBySuggestions(pattern);
                      },
                      itemBuilder: (context, ExpenseModel suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.payBy,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kText_10_12,
                          ),
                        );
                      },
                      onSuggestionSelected: (ExpenseModel selectedExpense) {
                        dateController.clear();

                        payByController.text = selectedExpense.payBy;
                        log('Selected Expense Title = ' + selectedExpense.expenseTitle);

                        final List<ExpenseModel> filterList = expensesByCategoryList.isNotEmpty ? expensesByCategoryList : expensesList;

                        //Notify Expense List
                        expensesByPayByList = filterList.where((expense) => expense.payBy == selectedExpense.payBy).toList();
                        expensesNotifer.value = expensesByPayByList;
                      },
                    ),
                  )
                ],
              ),

              kHeight5,

              //==================== Date Search Field ====================
              TextFeildWidget(
                hintText: 'Date ',
                controller: dateController,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                suffixIcon: Padding(
                  padding: kClearTextIconPadding,
                  child: InkWell(
                    child: const Icon(Icons.clear, size: 15),
                    onTap: () async {
                      if (dateController.text.isNotEmpty && expensesByCategoryList.isNotEmpty) {
                        expensesNotifer.value = expensesByCategoryList;
                        payByController.clear();
                        expensesByPayByList.clear();
                      } else if (dateController.text.isNotEmpty && expensesByPayByList.isNotEmpty) {
                        expensesNotifer.value = expensesByPayByList;
                        expenseCategoryController.clear();
                      } else if (dateController.text.isNotEmpty) {
                        expensesNotifer.value = expensesList;
                        expenseCategoryController.clear();
                        payByController.clear();
                      }

                      dateController.clear();
                    },
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
                hintStyle: kText12,
                readOnly: true,
                isDense: true,
                textStyle: kText12,
                inputBorder: const OutlineInputBorder(),
                onTap: () async {
                  final _selectedDate = await DateTimeUtils.instance.datePicker(context);

                  if (_selectedDate != null) {
                    final parseDate = Converter.dateFormat.format(_selectedDate);
                    dateController.text = parseDate.toString();

                    final List<ExpenseModel> _expenseByDate = [];

                    final bool isCatBy = expensesByCategoryList.isNotEmpty;
                    final bool isPayBy = expensesByPayByList.isNotEmpty;

                    for (ExpenseModel expense in isCatBy
                        ? expensesByCategoryList
                        : isPayBy
                            ? expensesByPayByList
                            : expensesList) {
                      final DateTime _expenseDate = DateTime.parse(expense.date);

                      final bool isSameDate = Converter.isSameDate(_selectedDate, _expenseDate);

                      if (isSameDate) {
                        _expenseByDate.add(expense);
                      }
                    }
                    expensesNotifer.value = _expenseByDate;
                    expensesNotifer.notifyListeners();
                  }
                },
              ),

              kHeight10,

              //========== List Expenses ==========
              Expanded(
                child: FutureBuilder(
                    future: futureExpenses(),
                    builder: (context, AsyncSnapshot<List<ExpenseModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No recent expenses'));
                          }
                          expensesNotifer.value = snapshot.data!;

                          if (expensesList.isEmpty) {
                            expensesList = snapshot.data!;
                          }
                          return ValueListenableBuilder(
                              valueListenable: expensesNotifer,
                              builder: (context, List<ExpenseModel> expenses, _) {
                                return expenses.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: expenses.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: ExpenseCard(
                                              index: index,
                                              expense: expenses[index],
                                            ),
                                            onTap: () async {},
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent expenses'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }

//== == == == == FutureBuilder Expense == == == == ==
  Future<List<ExpenseModel>> futureExpenses() async {
    log('FutureBuiler ()=> called!');
    if (expensesList.isEmpty) {
      log('Fetching expenses from the Database..');
      expensesList = await ExpenseDatabase.instance.getAllExpense();
      return expensesList = expensesList.reversed.toList();
    } else {
      log('Fetching expenses from the List..');
      return expensesList = expensesList.reversed.toList();
    }
  }
}
