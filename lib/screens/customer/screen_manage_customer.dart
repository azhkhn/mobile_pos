// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/core/utils/snackbar/snackbar.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/screens/customer/widgets/customer_card_widget.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/widgets/alertdialog/custom_popup_options.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class CustomerManageScreen extends StatelessWidget {
  CustomerManageScreen({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final customerController = TextEditingController();

  //==================== Value Notifiers ====================
  final ValueNotifier<int?> customerIdNotifier = ValueNotifier(null);
  final ValueNotifier<List<CustomerModel>> customerNotifer = ValueNotifier([]);

  //==================== List Customers ====================
  List<CustomerModel> customersList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Customer Manage'),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //==================== Search & Filter ====================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //========== Get All Customers Search Field ==========
                  Flexible(
                    flex: 8,
                    child: TypeAheadField(
                      minCharsForSuggestions: 0,
                      debounceDuration: const Duration(milliseconds: 500),
                      hideSuggestionsOnKeyboardHide: true,
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: customerController,
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
                                  customerIdNotifier.value = null;
                                  customerController.clear();

                                  if (customersList.isNotEmpty) {
                                    customerNotifer.value = customersList;
                                  } else {
                                    customerNotifer.value = await CustomerDatabase.instance.getAllCustomers();
                                  }
                                },
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Customer',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: const OutlineInputBorder(),
                          )),
                      noItemsFoundBuilder: (context) => const SizedBox(height: 50, child: Center(child: Text('No Customer Found!'))),
                      suggestionsCallback: (pattern) async {
                        return CustomerDatabase.instance.getCustomerSuggestions(pattern);
                      },
                      itemBuilder: (context, CustomerModel suggestion) {
                        return ListTile(
                          title: Text(
                            suggestion.customer,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kText_10_12,
                          ),
                        );
                      },
                      onSuggestionSelected: (CustomerModel suggestion) {
                        customerNotifer.value = [suggestion];
                        customerController.text = suggestion.customer;
                        customerIdNotifier.value = suggestion.id;
                        log(suggestion.company);
                      },
                    ),
                  ),
                  kWidth5,

                  //========== View Customer Button ==========
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      child: IconButton(
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(
                            minHeight: 30,
                            maxHeight: 30,
                          ),
                          onPressed: () {
                            if (customerIdNotifier.value != null) {
                              log(' Customer Id == ${customerIdNotifier.value}');

                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: kTransparentColor,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                  builder: (context) => DismissibleWidget(
                                        context: context,
                                        child: CustomBottomSheetWidget(model: customerNotifer.value.first),
                                      ));
                            } else {
                              kSnackBar(context: context, content: 'Please select any Customer to show details!');
                            }
                          },
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.blue,
                            size: 25,
                          )),
                    ),
                  ),

                  //========== Add Customer Button ==========
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      child: IconButton(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          maxHeight: 30,
                        ),
                        onPressed: () async {
                          final CustomerModel? addedCustomer =
                              await Navigator.pushNamed(context, routeAddCustomer, arguments: {'from': true}) as CustomerModel;

                          if (addedCustomer != null) {
                            customerNotifer.value.add(addedCustomer);
                            customerNotifer.notifyListeners();
                            // customersList.add(addedCustomer);
                            customerController.text = addedCustomer.customer;
                            customerIdNotifier.value = addedCustomer.id;
                          }
                        },
                        icon: const Icon(
                          Icons.person_add,
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              kHeight10,

              //========== List Customers ==========
              Expanded(
                child: FutureBuilder(
                    future: CustomerDatabase.instance.getAllCustomers(),
                    builder: (context, AsyncSnapshot<List<CustomerModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Customers is Empty!'));
                          }
                          customerNotifer.value = snapshot.data!;

                          if (customersList.isEmpty) {
                            customersList = snapshot.data!;
                          }
                          return ValueListenableBuilder(
                              valueListenable: customerNotifer,
                              builder: (context, List<CustomerModel> customer, _) {
                                return customer.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: customer.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: CustomerCardWidget(
                                              index: index,
                                              customer: customer,
                                            ),
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) => CustomPopupOptions(
                                                        options: [
                                                          {
                                                            'title': 'View Customer',
                                                            'color': Colors.blueGrey[400],
                                                            'icon': Icons.person_search_outlined,
                                                            'action': () {
                                                              return showModalBottomSheet(
                                                                  context: context,
                                                                  isScrollControlled: true,
                                                                  backgroundColor: kTransparentColor,
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                                                  builder: (context) => DismissibleWidget(
                                                                        context: context,
                                                                        child: CustomBottomSheetWidget(model: customer[index]),
                                                                      ));
                                                            },
                                                          },
                                                          {
                                                            'title': 'Edit Customer',
                                                            'color': Colors.teal[400],
                                                            'icon': Icons.personal_injury,
                                                            'action': () async {
                                                              final editedCustomer = await Navigator.pushNamed(context, routeAddCustomer, arguments: {
                                                                'customer': customer[index],
                                                                'from': true,
                                                              });

                                                              if (editedCustomer != null && editedCustomer is CustomerModel) {
                                                                final int stableIndex =
                                                                    customersList.indexWhere((customer) => customer.id == editedCustomer.id);
                                                                log('stable Index == $stableIndex');
                                                                customerNotifer.value[index] = editedCustomer;
                                                                customersList[stableIndex] = editedCustomer;
                                                                customerNotifer.notifyListeners();
                                                              }
                                                            }
                                                          },
                                                        ],
                                                      ));
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Customer is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
