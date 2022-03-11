import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenManageSupplier extends StatelessWidget {
  const ScreenManageSupplier({Key? key}) : super(key: key);
  static const items = ['Standard', 'Service'];
  static late Size _screenSize;
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        title: const Text('Supplier'),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const TextFeildWidget(
                  labelText: 'Company *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Company in Arabic *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Supplier Name *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Supplier Name Arabic *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'VAT Number',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Address',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Address in Arabic',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'City',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'City in Arabic',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'State',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'State in Arabic',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Country',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'Country in Arabic',
                  textInputType: TextInputType.text,
                ),
                kHeight10,
                const TextFeildWidget(
                  labelText: 'PO Box',
                  textInputType: TextInputType.text,
                ),
                kHeight20,
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: _screenSize.width / 10),
                  child: CustomMaterialBtton(
                    buttonText: 'Submit',
                    textColor: kButtonTextWhite,
                    buttonColor: mainColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
