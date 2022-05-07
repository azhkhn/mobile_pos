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
                                  const Expanded(
                                    flex: 5,
                                    child: AutoSizeText(
                                      'Customer Type',
                                      maxFontSize: 20,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const Expanded(
                                      child: Text(
                                    ' : ',
                                    textAlign: TextAlign.center,
                                  )),
                                  Expanded(
                                    flex: 7,
                                    child: AutoSizeText(
                                      snapshot.data!.customerType,
                                      textAlign: TextAlign.end,
                                      maxFontSize: 20,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                supplier ? 'Supplier Name' : 'Customer Name',
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                supplier
                                    ? snapshot.data!.supplier
                                    : snapshot.data!.customer,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                supplier
                                    ? 'Supplier Name Arabic'
                                    : 'Customer Name Arabic',
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                supplier
                                    ? snapshot.data!.supplierArabic
                                    : snapshot.data!.customerArabic,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'Company',
                                maxFontSize: 20,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.company,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'Company Arabic',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.companyArabic,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'VAT Number',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.vatNumber!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'Email',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.email!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'Address',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.address!,
                                textAlign: TextAlign.end,
                                minFontSize: 12,
                                maxFontSize: 20,
                                maxLines: 2,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'Address Arabic',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.addressArabic!,
                                textAlign: TextAlign.end,
                                minFontSize: 12,
                                maxFontSize: 20,
                                maxLines: 2,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'City',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.city!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'City Arabic',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.cityArabic!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'State',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.state!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'State Arabic',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.stateArabic!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'Country',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.country!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'Country Arabic',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.countryArabic!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        kHeight10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                'PO Box',
                                maxFontSize: 20,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const Expanded(
                                child: Text(
                              ' : ',
                              textAlign: TextAlign.center,
                            )),
                            Expanded(
                              flex: 7,
                              child: AutoSizeText(
                                snapshot.data!.poBox!,
                                textAlign: TextAlign.end,
                                maxFontSize: 20,
                                style: const TextStyle(fontSize: 12),
                              ),
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
