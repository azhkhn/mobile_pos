import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/text.dart';

import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/container/background_container_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';

import '../../../core/constant/sizes.dart';

class ScreenUserModule extends StatelessWidget {
  const ScreenUserModule({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    return Scaffold(
      appBar: AppBarWidget(
        title: 'User Module',
      ),
      body: BackgroundContainerWidget(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomMaterialBtton(
                            height: 50,
                            onPressed: () async {},
                            color: Colors.indigo[400],
                            textColor: kWhite,
                            buttonText: 'Add User',
                            textStyle: kTextBoldWhite,
                            icon: const Icon(Icons.person_add, color: kWhite),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: CustomMaterialBtton(
                            height: 50,
                            onPressed: () async {},
                            color: kGreen,
                            textColor: kWhite,
                            buttonText: 'Add Group',
                            textStyle: kTextBoldWhite,
                            icon: const Icon(Icons.workspace_premium, color: kWhite),
                          ),
                        ),
                      ],
                    ),
                    kHeight10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomMaterialBtton(
                            height: 50,
                            onPressed: () async {},
                            color: Colors.deepOrange,
                            textColor: kWhite,
                            buttonText: 'Manage Users',
                            textStyle: kTextBoldWhite,
                            icon: const Icon(Icons.manage_accounts, color: kWhite),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: CustomMaterialBtton(
                            height: 50,
                            onPressed: () {},
                            color: Colors.blueGrey,
                            textColor: kWhite,
                            buttonText: 'Manage Group',
                            textStyle: kTextBoldWhite,
                            icon: const Icon(Icons.security, color: kWhite),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
