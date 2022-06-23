import 'package:flutter/material.dart';
import 'package:shop_ez/model/customer/customer_model.dart';

import '../../../core/constant/sizes.dart';
import '../../../core/constant/text.dart';

class CustomerCardWidget extends StatelessWidget {
  const CustomerCardWidget({
    required this.index,
    required this.customer,
    Key? key,
  }) : super(key: key);
  final int index;
  final List<CustomerModel> customer;

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
                      child: Row(
                        children: [
                          const Text(
                            'Contact :  ',
                            overflow: TextOverflow.ellipsis,
                            style: kTextSalesCard,
                            maxLines: 1,
                          ),
                          Expanded(
                            child: Text(
                              customer[index].contactNumber,
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
                      'Customer:  ',
                      overflow: TextOverflow.ellipsis,
                      style: kTextSalesCard,
                      maxLines: 1,
                    ),
                    Expanded(
                      child: Text(
                        customer[index].customer,
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
              children: [
                const Text(
                  'Address:  ',
                  overflow: TextOverflow.ellipsis,
                  style: kTextSalesCard,
                  maxLines: 1,
                ),
                Expanded(
                  child: Text(
                    customer[index].address,
                    overflow: TextOverflow.ellipsis,
                    style: kTextSalesCard,
                    maxLines: 1,
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
