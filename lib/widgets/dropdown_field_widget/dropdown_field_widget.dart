import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';

class CustomDropDownField extends StatelessWidget {
  const CustomDropDownField({
    Key? key,
    this.labelText,
    required this.snapshot,
    required this.onChanged,
    this.value,
    this.style,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.enabled = true,
    this.border = false,
    this.isDesne = false,
    this.errorStyle = false,
    this.dropdownKey,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.constraints,
    this.contentPadding,
    this.floatingLabelBehavior,
  }) : super(key: key);

  final Object? value;
  final String? labelText;
  final TextStyle? style;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool enabled;
  final Icon? prefixIcon;
  final Widget? suffix;
  final List<dynamic> snapshot;
  final String? Function(dynamic)? validator;
  final void Function(dynamic)? onChanged;
  final GlobalKey? dropdownKey;
  final bool border;
  final bool isDesne;
  final BoxConstraints? constraints;
  final bool errorStyle;
  final EdgeInsetsGeometry? contentPadding;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      key: dropdownKey,
      decoration: InputDecoration(
        label: labelText != null ? Text(labelText!, style: labelStyle ?? const TextStyle(color: klabelColorGrey)) : null,
        hintText: hintText,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        enabled: enabled,
        suffix: suffix,
        prefixIcon: prefixIcon,
        border: border ? const OutlineInputBorder() : null,
        isDense: isDesne,
        errorStyle: errorStyle ? const TextStyle(fontSize: 0.01) : null,
        constraints: constraints,
        contentPadding: contentPadding ?? kPadding10,
        floatingLabelBehavior: floatingLabelBehavior,
      ),
      style: style,
      isExpanded: true,
      value: value,
      items: snapshot.isNotEmpty
          ? snapshot.map((item) {
              return DropdownMenuItem<String>(
                value: jsonToString(item),
                child: Text(item.get()),
              );
            }).toList()
          : [].map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  String jsonToString(dynamic item) {
    return jsonEncode(item.toJson());
  }
}
