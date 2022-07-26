import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_product_side_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_side_widget.dart';

import '../../../core/constant/colors.dart';

class Purchase extends StatelessWidget {
  const Purchase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundGrey,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            heightFactor: .99,
            widthFactor: .98,
            alignment: Alignment.topCenter,
            // padding: EdgeInsets.symmetric(vertical: _screenSize.width * .015, horizontal: _screenSize.width * .02),
            child: OrientationMode.deviceMode == OrientationMode.normalMode
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //========================================                  ========================================
                      //======================================== Purchase Side Widget ========================================
                      //========================================                  ========================================
                      const PurchaseSideWidget(),

                      //==================== Constant Width ====================
                      kWidth20,

                      //========================================                     ========================================
                      //======================================== Purchase Product Side Widget ========================================
                      //========================================                     ========================================
                      PurchaseProductSideWidget()
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //========================================                     ========================================
                      //======================================== Purchase Product Side Widget ========================================
                      //========================================                     ========================================
                      PurchaseProductSideWidget(isVertical: true),

                      //==================== Divider ====================
                      const Divider(thickness: 1, height: 10),

                      //========================================                  ========================================
                      //======================================== Purchase Side Widget ========================================
                      //========================================                  ========================================
                      const PurchaseSideWidget(isVertical: true),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
