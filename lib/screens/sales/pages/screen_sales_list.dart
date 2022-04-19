import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Sales',
        ),
        body: BackgroundContainerWidget(
            child: ItemScreenPaddingWidget(
          child: FutureBuilder(
              future: SalesDatabase.instance.getAllSales(),
              builder: (context, AsyncSnapshot<List<SalesModel>> snapshot) {
                final List<SalesModel> _sales = snapshot.data!;
                return ListView.separated(
                  itemCount: _sales.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      kHeight5,
                  itemBuilder: (BuildContext context, int index) {
                    return SalesCardWidget(index: index, sales: _sales);
                  },
                );
              }),
        )));
  }
}
