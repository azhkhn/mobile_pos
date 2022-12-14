import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/db/db_functions/sales_return/sales_return_database.dart';
import 'package:mobile_pos/model/sales_return/sales_return_model.dart';
import 'package:mobile_pos/screens/sales_return/widgets/sales_return_card_widget.dart';
import 'package:mobile_pos/screens/sales_return/widgets/sales_return_filter_widget.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';

class SalesReturnList extends StatelessWidget {
  const SalesReturnList({
    Key? key,
  }) : super(key: key);

  //========== Value Notifier ==========
  static final ValueNotifier<List<SalesReturnModal>> salesReturnNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales Returns',
        ),
        body: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Sales Return Filter Options ==========
              SalesReturnListFilter(),

              kHeight5,

              //========== List Sales Returns ==========
              Expanded(
                child: FutureBuilder(
                    future: SalesReturnDatabase.instance.getAllSalesReturns(),
                    builder: (context, AsyncSnapshot<List<SalesReturnModal>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: CircularProgressIndicator());
                        case ConnectionState.done:

                        default:
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No recent Sales Returns!'));
                          }
                          salesReturnNotifier.value = snapshot.data!;
                          return ValueListenableBuilder(
                              valueListenable: salesReturnNotifier,
                              builder: (context, List<SalesReturnModal> salesReturns, _) {
                                return salesReturns.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: salesReturns.length,
                                        separatorBuilder: (BuildContext context, int index) => kHeight5,
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            child: SalesReturnCardWidget(
                                              index: index,
                                              salesReturn: salesReturns,
                                            ),
                                            onTap: () async {
                                              await Navigator.pushNamed(
                                                context,
                                                routeSalesInvoice,
                                                arguments: [salesReturns[index], true],
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : const Center(child: Text('No recent Sales Returns!!'));
                              });
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
