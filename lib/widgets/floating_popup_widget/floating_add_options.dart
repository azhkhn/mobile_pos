import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:sizer/sizer.dart';

class FloatingAddOptions extends StatelessWidget {
  const FloatingAddOptions({
    Key? key,
    required this.isDialOpen,
  }) : super(key: key);

  final ValueNotifier<bool> isDialOpen;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: mainColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      animatedIcon: AnimatedIcons.add_event,
      spacing: 5,
      openCloseDial: isDialOpen,
      buttonSize: isThermal ? const Size(45, 45) : const Size(52, 52),
      childrenButtonSize: isThermal ? const Size(45, 45) : const Size(52, 52),
      spaceBetweenChildren: 1.sp,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add_shopping_cart_outlined, size: 15.sp),
          label: 'Add Product',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () => Navigator.pushNamed(context, routeAddProduct),
        ),
        SpeedDialChild(
          child: Icon(Icons.add_business_outlined, size: 15.sp),
          label: 'Add Supplier',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () => Navigator.pushNamed(context, routeAddSupplier),
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add_outlined, size: 15.sp),
          label: 'Add Customer',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () => Navigator.pushNamed(context, routeAddCustomer),
        ),
        SpeedDialChild(
            child: Icon(Icons.playlist_add, size: 15.sp),
            label: 'Sub-Category',
            labelStyle: TextStyle(fontSize: 10.sp),
            onTap: () => Navigator.pushNamed(context, routeSubCategory)),
        SpeedDialChild(
          child: Icon(Icons.category_outlined, size: 15.sp),
          label: 'Category',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () => Navigator.pushNamed(context, routeCategory),
        ),
        SpeedDialChild(
          child: Icon(Icons.verified_outlined, size: 15.sp),
          label: 'Brand',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () => Navigator.pushNamed(context, routeBrand),
        ),
        SpeedDialChild(
          child: Icon(Icons.numbers, size: 15.sp),
          label: 'Unit',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () => Navigator.pushNamed(context, routeUnit),
        ),
        SpeedDialChild(
          child: Icon(Icons.price_change_outlined, size: 15.sp),
          label: 'Tax Rate',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () => Navigator.pushNamed(context, routeVat),
        ),
        // SpeedDialChild(
        //   child:  Icon(Icons.add_business_outlined, size: 15.sp),
        //   label: 'Business Profile',
        // labelStyle: TextStyle(fontSize: 10.sp),
        //   onTap: () => Navigator.pushNamed(context, routeBusinessProfile),
        // ),
        // SpeedDialChild(
        //   child:  Icon(Icons.qr_code_2_outlined, size: 15.sp),
        //   label: 'Barcode',
        // labelStyle: TextStyle(fontSize: 10.sp),
        //   onTap: () => Navigator.pushNamed(context, routeBarcode),
        // ),
      ],
    );
  }
}
