import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  const CustomBottomSheetWidget({Key? key, this.supplier = false, this.model}) : super(key: key);

  final bool supplier;

  final dynamic model;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(color: kWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * .35, vertical: MediaQuery.of(context).size.height * .05),
        child: FractionallySizedBox(
            widthFactor: .88,
            heightFactor: .9,
            child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    supplier
                        ? const SizedBox()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  model.customerType,
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
                            supplier ? model.supplierName : model.customer,
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
                            supplier ? 'Supplier Name Arabic' : 'Customer Name Arabic',
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
                            supplier ? model.supplierNameArabic : model.customerArabic,
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
                            supplier ? 'Contact Name' : 'Company',
                            maxFontSize: 20,
                            style: const TextStyle(
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
                            supplier ? model.contactName : model.company,
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
                            supplier ? 'Contact Number' : 'Company Arabic',
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
                            supplier ? model.contactNumber : model.companyArabic,
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
                            model.vatNumber!,
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
                            model.email!,
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
                            model.address!,
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
                            model.addressArabic!,
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
                            model.city!,
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
                            model.cityArabic!,
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
                            model.state!,
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
                            model.stateArabic!,
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
                            model.country!,
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
                            model.countryArabic!,
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
                            model.poBox!,
                            textAlign: TextAlign.end,
                            maxFontSize: 20,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    kHeight10,
                  ],
                ))),
      ),
    );
  }
}
