// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_card_widget.dart';
import 'package:shop_ez/screens/reports/pages/purchases_report/widgets/purchases_report_filter.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

//==================== Providers ====================
final AutoDisposeStateProvider<bool> _filterProvider = StateProvider.autoDispose<bool>((ref) => false);
final futurePurchasesProvider = FutureProvider.autoDispose<List<PurchaseModel>>((ref) async {
  final List<PurchaseModel> purchasesList = await PurchaseDatabase.instance.getAllPurchases();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(PurchasesReportFilter.purchasesListProvider.notifier).state = purchasesList.reversed.toList();
  });
  return purchasesList.reversed.toList();
});

class ScreenPurchasesReport extends StatelessWidget {
  const ScreenPurchasesReport({
    Key? key,
  }) : super(key: key);

  static final AutoDisposeStateProvider<List<PurchaseModel>> purchaseProvider = StateProvider.autoDispose<List<PurchaseModel>>((ref) => []);
  static final AutoDisposeStateProvider<bool> isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    log('build() => called!');
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Purchase Report',
      ),
      body: ItemScreenPaddingWidget(
        child: Column(
          children: [
            //========== Purchase Filter Options ==========
            Consumer(
              builder: (context, ref, _) {
                final bool filter = ref.watch(_filterProvider);
                return Visibility(
                  visible: filter,
                  maintainState: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      PurchasesReportFilter(),
                      kHeight5,
                    ],
                  ),
                );
              },
            ),

            //========== List Purchase ==========
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final future = ref.watch(futurePurchasesProvider);

                  return future.when(
                    data: (value) {
                      List<PurchaseModel> purchases = value;
                      log('FutureProvider() => called!');

                      return value.isNotEmpty
                          ? Consumer(
                              builder: (context, ref, _) {
                                log('PurchaseProvider() => called!');

                                final List<PurchaseModel> filteredPurchases = ref.watch(purchaseProvider);
                                final _isLoaded = ref.read(isLoadedProvider.notifier);
                                if (_isLoaded.state) purchases = filteredPurchases;
                                WidgetsBinding.instance.addPostFrameCallback((_) => _isLoaded.state = true);

                                return purchases.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: purchases.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return PurchaseCardWidget(
                                            index: index,
                                            purchases: purchases[index],
                                          );
                                        },
                                      )
                                    : const Center(child: Text('Purchases Not Found!'));
                              },
                            )
                          : const Center(child: Text('No recent purchases'));
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Text('No recent purchases')),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Card(
          elevation: 10,
          child: Container(
            height: 35,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: kBlack.withOpacity(.1),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Consumer(
                builder: ((context, ref, _) {
                  return TextButton.icon(
                      onPressed: () {
                        ref.read(_filterProvider.notifier).state = !ref.read(_filterProvider.notifier).state;
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filter', style: TextStyle(fontSize: 17)));
                }),
              ),
            ),
          )),
    );
  }
}
