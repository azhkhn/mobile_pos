import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_product_side_widget.dart';
import 'package:shop_ez/screens/purchase/widgets/purchase_side_widget.dart';

import '../../core/constant/colors.dart';

class ScreenPurchase extends StatefulWidget {
  const ScreenPurchase({Key? key}) : super(key: key);

  @override
  State<ScreenPurchase> createState() => _ScreenPurchaseState();
}

class _ScreenPurchaseState extends State<ScreenPurchase> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

//==================== MediaQuery Screen Size ====================
  late Size _screenSize;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
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
    );
  }
}
