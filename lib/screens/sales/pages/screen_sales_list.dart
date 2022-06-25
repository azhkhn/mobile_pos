// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/db/db_functions/sales/sales_database.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/sales/widgets/sales_card_widget.dart';
import 'package:shop_ez/screens/sales/widgets/sales_list_filter.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class SalesList extends StatelessWidget {
  const SalesList({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<SalesModel>> salesNotifier = ValueNotifier([]);

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
              SalesListFilter(),

              //========== List Sales ==========
              Expanded(
                child: FutureBuilder(
                    future: SalesDatabase.instance.getAllSales(),
                    builder: (context, AsyncSnapshot<List<SalesModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No recent Sales!'));
                          }
                          salesNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: salesNotifier,
                              builder: (context, List<SalesModel> sales, _) {
                                return sales.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: sales.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: SalesCardWidget(
                                              index: index,
                                              sales: sales[index],
                                            ),
                                            onTap: () async {
                                              final bool payable = sales[index].paymentStatus == 'Partial' || sales[index].paymentStatus == 'Credit';

                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  contentPadding: kPadding0,
                                                  content: SizedBox(
                                                    height: payable ? 100 : 50,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Expanded(
                                                            child: MaterialButton(
                                                          onPressed: () async {
                                                            Navigator.pop(context);

                                                            await Navigator.pushNamed(
                                                              context,
                                                              routeSalesInvoice,
                                                              arguments: [sales[index], false],
                                                            );
                                                          },
                                                          color: Colors.blueGrey[400],
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: const [
                                                              Icon(
                                                                Icons.receipt_outlined,
                                                                color: kWhite,
                                                              ),
                                                              kWidth5,
                                                              Text(
                                                                'View Invoice',
                                                                style: TextStyle(fontWeight: FontWeight.bold, color: kWhite),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                        payable
                                                            ? Expanded(
                                                                child: MaterialButton(
                                                                    onPressed: () async {
                                                                      Navigator.pop(context);
                                                                      final dynamic updatedSale = await Navigator.pushNamed(
                                                                          context, routeTransactionSale,
                                                                          arguments: sales[index]);
                                                                      if (updatedSale != null) {
                                                                        salesNotifier.value[index] = updatedSale as SalesModel;
                                                                        salesNotifier.notifyListeners();
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
                                                                    )),
                                                              )
                                                            : kNone,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent Sales!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
