import 'package:flutter/material.dart';

class TextFeildWidget extends StatelessWidget {
  const TextFeildWidget({
    Key? key,
    required this.labelText,
    this.hintText,
    this.textInputType,
    this.couterText,
    this.controller,
    this.inputBorder,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.focusNode,
    this.onSaved,
    this.onChanged,
    this.obscureText,
  }) : super(key: key);
  final String labelText;
  final String? hintText;
  final TextInputType? textInputType;
  final String? couterText;
  final InputBorder? inputBorder;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;

  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        counterText: couterText,
        labelText: labelText,
        border: inputBorder ?? const UnderlineInputBorder(),
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
      ),
      keyboardType: textInputType ?? TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      focusNode: focusNode,
      onSaved: onSaved,
      onChanged: onChanged,
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
