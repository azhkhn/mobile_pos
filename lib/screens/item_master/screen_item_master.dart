import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenItemMaster extends StatelessWidget {
  const ScreenItemMaster({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Item Master'),
      body: ItemScreenPaddingWidget(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: CustomMaterialBtton(
                height: 50,
                onPressed: () => Navigator.pushNamed(context, routeAddProduct),
                color: Colors.indigo[400],
                textColor: kWhite,
                buttonText: 'Add Product',
                textStyle: kTextBoldWhite,
                fittedText: true,
                icon: const Icon(Icons.add_shopping_cart, color: kWhite),
              ),
            ),
            kWidth10,
            Flexible(
              child: CustomMaterialBtton(
                height: 50,
                onPressed: () => Navigator.pushNamed(context, routeManageProducts),
                color: kGreen,
                textColor: kWhite,
                buttonText: 'List Products',
                textStyle: kTextBoldWhite,
                fittedText: true,
                icon: const Icon(Icons.shopping_cart_outlined, color: kWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
