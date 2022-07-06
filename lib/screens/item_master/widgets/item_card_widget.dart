import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/constant/text.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({
    required this.index,
    required this.product,
    Key? key,
  }) : super(key: key);
  final int index;
  final ItemMasterModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            'No.  ',
                            overflow: TextOverflow.ellipsis,
                            style: kText12Lite,
                            maxLines: 1,
                          ),
                          Expanded(
                            child: Text(
                              '${index + 1}',
                              overflow: TextOverflow.ellipsis,
                              style: kTextSalesCard,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    kWidth5,
                    if (product.expiryDate!.isNotEmpty)
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'Expiry Date:  ',
                              overflow: TextOverflow.ellipsis,
                              style: kText12Lite,
                              maxLines: 1,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                Converter.dateFormat.format(DateTime.parse(product.expiryDate!)),
                                overflow: TextOverflow.ellipsis,
                                style: kTextSalesCard,
                                textAlign: TextAlign.end,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                kHeight5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Product:  ',
                      overflow: TextOverflow.ellipsis,
                      style: kText12Lite,
                      maxLines: 1,
                    ),
                    Expanded(
                      child: Text(
                        product.itemName,
                        overflow: TextOverflow.ellipsis,
                        style: kTextBoldSalesCard,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            kHeight5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Cost:  ',
                          style: kText12Lite,
                        ),
                        TextSpan(
                          text: Converter.currency.format(num.parse(product.itemCost)),
                          style: kTextSalesCard,
                        ),
                      ],
                    ),
                  ),
                ),
                kWidth5,
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Price:  ',
                          style: kText12Lite,
                        ),
                        TextSpan(
                          text: Converter.currency.format(num.parse(product.sellingPrice)),
                          style: kTextSalesCard,
                        ),
                      ],
                    ),
                  ),
                ),
                kWidth5,
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Stock:  ',
                          style: kText12Lite,
                        ),
                        TextSpan(
                          text: product.openingStock,
                          style: TextStyle(fontSize: 12, color: num.parse(product.openingStock) <= 0 ? kRed : kBlack),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
