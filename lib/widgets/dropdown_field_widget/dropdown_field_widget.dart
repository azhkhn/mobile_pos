import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';

class CustomDropDownField extends StatelessWidget {
  const CustomDropDownField({
    Key? key,
    required this.labelText,
    required this.snapshot,
    this.dropdownKey,
    this.prefixIcon,
    this.validator,
    required this.onChanged,
  }) : super(key: key);

  final String labelText;
  final Icon? prefixIcon;
  final AsyncSnapshot<List<dynamic>>? snapshot;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final GlobalKey? dropdownKey;

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
