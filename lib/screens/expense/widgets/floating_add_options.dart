import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shop_ez/core/routes/router.dart';

class ExpenseFloatingAddOptions extends StatelessWidget {
  const ExpenseFloatingAddOptions({
    Key? key,
    required this.isDialOpen,
  }) : super(key: key);

  final ValueNotifier<bool> isDialOpen;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.blueGrey,
      buttonSize: const Size(50, 50),
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      animatedIcon: AnimatedIcons.add_event,
      tooltip: 'Add Expense Categories',
      childrenButtonSize: const Size(50, 50),
      // label: const Text('Expense Category'),
      onPress: () async {
        await Navigator.pushNamed(context, routeExpenseCategory);
      },
      spacing: 5,
      openCloseDial: isDialOpen,
    );
  }
}
