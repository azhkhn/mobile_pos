import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/model/auth/user_model.dart';

class UserCardwidget extends StatelessWidget {
  const UserCardwidget({
    required this.index,
    required this.user,
    Key? key,
  }) : super(key: key);
  final int index;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AutoSizeText(
                        'No.  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          '${index + 1}',
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Group:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          user.userGroup,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: user.userGroup == 'Owner'
                                  ? kGreen
                                  : user.userGroup == 'Admin'
                                      ? kRed
                                      : kBlueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Name:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          user.name ?? user.shopName,
                          overflow: TextOverflow.ellipsis,
                          style: kBoldTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            kWidth5,
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AutoSizeText(
                        'Username:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          user.username,
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  Row(
                    children: [
                      const AutoSizeText(
                        'Contact:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: 14,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          user.mobileNumber,
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  kHeight5,
                  if (user.email != null)
                    Row(
                      children: [
                        const AutoSizeText(
                          'Email:  ',
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            user.email ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: kTextSalesCard,
                            maxLines: 1,
                            minFontSize: 10,
                            maxFontSize: 14,
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
    );
  }
}
