import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/screens/pos/widgets/product_side_widget.dart';
import 'package:mobile_pos/screens/pos/widgets/sale_side_widget.dart';

import '../../core/constant/colors.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size _screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kBackgroundGrey,
        body: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              heightFactor: .99,
              widthFactor: .98,
              alignment: Alignment.topCenter,
              // padding: EdgeInsets.symmetric(vertical: _screenSize.height * .005, horizontal: _screenSize.width * .02),
              // padding: EdgeInsets.symmetric(vertical: _screenSize.height * .015, horizontal: _screenSize.width * .02),
              child: OrientationMode.deviceMode == OrientationMode.normalMode
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        //========================================                  ========================================
                        //======================================== Sale Side Widget ========================================
                        //========================================                  ========================================
                        SaleSideWidget(),

                        //==================== Constant Width ====================
                        kWidth20,

                        //========================================                     ========================================
                        //======================================== Product Side Widget ========================================
                        //========================================                     ========================================
                        ProductSideWidget()
                      ],
                    )
                  : Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        //========================================                     ========================================
                        //======================================== Product Side Widget ========================================
                        //========================================                     ========================================
                        ProductSideWidget(isVertical: true),

                        //==================== Divider ====================
                        Divider(thickness: 1, height: 10),

                        // //========================================                  ========================================
                        // //======================================== Sale Side Widget ========================================
                        // //========================================                  ========================================
                        SaleSideWidget(isVertical: true),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
