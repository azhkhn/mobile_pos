import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenItemMaster extends StatelessWidget {
  const ScreenItemMaster({Key? key}) : super(key: key);
  static const items = ['Standard', 'Service'];
  static late Size _screenSize;
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          title: const Text('Item Master'),
        ),
        body: Container(
            width: _screenSize.width,
            height: _screenSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/home_items.jpg',
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: _screenSize.height / 15,
                  right: _screenSize.width * 0.05,
                  left: _screenSize.width * 0.05),
              child: Column(
                children: [
                  Container(
                    width: _screenSize.width - 0.15,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text(
                          'Choose Item',
                          style: TextStyle(color: Colors.black),
                        ),
                        // prefixIcon: Icon(
                        //   Icons.store,
                        //   color: Colors.black,
                        // ),
                      ),
                      isExpanded: true,
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // setState(() {
                        //   SignUpFields.shopCategoryController = value.toString();
                        // });
                      },
                      validator: (value) {
                        // if (value == null ||
                        //     SignUpFields.shopCategoryController == 'null') {
                        //   return 'This field is required*';
                        // }
                        return null;
                      },
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
                    padding: EdgeInsets.symmetric(
                        horizontal: _screenSize.width / 10),
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
