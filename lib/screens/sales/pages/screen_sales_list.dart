// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/sales/widgets/sales_card_widget.dart';
import 'package:shop_ez/screens/sales/widgets/sales_list_filter.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

final AutoDisposeFutureProvider<List<SalesModel>> futureSalesProvider = FutureProvider.autoDispose<List<SalesModel>>((ref) async {
  final List<SalesModel> salesList = await SalesDatabase.instance.getAllSales();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(SalesListFilter.salesListProvider.notifier).state = salesList.reversed.toList();
  });
  return salesList.reversed.toList();
});

class ScreenSalesList extends StatelessWidget {
  const ScreenSalesList({
    Key? key,
  }) : super(key: key);

  static final AutoDisposeStateProvider<List<SalesModel>> salesProvider = StateProvider.autoDispose<List<SalesModel>>((ref) => []);
  static final AutoDisposeStateProvider<bool> isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales',
        ),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Sales Filter Options ==========
              const SalesListFilter(),

              kHeight5,

              //========== List Sales ==========
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final future = ref.watch(futureSalesProvider);

                    return future.when(
                      data: (value) {
                        List<SalesModel> sales = value;
                        log('FutureProvider() => called!');

                        return value.isNotEmpty
                            ? Consumer(
                                builder: (context, ref, _) {
                                  log('SalesProvider() => called!');

                                  final List<SalesModel> filteredSales = ref.watch(salesProvider);
                                  final _isLoaded = ref.read(isLoadedProvider.state);
                                  log('is Loaded == ' + _isLoaded.state.toString());
                                  if (_isLoaded.state) sales = filteredSales;
                                  WidgetsBinding.instance.addPostFrameCallback((_) => _isLoaded.state = true);

                                  return sales.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: sales.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              child: SalesCardWidget(
                                                index: index,
                                                sales: sales[index],
                                              ),
                                              onTap: () async {
                                                await Navigator.pushNamed(context, routeSalesInvoice, arguments: [sales[index], false]);
                                              },
                                            );
                                          },
                                        )
                                      : const Center(child: Text('Sales Not Found!'));
                                },
                              )
                            : const Center(child: Text('No recent Sales!'));
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('No recent Sales!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
