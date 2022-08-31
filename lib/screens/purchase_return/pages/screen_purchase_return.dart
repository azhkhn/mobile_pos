import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/screens/purchase_return/widgets/purchase_return_side.dart';
import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';

class PurchaseReturn extends StatelessWidget {
  const PurchaseReturn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundGrey,
      appBar: OrientationMode.deviceMode == OrientationMode.verticalMode ? AppBarWidget(title: 'Purchase Return') : null,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: FractionallySizedBox(
            heightFactor: .99,
            widthFactor: .98,
            alignment: Alignment.topCenter,
            // padding: EdgeInsets.symmetric(vertical: _screenSize.width * .01, horizontal: _screenSize.width * .02),
            child: OrientationMode.deviceMode == OrientationMode.normalMode
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      //========================================                                  ========================================
                      //========================================     Purchase Return Side Widget     ========================================
                      //========================================                                  ========================================
                      PurchaseReturnSideWidget(),

                      // //==================== Constant Width ====================
                      // kWidth20,

                      // //========================================                                  ========================================
                      // //======================================== Purchase Return Product Side Widget ========================================
                      // //========================================                                  ========================================
                      // PurchaseReturnProductSideWidget()
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      //========================================                                  ========================================
                      //======================================== Purchase Return Product Side Widget ========================================
                      //========================================                                  ========================================
                      // PurchaseReturnProductSideWidget(isVertical: true),

                      // //==================== Divider ====================
                      // Divider(thickness: 1, height: 10),

                      //========================================                                  ========================================
                      //========================================     Purchase Return Side Widget     ========================================
                      //========================================                                  ========================================
                      PurchaseReturnSideWidget(isVertical: true),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
