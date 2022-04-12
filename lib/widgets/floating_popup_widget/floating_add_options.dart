import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';

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
      children: [
        SpeedDialChild(
          child: const Icon(Icons.receipt_long_rounded),
          label: 'Item Master',
          onTap: () => Navigator.pushNamed(context, routeItemMaster),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_business_outlined),
          label: 'Supplier',
          onTap: () => Navigator.pushNamed(context, routeManageSupplier),
        ),
        SpeedDialChild(
          child: const Icon(Icons.person_add_outlined),
          label: 'Customer',
          onTap: () => Navigator.pushNamed(context, routeCustomer),
        ),
        SpeedDialChild(
          child: const Icon(Icons.paid_outlined),
          label: 'Expense Category',
          onTap: () => Navigator.pushNamed(context, routeExpenseCategory),
        ),
        SpeedDialChild(
          child: const Icon(Icons.playlist_add),
          label: 'Sub-Category',
          onTap: () => Navigator.pushNamed(context, routeSubCategory),
        ),
        SpeedDialChild(
          child: const Icon(Icons.category_outlined),
          label: 'Category',
          onTap: () => Navigator.pushNamed(context, routeCategory),
        ),
        SpeedDialChild(
          child: const Icon(Icons.numbers),
          label: 'Unit',
          onTap: () => Navigator.pushNamed(context, routeUnit),
        ),
        SpeedDialChild(
          child: const Icon(Icons.verified_outlined),
          label: 'Brand',
          onTap: () => Navigator.pushNamed(context, routeBrand),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_business_outlined),
          label: 'Business Profile',
          onTap: () => Navigator.pushNamed(context, routeBusinessProfile),
        ),
        SpeedDialChild(
          child: const Icon(Icons.price_change_outlined),
          label: 'Tax Rate',
          onTap: () => Navigator.pushNamed(context, routeVat),
        ),
      ],
    );
  }
}
