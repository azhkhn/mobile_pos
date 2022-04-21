import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_product_side_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_side_widget.dart';

import '../../../core/constant/colors.dart';

class Purchase extends StatelessWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundGrey,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _screenSize.width * .01,
                horizontal: _screenSize.width * .02),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              //==================== Both Sides ====================
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  //========================================                  ========================================
                  //======================================== Purchase Side Widget ========================================
                  //========================================                  ========================================
                  PurchaseSideWidget(),

                  //==================== Constant Width ====================
                  kWidth20,

                  //========================================                     ========================================
                  //======================================== Purchase Product Side Widget ========================================
                  //========================================                     ========================================
                  PurchaseProductSideWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
