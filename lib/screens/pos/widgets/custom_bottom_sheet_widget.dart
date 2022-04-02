import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/customer_database/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  const CustomBottomSheetWidget({
    Key? key,
    required int? customerId,
  })  : _customerId = customerId,
        super(key: key);

  final int? _customerId;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * .35,
            vertical: MediaQuery.of(context).size.height * .05),
        child: SingleChildScrollView(
            controller: scrollController,
            child: FutureBuilder(
              future: CustomerDatabase.instance.getCustomerById(_customerId!),
              builder: (context, AsyncSnapshot<CustomerModel> snapshot) =>
                  snapshot.hasData
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  'Customer Type :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.customerType,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'Company :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                AutoSizeText(
                                  snapshot.data!.company,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'Company Arabic :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.companyArabic,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'Customer Name :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.customer,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'Customer Name Arabic :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.customerArabic,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'VAT Number :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.vatNumber!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'Email :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.email!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  'Address :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    snapshot.data!.address!,
                                    minFontSize: 20,
                                    maxFontSize: 50,
                                    textAlign: TextAlign.end,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AutoSizeText(
                                  'Address Arabic :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    snapshot.data!.addressArabic!,
                                    minFontSize: 20,
                                    maxFontSize: 50,
                                    maxLines: 2,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'City :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.city!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'City Arabic :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.cityArabic!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'State :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.state!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'State Arabic :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.stateArabic!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'Country :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.country!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'Country Arabic :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.countryArabic!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AutoSizeText(
                                  'PO Box :     ',
                                  maxFontSize: 50,
                                  style: TextStyle(fontSize: 20),
                                ),
                                AutoSizeText(
                                  snapshot.data!.poBox!,
                                  maxFontSize: 50,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            kHeight10,
                          ],
                        )
                      : const CircularProgressIndicator(),
            )),
      ),
    );
  }
}
