import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

class ScreenItemMaster extends StatelessWidget {
  const ScreenItemMaster({Key? key}) : super(key: key);
  static const items = ['Standard', 'Service'];
  static late Size _screenSize;
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBarWidget(
          title: 'Item Master',
        ),
        body: BackgroundContainerWidget(
            child: ItemScreenPaddingWidget(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //========== Product Type Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Product Type *',
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
                kHeight10,

                //========== Item Name ==========
                const TextFeildWidget(
                  labelText: 'Item Name *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,

                //========== Item Name in Arabic ==========
                const TextFeildWidget(
                  labelText: 'Item Name in Arabic *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,

                //========== Item Code ==========
                const TextFeildWidget(
                  labelText: 'Item Code *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,

                //========== Item Category Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Item Category *',
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
                kHeight10,

                //========== Item Sub-Category Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Item Sub-Category',
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
                kHeight10,

                //========== Item Brand Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Item Brand',
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
                kHeight10,

                //========== Item Cost ==========
                const TextFeildWidget(
                  labelText: 'Item Cost *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,

                //========== Selling Price ==========
                const TextFeildWidget(
                  labelText: 'Selling Price *',
                  textInputType: TextInputType.text,
                ),
                kHeight10,

                //========== Secondary Selling Price ==========
                const TextFeildWidget(
                  labelText: 'Secondary Selling Price',
                  textInputType: TextInputType.text,
                ),
                kHeight10,

                //========== Product VAT Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Product VAT *',
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
                kHeight10,

                //========== Unit Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'Unit',
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
                kHeight10,

                //========== Opening Stock ==========
                const TextFeildWidget(
                  labelText: 'Opening Stock',
                  textInputType: TextInputType.text,
                ),
                kHeight10,

                //========== VAT Method Dropdown ==========
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text(
                      'VAT Method *',
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
                kHeight10,

                //========== Alert Quantity ==========
                const TextFeildWidget(
                  labelText: 'Alert Quantity',
                  textInputType: TextInputType.text,
                ),

                //========== Submit Button ==========
                kHeight20,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _screenSize.width / 10,
                  ),
                  child: CustomMaterialBtton(
                    buttonText: 'Submit',
                    onPressed: () {},
                  ),
                ),
                kHeight10,
              ],
            ),
          ),
        )));
  }
}
