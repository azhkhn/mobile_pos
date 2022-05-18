import 'package:flutter/material.dart';

class BackgroundContainerWidget extends StatelessWidget {
  const BackgroundContainerWidget({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }
}



// class BackgroundContainerWidget extends StatelessWidget {
//   const BackgroundContainerWidget({
//     Key? key,
//     this.child,
//   }) : super(key: key);
//   final Widget? child;
//   @override
//   Widget build(BuildContext context) {
//     final _screenSize = MediaQuery.of(context).size;
//     return Container(
//       width: _screenSize.width,
//       height: _screenSize.height,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           fit: BoxFit.cover,
//           image: AssetImage(
//             'assets/images/home_items.jpg',
//           ),
//         ),
//       ),
//       child: child,
//     );
//   }
// }

