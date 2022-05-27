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
            Flex(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      kHeight5,

                      // Row(
                      //   children: [
                      //     const Text(
                      //       'Date:  ',
                      //       overflow: TextOverflow.ellipsis,
                      //       style: kTextSalesCard,
                      //       maxLines: 1,
                      //       minFontSize: 10,
                      //       maxFontSize: 14,
                      //     ),
                      //     Expanded(
                      //       child: Text(
                      //         Converter.dateFormat.format(DateTime.parse(customer[index].dateTime)),
                      //         overflow: TextOverflow.ellipsis,
                      //         style: kTextSalesCard,
                      //         maxLines: 1,
                      //         minFontSize: 10,
                      //         maxFontSize: 14,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // kHeight5,
                      Row(
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
                              style: kBoldTextSalesCard,
                              maxLines: 1,
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
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Customer Id:  ',
                            overflow: TextOverflow.ellipsis,
                            style: kTextSalesCard,
                            maxLines: 1,
                          ),
                          Expanded(
                            child: Text(
                              customer[index].id.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: kTextSalesCard,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      kHeight5,
                      Row(
                        children: [
                          const Text(
                            'Email:  ',
                            overflow: TextOverflow.ellipsis,
                            style: kTextSalesCard,
                            maxLines: 1,
                          ),
                          Expanded(
                            child: Text(
                              customer[index].email,
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
