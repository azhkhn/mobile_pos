// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/model/transactions/transactions_model.dart';
import 'package:mobile_pos/screens/reports/pages/pending_payment/pages/screen_account_payable.dart';
import 'package:mobile_pos/screens/reports/pages/pending_payment/pages/screen_account_receivable.dart';

class ScreenPendingInvoice extends StatelessWidget {
  ScreenPendingInvoice({Key? key}) : super(key: key);

  //==================== TextEditing Controllers ====================
  final TextEditingController customerController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  //==================== ValueNotifer ====================
  final ValueNotifier<List<TransactionsModel>> transactionsNotifier = ValueNotifier([]);
  final ValueNotifier<int> navigationNotifier = ValueNotifier(0);

  //==================== List ====================
  List<TransactionsModel> transactionsList = [];

  final List screens = [
    ScreenAccountReceivable(),
    ScreenAccountPayable(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarWidget(title: 'Pending Invoice'),
      body: ValueListenableBuilder(
        valueListenable: navigationNotifier,
        builder: (context, int index, child) {
          return screens[index];
        },
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        )),
        child: ValueListenableBuilder(
            valueListenable: navigationNotifier,
            builder: (context, int nav, _) {
              return NavigationBar(
                height: 50,
                backgroundColor: kGrey300,
                selectedIndex: nav,
                onDestinationSelected: (int index) {
                  navigationNotifier.value = index;
                },
                animationDuration: const Duration(milliseconds: 800),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.south_west, size: 20),
                    label: 'Receivable',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.north_east, size: 20),
                    label: 'Payable',
                  ),
                ],
              );
            }),
      ),
    );
  }
}
