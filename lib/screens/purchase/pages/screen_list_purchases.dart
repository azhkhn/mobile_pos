// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_list_filter.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

import '../widgets/purchase_card_widget.dart';

class PurchasesList extends StatelessWidget {
  const PurchasesList({Key? key}) : super(key: key);

//========== Value Notifier ==========
  static final ValueNotifier<List<PurchaseModel>> purchasesNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Purchases',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Purchase Filter Options ==========
              PurchaseListFilter(),

              //========== List Purchases ==========
              Expanded(
                child: FutureBuilder(
                    future: PurchaseDatabase.instance.getAllPurchases(),
                    builder: (context, AsyncSnapshot<List<PurchaseModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Purchases is Empty!'));
                          }
                          purchasesNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: purchasesNotifier,
                              builder: (context, List<PurchaseModel> purchases, _) {
                                return purchases.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: purchases.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: PurchaseCardWidget(index: index, purchases: purchases),
                                            onTap: () async {
                                              final bool payable =
                                                  purchases[index].paymentStatus == 'Partial' || purchases[index].paymentStatus == 'Credit';

                                              payable
                                                  ? showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        contentPadding: kPadding0,
                                                        content: SizedBox(
                                                            height: 50,
                                                            child: MaterialButton(
                                                                onPressed: () async {
                                                                  Navigator.pop(context);
                                                                  final dynamic updatedPurchase = await Navigator.pushNamed(
                                                                    context,
                                                                    routeTransactionPurchase,
                                                                    arguments: purchases[index],
                                                                  );
                                                                  if (updatedPurchase != null) {
                                                                    purchasesNotifier.value[index] = updatedPurchase as PurchaseModel;
                                                                    purchasesNotifier.notifyListeners();
                                                                  }
                                                                },
                                                                color: Colors.teal[400],
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: const [
                                                                    Icon(
                                                                      Icons.payment_outlined,
                                                                      color: kWhite,
                                                                    ),
                                                                    kWidth5,
                                                                    Text(
                                                                      'Make Payment',
                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: kWhite),
                                                                    ),
                                                                  ],
                                                                ))),
                                                      ),
                                                    )
                                                  : null;
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Purchases is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
