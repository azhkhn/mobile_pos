import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import '../../../../core/utils/device/device.dart';

class TransactionSaleDetailsTable extends StatelessWidget {
  const TransactionSaleDetailsTable({
    Key? key,
    required this.sale,
    required this.borderTop,
    this.firstRow = false,
  }) : super(key: key);

  final double borderTop;
  final bool firstRow;
  final SalesModel sale;

  static final ValueNotifier<num> totalPayingNotifier = ValueNotifier(0);
  static final ValueNotifier<num> balanceNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (totalPayingNotifier.value == 0) {
        balanceNotifier.value = Converter.amountRounder(num.parse(sale.balance));
      }
    });
    return WillPopScope(
      onWillPop: () async {
        totalPayingNotifier.value = 0;
        balanceNotifier.value = 0;
        return true;
      },
      child: Center(
        child: Table(
          columnWidths: const {
            0: FractionColumnWidth(0.25),
            1: FractionColumnWidth(0.25),
            2: FractionColumnWidth(0.25),
            3: FractionColumnWidth(0.25),
          },
          border: TableBorder(
            top: BorderSide(width: borderTop, color: kBorderColor),
            bottom: const BorderSide(width: 0.5, color: kBorderColor),
            right: const BorderSide(width: 0.5, color: kBorderColor),
            left: const BorderSide(width: 0.5, color: kBorderColor),
            horizontalInside: const BorderSide(width: 0.5, color: kBorderColor, style: BorderStyle.solid),
            verticalInside: const BorderSide(width: 0.5, color: kBorderColor, style: BorderStyle.solid),
          ),
          children: [
            TableRow(children: [
              Container(
                height: 30,
                alignment: Alignment.center,
                child: AutoSizeText(
                  firstRow ? 'Total Payable' : 'Total Paying',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: DeviceUtil.isTablet ? 13 : 12,
                    color: kBlack,
                  ),
                  minFontSize: 12,
                  maxFontSize: 13,
                ),
              ),
              Container(
                height: 30,
                alignment: Alignment.center,
                child: ValueListenableBuilder(
                    valueListenable: totalPayingNotifier,
                    builder: (__, totalPaying, _) {
                      return AutoSizeText(
                        firstRow ? Converter.currency.format(num.parse(sale.balance)) : Converter.currency.format(totalPaying),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: DeviceUtil.isTablet ? 13 : 12,
                          color: kBlack,
                        ),
                        minFontSize: 12,
                        maxFontSize: 13,
                      );
                    }),
              ),
              Container(
                height: 30,
                alignment: Alignment.center,
                child: AutoSizeText(
                  firstRow ? 'Total Amount' : 'Balance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: DeviceUtil.isTablet ? 13 : 12,
                    color: kBlack,
                  ),
                  minFontSize: 12,
                  maxFontSize: 13,
                ),
              ),
              Container(
                height: 30,
                alignment: Alignment.center,
                child: ValueListenableBuilder(
                    valueListenable: balanceNotifier,
                    builder: (_, balance, __) {
                      return AutoSizeText(
                        firstRow ? Converter.currency.format(num.parse(sale.grantTotal)) : Converter.currency.format(balance),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: DeviceUtil.isTablet ? 13 : 12,
                          color: kBlack,
                        ),
                        minFontSize: 12,
                        maxFontSize: 13,
                      );
                    }),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
