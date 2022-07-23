import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';

import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenItemMaster extends StatelessWidget {
  const ScreenItemMaster({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Item Master',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomMaterialBtton(
                            height: 50,
                            onPressed: () => Navigator.pushNamed(context, routeAddProduct),
                            color: Colors.indigo[400],
                            textColor: kWhite,
                            buttonText: 'Add Product',
                            textStyle: kTextBoldWhite,
                            icon: const Icon(Icons.add_shopping_cart, color: kWhite),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: CustomMaterialBtton(
                            height: 50,
                            onPressed: () => Navigator.pushNamed(context, routeManageProducts),
                            color: kGreen,
                            textColor: kWhite,
                            buttonText: 'List Products',
                            textStyle: kTextBoldWhite,
                            icon: const Icon(Icons.shopping_cart_outlined, color: kWhite),
                          ),
                        ),
                      ],
                    ),
                    // kHeight10,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Expanded(
                    //       child: CustomMaterialBtton(
                    //         height: 50,
                    //         onPressed: () => Navigator.pushNamed(context, routeListUser),
                    //         color: Colors.deepOrange,
                    //         textColor: kWhite,
                    //         buttonText: 'List Products',
                    //         textStyle: kTextBoldWhite,
                    //         icon: const Icon(Icons.group, color: kWhite),
                    //       ),
                    //     ),
                    //     kWidth10,
                    //     Expanded(
                    //       child: CustomMaterialBtton(
                    //         height: 50,
                    //         onPressed: () => Navigator.pushNamed(context, routeListGroup),
                    //         color: Colors.blueGrey,
                    //         textColor: kWhite,
                    //         buttonText: 'List Group',
                    //         textStyle: kTextBoldWhite,
                    //         icon: const Icon(Icons.security, color: kWhite),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
