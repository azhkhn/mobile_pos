import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/screens/item_master/screen_add_product.dart';

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
      children: [
        SpeedDialChild(
          child: const Icon(Icons.playlist_add),
          label: 'Sub-Category',
          onTap: () async {
            await Navigator.pushNamed(context, routeSubCategory);
            ref.refresh(ScreenAddProduct.futureSubCategoriesByCategoryIdProvider(ref.read(ScreenAddProduct.itemCategoryIdProvider)));
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.category_outlined),
          label: 'Category',
          onTap: () async {
            await Navigator.pushNamed(context, routeCategory);
            ref.refresh(ScreenAddProduct.futureCategoriesProvider);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.price_change_outlined),
          label: 'Tax Rate',
          onTap: () async {
            await Navigator.pushNamed(context, routeVat);
            ref.refresh(ScreenAddProduct.futureVatsProvider);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.verified_outlined),
          label: 'Brand',
          onTap: () async {
            await Navigator.pushNamed(context, routeBrand);
            ref.refresh(ScreenAddProduct.futureBrandsProvider);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.numbers),
          label: 'Unit',
          onTap: () async {
            await Navigator.pushNamed(context, routeUnit);
            ref.refresh(ScreenAddProduct.futureUnitsProvider);
          },
        ),
      ],
    );
  }
}
