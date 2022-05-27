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
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';

class CustomerList extends StatelessWidget {
  CustomerList({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final customerController = TextEditingController();

//==================== Value Notifiers ====================
  final ValueNotifier<int?> customerIdNotifier = ValueNotifier(null);
  static final ValueNotifier<String?> customerNameNotifier = ValueNotifier(null);

  //========== Value Notifier ==========
  static final ValueNotifier<List<CustomerModel>> customerNotifer = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: 'Customer Manage'),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
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
                                onTap: () {
                                  customerIdNotifier.value = null;
                                  customerController.clear();
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
                        customerController.text = suggestion.customer;
                        customerNameNotifier.value = suggestion.customer;
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
                                        child: CustomBottomSheetWidget(id: customerIdNotifier.value),
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
                          final id = await Navigator.pushNamed(context, routeAddCustomer, arguments: true);

                          if (id != null) {
                            final addedCustomer = await CustomerDatabase.instance.getCustomerById(id as int);

                            customerController.text = addedCustomer.customer;
                            customerNameNotifier.value = addedCustomer.customer;
                            customerIdNotifier.value = addedCustomer.id;
                            log(addedCustomer.company);
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

              //========== List Sales ==========
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
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: kTransparentColor,
                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                                  builder: (context) => DismissibleWidget(
                                                        context: context,
                                                        child: CustomBottomSheetWidget(id: customer[index].id),
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
