// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/date_time.dart';
import 'package:shop_ez/db/db_functions/expense/expense_database.dart';
import 'package:shop_ez/model/expense/expense_model.dart';
import 'package:shop_ez/screens/expense/manage_expense/widgets/expense_card.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenManageExpense extends StatelessWidget {
  ScreenManageExpense({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final expenseCategoryController = TextEditingController();
  final payByController = TextEditingController();
  final dateController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<int?> customerIdNotifier = ValueNotifier(null);
  final ValueNotifier<List<ExpenseModel>> expensesNotifer = ValueNotifier([]);

  //==================== List Customers ====================
  List<ExpenseModel> expensesList = [];
  List<ExpenseModel> filteredList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Manage Expense'),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //==================== Search & Filter ====================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Get All Expenses Search Field ==========
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
                                    filteredList.clear();
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
                        filteredList = expensesList.where((expense) => expense.payBy == selectedExpense.payBy).toList();
                        expensesNotifer.value = filteredList;
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
                            if (dateController.text.isNotEmpty && payByController.text.isNotEmpty && filteredList.isNotEmpty) {
                              expensesNotifer.value = filteredList;
                            } else if (dateController.text.isNotEmpty) {
                              if (expensesList.isNotEmpty) {
                                expensesNotifer.value = expensesList;
                              } else {
                                expensesNotifer.value = await futureExpenses();
                              }
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

                          final bool isFilter = filteredList.isNotEmpty;

                          for (ExpenseModel expense in isFilter ? filteredList : expensesList) {
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
                  )
                ],
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
                            return const Center(child: Text('No recent Expenses!'));
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
                                            onTap: () async {
                                              // showDialog(
                                              //     context: context,
                                              //     builder: (ctx) => CustomPopupOptions(
                                              //           options: [
                                              //             {
                                              //               'title': 'View Customer',
                                              //               'color': Colors.blueGrey[400],
                                              //               'icon': Icons.person_search_outlined,
                                              //               'action': () {
                                              //                 return showModalBottomSheet(
                                              //                     context: context,
                                              //                     isScrollControlled: true,
                                              //                     backgroundColor: kTransparentColor,
                                              //                     shape: const RoundedRectangleBorder(
                                              //                         borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                              //                     builder: (context) => DismissibleWidget(
                                              //                           context: context,
                                              //                           child: CustomBottomSheetWidget(model: customer[index]),
                                              //                         ));
                                              //               },
                                              //             },
                                              //             {
                                              //               'title': 'Edit Customer',
                                              //               'color': Colors.teal[400],
                                              //               'icon': Icons.personal_injury,
                                              //               'action': () async {
                                              //                 final editedCustomer = await Navigator.pushNamed(context, routeAddCustomer, arguments: {
                                              //                   'customer': customer[index],
                                              //                   'from': true,
                                              //                 });

                                              //                 if (editedCustomer != null && editedCustomer is ExpenseModel) {
                                              //                   final int stableIndex =
                                              //                       expensesList.indexWhere((customer) => customer.id == editedCustomer.id);
                                              //                   log('stable Index == $stableIndex');
                                              //                   expensesNotifer.value[index] = editedCustomer;
                                              //                   expensesList[stableIndex] = editedCustomer;
                                              //                   expensesNotifer.notifyListeners();
                                              //                 }
                                              //               }
                                              //             },
                                              //           ],
                                              //         ));
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent Expenses!'));
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
