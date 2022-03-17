import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/brand_database/brand_database.dart';
import 'package:shop_ez/model/brand/brand_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({Key? key}) : super(key: key);

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final _brandEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final brandDB = BrandDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Brand',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //========== Brand Field ==========
              Form(
                key: _formKey,
                child: TextFeildWidget(
                  labelText: 'Brand *',
                  controller: _brandEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required*';
                    }
                    return null;
                  },
                ),
              ),
              kHeight20,

              //========== Submit Button ==========
              CustomMaterialBtton(
                buttonText: 'Submit',
                onPressed: () async {
                  final brand = _brandEditingController.text.trim();
                  final isFormValid = _formKey.currentState!;
                  if (isFormValid.validate()) {
                    log('Brand == ' + brand);
                    final _brand = BrandModel(brand: brand);

                    try {
                      await brandDB.createBrand(_brand);
                      showSnackBar(
                          context: context,
                          color: kSnackBarSuccessColor,
                          icon: const Icon(
                            Icons.done,
                            color: kSnackBarIconColor,
                          ),
                          content: 'Brand "$brand" added successfully!');
                      // _brandEditingController.text = '';
                      return setState(() {});
                    } catch (e) {
                      showSnackBar(
                          context: context,
                          color: kSnackBarErrorColor,
                          icon: const Icon(
                            Icons.new_releases_outlined,
                            color: kSnackBarIconColor,
                          ),
                          content: 'Brand "$brand" already exist!');
                    }
                  }
                },
              ),

              //========== Brand List Field ==========
              kHeight50,
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: brandDB.getAllBrands(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            itemBuilder: (context, index) {
                              final item = snapshot.data[index];
                              log('item == $item');
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: kTransparentColor,
                                  child: Text(
                                    '${index + 1}'.toString(),
                                    style:
                                        const TextStyle(color: kTextColorBlack),
                                  ),
                                ),
                                title: Text(item.brand),
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                              thickness: 1,
                            ),
                            itemCount: snapshot.data.length,
                          )
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //========== Show SnackBar ==========
  void showSnackBar(
      {required BuildContext context,
      required String content,
      Color? color,
      Widget? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon ?? const Text(''),
            kWidth5,
            Text(content),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
