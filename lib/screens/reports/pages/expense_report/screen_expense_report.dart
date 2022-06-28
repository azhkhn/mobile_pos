// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:convert';
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
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenExpenseReport extends StatelessWidget {
  ScreenExpenseReport({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final expenseCategoryController = TextEditingController();
  final payByController = TextEditingController();
  final dateController = TextEditingController();

  //==================== Global Keys ====================
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  //==================== Value Notifiers ====================
  final ValueNotifier<int?> customerIdNotifier = ValueNotifier(null);
  final ValueNotifier<List<ExpenseModel>> expensesNotifer = ValueNotifier([]);

  //==================== List Customers ====================
  List<ExpenseModel> expensesList = [];
  List<ExpenseModel> expensesByPayBy = [];
  List<ExpenseModel> expensesByDate = [];
  List<ExpenseModel> expensesByCategoryList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Expense Report'),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //==================== Search & Filter ====================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Expense Category ==========
                  Flexible(
                    flex: 1,
                    child: FutureBuilder(
                      future: ExpenseCategoryDatabase.instance.getAllExpenseCategories(),
                      builder: (context, dynamic snapshot) {
                        final snap = snapshot as AsyncSnapshot;
                        switch (snap.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          case ConnectionState.done:
                          default:
                            return CustomDropDownField(
                              isDesne: true,
                              border: true,
                              style: kText12Black,
                              hintStyle: kText12,
                              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              dropdownKey: _dropdownKey,
                              hintText: 'Choose Expense *',
                              snapshot: snap.data,
                              onChanged: (value) {
                                final ExpenseCategoryModel _expense = ExpenseCategoryModel.fromJson(jsonDecode(value));
                                expenseCategoryController.text = _expense.expense.toString();

                                log('Selected Expense Category == ' + _expense.expense);

                                if (dateController.text.isNotEmpty) {
                                  expensesNotifer.value = expensesByDate.where((expense) => expense.expenseCategory == _expense.expense).toList();
                                } else if (expensesByPayBy.isNotEmpty) {
                                  expensesNotifer.value = expensesByPayBy.where((expense) => expense.expenseCategory == _expense.expense).toList();
                                } else {
                                  expensesNotifer.value = expensesList.where((expense) => expense.expenseCategory == _expense.expense).toList();
                                }

                                expensesNotifer.notifyListeners();
                              },
                            );
                        }
                      },
                    ),
                  ),

                  kWidth5,

                  //==================== Date Search Field ====================
                  Flexible(
                    flex: 1,
                    child: TextFeildWidget(
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
                            if (dateController.text.isNotEmpty && payByController.text.isNotEmpty && expensesByPayBy.isNotEmpty) {
                              expensesNotifer.value = expensesByPayBy;
                            } else if (dateController.text.isNotEmpty) {
                              if (expensesList.isNotEmpty) {
                                expensesNotifer.value = expensesList;
                              } else {
                                expensesNotifer.value = await futureExpenses();
                              }
                              payByController.clear();
                            }

                            dateController.clear();
                            expensesByDate.clear();
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

                          final bool isPayBy = expensesByPayBy.isNotEmpty;
                          final bool isDateBy = expensesByDate.isNotEmpty;

                          for (ExpenseModel expense in isPayBy
                              ? expensesByPayBy
                              : isDateBy
                                  ? expensesByDate
                                  : expensesList) {
                            final DateTime _expenseDate = DateTime.parse(expense.date);

                            final bool isSameDate = Converter.isSameDate(_selectedDate, _expenseDate);

                            if (isSameDate) {
                              _expenseByDate.add(expense);
                            }
                          }
                          expensesByDate = _expenseByDate;
                          expensesNotifer.value = _expenseByDate;
                          expensesNotifer.notifyListeners();
                        }
                      },
                    ),
                  )
                ],
              ),

              kHeight5,

              //========== Get All Expenses Search Field ==========
              TypeAheadField(
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
                              expensesByPayBy.clear();
                              dateController.clear();

                              if (expensesList.isNotEmpty) {
                                expensesNotifer.value = expensesList;
                              } else {
                                expensesNotifer.value = await futureExpenses();
                              }
                            }
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
                  expenseCategoryController.clear();
                  payByController.text = selectedExpense.payBy;
                  log('Selected Expense Title = ' + selectedExpense.expenseTitle);

                  //Notify Expense List
                  expensesByPayBy = expensesList.where((expense) => expense.payBy == selectedExpense.payBy).toList();
                  expensesNotifer.value = expensesByPayBy;
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
                            return const Center(child: Text('No recent expenses!'));
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
                                    : const Center(child: Text('No expenses found!'));
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
