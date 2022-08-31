// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/db/db_functions/sales/sales_database.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import 'package:mobile_pos/screens/reports/pages/sales_report/widgets/sales_report_filter.dart';
import 'package:mobile_pos/screens/sales/widgets/sales_card_widget.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';

//==================== Providers ====================
final AutoDisposeStateProvider<bool> _filterProvider = StateProvider.autoDispose<bool>((ref) => false);
final AutoDisposeFutureProvider<List<SalesModel>> futureSalesProvider = FutureProvider.autoDispose<List<SalesModel>>((ref) async {
  final List<SalesModel> salesList = await SalesDatabase.instance.getAllSales();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(SalesReportFilter.salesListProvider.notifier).state = salesList.reversed.toList();
  });
  return salesList.reversed.toList();
});

class ScreenSalesReport extends StatelessWidget {
  const ScreenSalesReport({
    Key? key,
  }) : super(key: key);

  static final AutoDisposeStateProvider<List<SalesModel>> salesProvider = StateProvider.autoDispose<List<SalesModel>>((ref) => []);
  static final AutoDisposeStateProvider<bool> isLoadedProvider = StateProvider.autoDispose<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    log('build() => called!');
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Sales Report',
      ),
      body: ItemScreenPaddingWidget(
        child: Column(
          children: [
            //========== Sales Filter Options ==========
            Consumer(
              builder: (context, ref, _) {
                final bool filter = ref.watch(_filterProvider);
                return Visibility(
                  visible: filter,
                  maintainState: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SalesReportFilter(),
                      kHeight5,
                    ],
                  ),
                );
              },
            ),

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
                                final _isLoaded = ref.read(isLoadedProvider.notifier);
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
                          : const Center(child: Text('No recent sales'));
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Center(child: Text('No recent sales')),
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
