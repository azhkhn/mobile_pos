import 'package:flutter/material.dart';

class TextFeildWidget extends StatelessWidget {
  const TextFeildWidget({
    Key? key,
    required this.labelText,
    this.textInputType,
    this.couterText,
    this.textEditingController,
    this.inputBorder,
    this.prefixIcon,
    this.validator,
    this.obscureText,
  }) : super(key: key);
  final String labelText;
  final TextInputType? textInputType;
  final String? couterText;
  final InputBorder? inputBorder;
  final Icon? prefixIcon;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        counterText: couterText,
        labelText: labelText,
        border: inputBorder ?? const UnderlineInputBorder(),
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: prefixIcon,
      ),
      keyboardType: textInputType ?? TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      obscureText: obscureText ?? false,
    );
  }
}


// class TextFeildWidget extends StatelessWidget {
//   const TextFeildWidget({
//     Key? key,
//     required this.labelText,
//     required this.textInputType,
//     this.couterText,
//     this.textEditingController,
//   }) : super(key: key);
//   final String labelText;
//   final TextInputType textInputType;
//   final String? couterText;
//   final TextEditingController? textEditingController;
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: textEditingController,
//       decoration: InputDecoration(
//         counterText: couterText,
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//       keyboardType: textInputType,
//     );
//   }
// }
