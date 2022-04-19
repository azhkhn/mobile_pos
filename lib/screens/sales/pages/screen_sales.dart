import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

import '../../../core/constant/sizes.dart';
import '../widgets/sales_options_card.dart';

class ScreenSales extends StatelessWidget {
  const ScreenSales({Key? key}) : super(key: key);

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
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Expanded(
                            child: SalesOptionsCard(
                              title: 'Total Sales',
                              amount: 16655,
                            ),
                          ),
                          Expanded(
                            child: SalesOptionsCard(
                              title: 'Total Amount',
                              amount: 1499655,
                            ),
                          ),
                          Expanded(
                            child: SalesOptionsCard(
                              title: 'Paid Amount',
                              amount: 16655,
                            ),
                          ),
                        ],
                      ),
                      kHeight10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Expanded(
                            child: SalesOptionsCard(
                              title: 'Balance Amount',
                              amount: 16655,
                            ),
                          ),
                          Expanded(
                            child: SalesOptionsCard(
                              title: 'Tax Amount',
                              amount: 1499655,
                            ),
                          ),
                          Expanded(
                            child: SalesOptionsCard(
                              title: 'Over Due Amount',
                              amount: 16655,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              kHeight20,
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () =>
                                Navigator.pushNamed(context, routePos),
                            color: Colors.green,
                            textColor: kWhite,
                            child: const Text(
                              'Add Sale',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () {},
                            color: Colors.indigo[400],
                            textColor: kWhite,
                            child: const Text(
                              'Credit Note',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    kHeight10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () =>
                                Navigator.pushNamed(context, routeSalesList),
                            color: Colors.deepOrange,
                            textColor: kWhite,
                            child: const Text(
                              'Sales List',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: MaterialButton(
                            height: 50,
                            onPressed: () {},
                            color: Colors.blueGrey,
                            textColor: kWhite,
                            child: const Text(
                              'Returns List',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
