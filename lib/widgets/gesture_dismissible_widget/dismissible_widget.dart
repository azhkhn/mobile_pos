import 'package:flutter/material.dart';

class DismissibleWidget extends StatelessWidget {
  const DismissibleWidget({
    Key? key,
    required this.context,
    required this.child,
  }) : super(key: key);

  final BuildContext context;
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: GestureDetector(
          child: child,
          onTap: () {},
        ),
      );
}
