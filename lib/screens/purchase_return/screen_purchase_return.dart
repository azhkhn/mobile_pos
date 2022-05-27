import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/screens/purchase_return/widgets/purchase_return_product_side.dart';
import 'package:shop_ez/screens/purchase_return/widgets/purchase_return_side_widget.dart';

class PurchaseReturn extends StatelessWidget {
  const PurchaseReturn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: _screenSize.width * .01, horizontal: _screenSize.width * .02),
          child: OrientationMode.deviceMode == OrientationMode.normalMode
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    //========================================                                  ========================================
                    //========================================     Purchase Return Side Widget     ========================================
                    //========================================                                  ========================================
                    PurchaseReturnSideWidget(),

                    //==================== Constant Width ====================
                    kWidth20,

                    //========================================                                  ========================================
                    //======================================== Purchase Return Product Side Widget ========================================
                    //========================================                                  ========================================
                    PurchaseReturnProductSideWidget()
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    //========================================                                  ========================================
                    //======================================== Purchase Return Product Side Widget ========================================
                    //========================================                                  ========================================
                    PurchaseReturnProductSideWidget(isVertical: true),

                    //==================== Divider ====================
                    Divider(thickness: 1, height: 10),

                    //========================================                                  ========================================
                    //========================================     Purchase Return Side Widget     ========================================
                    //========================================                                  ========================================
                    PurchaseReturnSideWidget(isVertical: true),
                  ],
                ),
        ),
      ),
    );
  }
}
