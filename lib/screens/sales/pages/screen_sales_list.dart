import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/screens/sales/widgets/sales_list_filter.dart';

import '../../../../core/constant/sizes.dart';
import '../../../../db/db_functions/sales/sales_database.dart';
import '../../../../model/sales/sales_model.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';
import '../../../widgets/container/background_container_widget.dart';
import '../../../widgets/padding_widget/item_screen_padding_widget.dart';
import '../widgets/sales_card_widget.dart';

class SalesList extends StatelessWidget {
  const SalesList({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<SalesModel>> salesNotifier =
      ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales',
        ),
        body: BackgroundContainerWidget(
            child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Purchase Filter Options ==========
              SalesListFilter(),

              //========== List Sales ==========
              Expanded(
                child: FutureBuilder(
                    future: SalesDatabase.instance.getAllSales(),
                    builder:
                        (context, AsyncSnapshot<List<SalesModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Sales is Empty!'));
                          }
                          salesNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: salesNotifier,
                              builder: (context, List<SalesModel> sales, _) {
                                return sales.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: sales.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                kHeight5,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            child: SalesCardWidget(
                                              index: index,
                                              sales: sales,
                                            ),
                                            onTap: () async {
                                              await Navigator.pushNamed(
                                                context,
                                                routeInvoice,
                                                arguments: sales[index],
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text('Sales is Empty!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        )));
  }
}
