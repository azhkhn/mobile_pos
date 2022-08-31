import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/model/auth/user_model.dart';
import 'package:mobile_pos/model/group/group_model.dart';

class UserCardwidget extends StatelessWidget {
  const UserCardwidget({
    required this.index,
    required this.user,
    required this.group,
    Key? key,
  }) : super(key: key);
  final int index;
  final UserModel user;
  final GroupModel group;

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
                          group.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: user.groupId == 1 ? kGreen : kBlueGrey, fontWeight: FontWeight.bold, fontSize: 12),
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
                          style: kTextBoldSalesCard,
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
                        flex: 10,
                        child: AutoSizeText(
                          user.username,
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                      ),
                      if (UserUtils.instance.userModel?.id == user.id)
                        const Icon(
                          Icons.circle_rounded,
                          color: kGreen300,
                          size: 10,
                        )
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
                          'Status:  ',
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 14,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(user.status == 1 ? Icons.person : Icons.person_off, color: user.status == 1 ? kGreen300 : kRed300, size: 14),
                              kWidth2,
                              Expanded(
                                child: AutoSizeText(
                                  user.status == 1 ? 'Active' : 'Inactive',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: user.status == 1 ? kGreen300 : kRed300, fontWeight: FontWeight.bold, fontSize: 12),
                                  maxLines: 1,
                                  minFontSize: 10,
                                  maxFontSize: 14,
                                ),
                              ),
                            ],
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
