import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/screens/pos/widgets/product_side_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sale_side_widget.dart';

import '../../core/constant/colors.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
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
            ),
          ),
        ),
      ),
    );
  }
}

//========== Show SnackBar ==========
void showSnackBar(
    {required BuildContext context,
    required String content,
    Color? color,
    Widget? icon}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon ?? const Text(''),
          kWidth5,
          Flexible(
            child: Text(
              content,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
