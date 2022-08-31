import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/db/db_functions/purchase_return/purchase_return_database.dart';
import 'package:mobile_pos/model/purchase_return/purchase_return_modal.dart';
import 'package:mobile_pos/screens/purchase_return/widgets/purchase_return_card.dart';
import 'package:mobile_pos/screens/purchase_return/widgets/purchase_return_list_filter.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/container/background_container_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';

class PurchaseReturnList extends StatelessWidget {
  const PurchaseReturnList({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<PurchaseReturnModel>> purchasesReturnNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Purchase Returns',
        ),
        body: BackgroundContainerWidget(
            child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Purchases Return Filter Options ==========
              PurchaseReturnListFilter(),

              kHeight5,

              //========== List Purchases Returns ==========
              Expanded(
                child: FutureBuilder(
                    future: PurchaseReturnDatabase.instance.getAllPurchasesReturns(),
                    builder: (context, AsyncSnapshot<List<PurchaseReturnModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No recent Purchase Returns!'));
                          }
                          purchasesReturnNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: purchasesReturnNotifier,
                              builder: (context, List<PurchaseReturnModel> purchaseReturn, _) {
                                return purchaseReturn.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: purchaseReturn.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: PurchaseReturnCard(
                                              index: index,
                                              purchaseReturn: purchaseReturn,
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent Purchase Returns!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        )));
  }
}
