import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  const CustomBottomSheetWidget({
    Key? key,
    required this.id,
    this.supplier = false,
  }) : super(key: key);

  final int? id;
  final bool supplier;

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
              future: supplier
                  ? SupplierDatabase.instance.getSupplierById(id!)
                  : CustomerDatabase.instance.getCustomerById(id!),
              builder: (context, AsyncSnapshot<dynamic> snapshot) => snapshot
                      .hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        supplier
                            ? const SizedBox()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            AutoSizeText(
                              supplier
                                  ? 'Supplier Name :     '
                                  : 'Customer Name :     ',
                              maxFontSize: 50,
                              style: const TextStyle(fontSize: 20),
                            ),
                            AutoSizeText(
                              supplier
                                  ? snapshot.data!.supplier
                                  : snapshot.data!.customer,
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
                            AutoSizeText(
                              supplier
                                  ? 'Supplier Name Arabic :     '
                                  : 'Customer Name Arabic :     ',
                              maxFontSize: 50,
                              style: const TextStyle(fontSize: 20),
                            ),
                            AutoSizeText(
                              supplier
                                  ? snapshot.data!.supplierArabic
                                  : snapshot.data!.customerArabic,
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
