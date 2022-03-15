import 'package:flutter/material.dart';
import 'package:shop_ez/db/db_functions/category_database/category_db.dart';
import 'package:shop_ez/model/category/category_model.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/dropdown_field_widget/dropdown_field_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

class CustomerScreen extends StatelessWidget {
  CustomerScreen({Key? key}) : super(key: key);
  final categoryDB = CategoryDatabase.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Customer',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: FutureBuilder(
              future: categoryDB.getAllCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CategoryModel>> snapshot) {
                return CustomDropDownField(
                  labelText: "Choose Customer *",
                  onChanged: (_) {},
                  snapshot: snapshot,
                );
              }),
        ),
      ),
    );
  }
}
