import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_product_side.dart';
import 'package:shop_ez/screens/sales_return/widgets/sales_return_side_widget.dart';

class SalesReturn extends StatelessWidget {
  const SalesReturn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      log('============================== landscape ============================');

      if (OrientationMode.isLandscape) {
        await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      }
    });
    Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: _screenSize.width * .01, horizontal: _screenSize.width * .02),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            //==================== Both Sides ====================
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                //========================================                                  ========================================
                //========================================     Sales Return Side Widget     ========================================
                //========================================                                  ========================================
                SalesReturnSideWidget(),

                //==================== Constant Width ====================
                kWidth20,

                //========================================                                  ========================================
                //======================================== Sales Return Product Side Widget ========================================
                //========================================                                  ========================================
                SalesReturnProductSideWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
