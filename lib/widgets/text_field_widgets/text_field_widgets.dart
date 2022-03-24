import 'package:flutter/material.dart';

class TextFeildWidget extends StatelessWidget {
  const TextFeildWidget({
    Key? key,
    required this.labelText,
    this.hintText,
    this.textInputType,
    this.maxLines,
    this.couterText,
    this.controller,
    this.inputBorder,
    this.prefixIcon,
    this.suffixIcon,
    this.autovalidateMode,
    this.validator,
    this.focusNode,
    this.enabled,
    this.readOnly,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.obscureText,
  }) : super(key: key);
  final String labelText;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? couterText;
  final InputBorder? inputBorder;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool? readOnly;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final Function()? onTap;

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
      maxLines: maxLines ?? 1,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      validator: validator,
      focusNode: focusNode,
      enabled: enabled ?? true,
      readOnly: readOnly ?? false,
      onSaved: onSaved,
      onChanged: onChanged,
      onTap: onTap,
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
