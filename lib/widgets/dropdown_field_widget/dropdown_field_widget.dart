import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

class CustomDropDownField extends StatelessWidget {
  const CustomDropDownField({
    Key? key,
    required this.labelText,
    required this.snapshot,
    required this.onChanged,
    this.border = false,
    this.isDesne = false,
    this.errorStyle = false,
    this.dropdownKey,
    this.prefixIcon,
    this.validator,
    this.constraints,
    this.contentPadding,
    this.floatingLabelBehavior,
  }) : super(key: key);

  final String labelText;
  final Icon? prefixIcon;
  final AsyncSnapshot<List<dynamic>>? snapshot;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
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
        label: Text(
          labelText,
          style: const TextStyle(color: klabelColorBlack),
        ),
        prefixIcon: prefixIcon,
        border: border ? const OutlineInputBorder() : null,
        isDense: isDesne,
        errorStyle: errorStyle ? const TextStyle(fontSize: 0.01) : null,
        constraints: constraints,
        contentPadding: contentPadding,
        floatingLabelBehavior: floatingLabelBehavior,
      ),
      isExpanded: true,
      items: snapshot!.hasData
          ? snapshot!.data!.map((item) {
              return DropdownMenuItem<String>(
                value: item.get(),
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
}
