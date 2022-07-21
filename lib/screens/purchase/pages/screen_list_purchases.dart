// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/purchase/purchase_database.dart';
import 'package:shop_ez/model/purchase/purchase_model.dart';

import 'package:shop_ez/screens/purchase/widgets/purchase_card_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_list_filter.dart';
import 'package:shop_ez/widgets/alertdialog/custom_popup_options.dart';

import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

final AutoDisposeFutureProvider<List<PurchaseModel>> futurePurchasesProvider = FutureProvider.autoDispose<List<PurchaseModel>>((ref) async {
  final List<PurchaseModel> purchasesList = await PurchaseDatabase.instance.getAllPurchases();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(PurchaseListFilter.purchasesListProvider.notifier).state = purchasesList.reversed.toList();
  });
  return purchasesList.reversed.toList();
});

class ScreenPurchasesList extends StatelessWidget {
  const ScreenPurchasesList({
    Key? key,
  }) : super(key: key);

  static final AutoDisposeStateProvider<List<PurchaseModel>> purchasesProvider = StateProvider.autoDispose<List<PurchaseModel>>((ref) => []);
  static final AutoDisposeStateProvider<bool> isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Purchases',
        ),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Purchases Filter Options ==========
              const PurchaseListFilter(),

              kHeight5,

              //========== List Purchases ==========
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final future = ref.watch(futurePurchasesProvider);

                    return future.when(
                      data: (value) {
                        List<PurchaseModel> _purchases = value;
                        log('FutureProvider() => called!');

                        return value.isNotEmpty
                            ? Consumer(
                                builder: (context, ref, _) {
                                  log('PurchasesProvider() => called!');

                                  final List<PurchaseModel> filteredPurchases = ref.watch(purchasesProvider);
                                  final _isLoaded = ref.read(isLoadedProvider.notifier);
                                  log('is Loaded == ' + _isLoaded.state.toString());
                                  if (_isLoaded.state) _purchases = filteredPurchases;
                                  WidgetsBinding.instance.addPostFrameCallback((_) => _isLoaded.state = true);

                                  return _purchases.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: _purchases.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                                child: PurchaseCardWidget(
                                                  index: index,
                                                  purchases: _purchases[index],
                                                ),
                                                onTap: () async {
                                                  final bool payable =
                                                      _purchases[index].paymentStatus == 'Partial' || _purchases[index].paymentStatus == 'Credit';

                                                  if (payable) {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (ctx) => CustomPopupOptions(
                                                        options: [
                                                          //========== Make Payment ==========
                                                          {
                                                            'title': 'Make Payment',
                                                            'color': kTeal400,
                                                            'icon': Icons.payment_outlined,
                                                            'action': () async {
                                                              final dynamic _updatedPurchase = await Navigator.pushNamed(
                                                                  context, routeTransactionPurchase,
                                                                  arguments: _purchases[index]);
                                                              if (_updatedPurchase != null) {
                                                                _purchases[index] = _updatedPurchase;

                                                                ref.read(purchasesProvider.notifier).state = [];
                                                                ref.read(purchasesProvider.notifier).state = _purchases;
                                                              }
                                                            }
                                                          },
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                });
                                          },
                                        )
                                      : const Center(child: Text('Purchases Not Found!'));
                                },
                              )
                            : const Center(child: Text('No recent Purchases!'));
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('No recent Purchases!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
