import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/core/constant/colors.dart';

class TextFeildWidget extends StatelessWidget {
  const TextFeildWidget(
      {Key? key,
      this.labelText,
      this.hintText,
      this.textStyle,
      this.hintStyle,
      this.isHint = false,
      this.textInputType,
      this.textCapitalization = TextCapitalization.none,
      this.inputFormatters,
      this.textDirection,
      this.maxLines,
      this.couterText,
      this.controller,
      this.inputBorder,
      this.prefixIcon,
      this.suffixIcon,
      this.suffixIconConstraints,
      this.autovalidateMode,
      this.validator,
      this.errorStyle = false,
      this.focusNode,
      this.enabled,
      this.isDense,
      this.contentPadding,
      this.constraints,
      this.readOnly,
      this.onSaved,
      this.onChanged,
      this.onTap,
      this.obscureText,
      this.floatingLabelBehavior})
      : super(key: key);
  final String? labelText;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool isHint;
  final TextInputType? textInputType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final int? maxLines;
  final String? couterText;
  final InputBorder? inputBorder;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool? readOnly;
  final bool? isDense;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final Function()? onTap;
  final BoxConstraints? constraints;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final EdgeInsetsGeometry? contentPadding;
  final bool? obscureText;
  final bool errorStyle;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
        floatingLabelBehavior: floatingLabelBehavior,
        counterText: couterText,
        labelText: isHint ? null : labelText,
        border: inputBorder ?? const UnderlineInputBorder(),
        labelStyle: const TextStyle(color: klabelColorGrey),
        fillColor: kWhite,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints,
        hintText: isHint ? labelText : hintText,
        hintStyle: hintStyle,
        isDense: isDense,
        errorStyle: errorStyle ? const TextStyle(fontSize: 0.01) : null,
        constraints: constraints,
        contentPadding: contentPadding,
      ),
      keyboardType: textInputType ?? TextInputType.text,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      textDirection: textDirection ?? TextDirection.ltr,
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
