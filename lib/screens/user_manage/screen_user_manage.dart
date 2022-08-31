import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';

import 'package:mobile_pos/widgets/app_bar/app_bar_widget.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:mobile_pos/widgets/container/background_container_widget.dart';
import 'package:mobile_pos/widgets/padding_widget/item_screen_padding_widget.dart';

class ScreenUserManage extends StatelessWidget {
  const ScreenUserManage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Manage Users',
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
                            onPressed: () => Navigator.pushNamed(context, routeAddUser),
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
                            onPressed: () => Navigator.pushNamed(context, routeAddGroup),
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
                            onPressed: () => Navigator.pushNamed(context, routeListUser),
                            color: Colors.deepOrange,
                            textColor: kWhite,
                            buttonText: 'List Users',
                            textStyle: kTextBoldWhite,
                            icon: const Icon(Icons.group, color: kWhite),
                          ),
                        ),
                        kWidth10,
                        Expanded(
                          child: CustomMaterialBtton(
                            height: 50,
                            onPressed: () => Navigator.pushNamed(context, routeListGroup),
                            color: Colors.blueGrey,
                            textColor: kWhite,
                            buttonText: 'List Group',
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
