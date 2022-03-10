import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenItemMaster extends StatelessWidget {
  ScreenItemMaster({Key? key}) : super(key: key);
  static const items = ['Standard', 'Service'];
  late Size _screenSize;
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: const Text(
                  'Choose',
                  // style: TextStyle(color: Colors.black),
                ),
                isExpanded: true,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ),
          ),
          kHeight15,
          const TextFeildWidget(
            labelText: 'Item Name',
            textInputType: TextInputType.text,
          ),
          kHeight15,
          const TextFeildWidget(
            labelText: 'Item Name in Arabic',
            textInputType: TextInputType.text,
          ),
          kHeight25,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _screenSize.width / 10),
            child: CustomMaterialBtton(
              buttonText: 'Submit',
              textColor: kButtonTextWhite,
              buttonColor: mainColor,
            ),
          )
        ],
      ),
    )));
  }
}
