import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/device/device.dart';
import 'package:mobile_pos/screens/item_master/screen_add_product.dart';
import 'package:sizer/sizer.dart';

class FloatingAddOptionsAddProduct extends ConsumerWidget {
  const FloatingAddOptionsAddProduct({
    Key? key,
    required this.isDialOpen,
  }) : super(key: key);

  final ValueNotifier<bool> isDialOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: Icon(Icons.playlist_add, size: 15.sp),
          label: 'Sub-Category',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () async {
            await Navigator.pushNamed(context, routeSubCategory);
            ref.refresh(ScreenAddProduct.futureSubCategoriesByCategoryIdProvider(ref.read(ScreenAddProduct.itemCategoryIdProvider)));
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.category_outlined, size: 15.sp),
          label: 'Category',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () async {
            await Navigator.pushNamed(context, routeCategory);
            ref.refresh(ScreenAddProduct.futureCategoriesProvider);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.price_change_outlined, size: 15.sp),
          label: 'Tax Rate',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () async {
            await Navigator.pushNamed(context, routeVat);
            ref.refresh(ScreenAddProduct.futureVatsProvider);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.verified_outlined, size: 15.sp),
          label: 'Brand',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () async {
            await Navigator.pushNamed(context, routeBrand);
            ref.refresh(ScreenAddProduct.futureBrandsProvider);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.numbers, size: 15.sp),
          label: 'Unit',
          labelStyle: TextStyle(fontSize: 10.sp),
          onTap: () async {
            await Navigator.pushNamed(context, routeUnit);
            ref.refresh(ScreenAddProduct.futureUnitsProvider);
          },
        ),
      ],
    );
  }
}
