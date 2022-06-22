import 'package:flutter/material.dart';
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
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          const Text(
                            'No.  ',
                            overflow: TextOverflow.ellipsis,
                            style: kTextSalesCard,
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
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          const Text(
                            'Expiry Date:  ',
                            overflow: TextOverflow.ellipsis,
                            style: kTextSalesCard,
                            maxLines: 1,
                          ),
                          Expanded(
                            child: Text(
                              Converter.dateTimeFormatAmPm.format(DateTime.parse(product.expiryDate!)),
                              overflow: TextOverflow.ellipsis,
                              style: kTextSalesCard,
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
                      'item:  ',
                      overflow: TextOverflow.ellipsis,
                      style: kTextSalesCard,
                      maxLines: 1,
                    ),
                    Expanded(
                      child: Text(
                        product.itemName,
                        overflow: TextOverflow.ellipsis,
                        style: kBoldTextSalesCard,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Cost:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                      ),
                      Expanded(
                        child: Text(
                          Converter.currency.format(num.parse(product.itemCost)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                kWidth5,
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Price:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                      ),
                      Expanded(
                        child: Text(
                          Converter.currency.format(num.parse(product.sellingPrice)),
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                kWidth5,
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Stock:  ',
                        overflow: TextOverflow.ellipsis,
                        style: kTextSalesCard,
                        maxLines: 1,
                      ),
                      Expanded(
                        child: Text(
                          product.openingStock,
                          overflow: TextOverflow.ellipsis,
                          style: kTextSalesCard,
                          maxLines: 1,
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
    );
  }
}
