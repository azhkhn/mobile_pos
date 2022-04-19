import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/sizes.dart';
import '../../../widgets/app_bar/app_bar_widget.dart';
import '../../../widgets/container/background_container_widget.dart';
import '../../../widgets/padding_widget/item_screen_padding_widget.dart';
import '../widgets/purchase_options_card.dart';

class ScreenPurchase extends StatelessWidget {
  const ScreenPurchase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Purchase',
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
                            child: PurchaseOptionsCard(
                              title: 'Total Sales',
                              amount: 16655,
                            ),
                          ),
                          Expanded(
                            child: PurchaseOptionsCard(
                              title: 'Total Amount',
                              amount: 1499655,
                            ),
                          ),
                          Expanded(
                            child: PurchaseOptionsCard(
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
                            child: PurchaseOptionsCard(
                              title: 'Balance Amount',
                              amount: 16655,
                            ),
                          ),
                          Expanded(
                            child: PurchaseOptionsCard(
                              title: 'Tax Amount',
                              amount: 1499655,
                            ),
                          ),
                          Expanded(
                            child: PurchaseOptionsCard(
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
                                Navigator.pushNamed(context, routeAddPurchase),
                            color: Colors.green,
                            textColor: kWhite,
                            child: const Text(
                              'Add Purchase',
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
                              'Purchase Return',
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
                                Navigator.pushNamed(context, routeListPurchase),
                            color: Colors.deepOrange,
                            textColor: kWhite,
                            child: const Text(
                              'Purchase List',
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
