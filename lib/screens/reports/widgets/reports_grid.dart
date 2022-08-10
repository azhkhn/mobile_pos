import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:sizer/sizer.dart';

const List reportGridName = [
  'OPERATION SUMMARY',
  'TRANSACTIONS REPORT',
  'PENDING INVOICE',
  'SALES REPORT',
  'PURCHASES REPORT',
  'EXPENSES REPORT',
  'NEGATIVE STOCKS REPORT',
  'STOCKS RE-ORDER REPORT',
  'TAX SUMMARY REPORT',
  'PURCHASES TAX REPORT',
  'SALES TAX REPORT',
];

const List reportGridIcons = [
  'assets/images/reports/operation_summary.png',
  'assets/images/reports/transactions_report.png',
  'assets/images/reports/pending_invoice.png',
  'assets/images/reports/sales_report.png',
  'assets/images/reports/purchases_report.png',
  'assets/images/reports/expenses_report.png',
  'assets/images/reports/negative_stocks_report.png',
  'assets/images/reports/stocks_reorder_report.png',
  'assets/images/reports/tax_summary_report.png',
  'assets/images/reports/purchases_tax_report.png',
  'assets/images/reports/sales_tax_report.png',
];

class ReportsGrid extends StatelessWidget {
  const ReportsGrid({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kGrey),
        ),
        child: InkWell(
          onTap: () async {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, routeOperationSummary);
                break;
              case 1:
                Navigator.pushNamed(context, routeTransactionReport);
                break;
              case 2:
                Navigator.pushNamed(context, routePendingInvoice);
                break;
              case 3:
                Navigator.pushNamed(context, routeSalesReport);
                break;
              case 4:
                Navigator.pushNamed(context, routePurchasesReport);
                break;
              case 5:
                Navigator.pushNamed(context, routeExpenseReport);
                break;
              case 6:
                Navigator.pushNamed(context, routeNegativeStockReport);
                break;
              case 7:
                Navigator.pushNamed(context, routeStockReOrderReport);
                break;
              case 8:
                Navigator.pushNamed(context, routeTaxSummaryReport);
                break;
              case 9:
                Navigator.pushNamed(context, routePurchasesTaxReport);
                break;
              case 10:
                Navigator.pushNamed(context, routeSalesTaxReport);
                break;
              case 11:
                break;
              default:
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: .4,
                  heightFactor: .4,
                  alignment: Alignment.center,
                  child: Image(image: AssetImage(reportGridIcons[index])),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: kPadding5,
                  child: Text(
                    reportGridName[index],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 6.sp,
                      fontWeight: FontWeight.bold,
                      color: kBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // child: GridTileBar(
          //   title: Image(
          //     image: AssetImage(
          //       reportGridIcons[index],
          //     ),
          //   ),
          //   subtitle: Center(
          //     child: Text(
          //       reportGridName[index],
          //       textAlign: TextAlign.center,
          //       maxLines: 2,
          //       style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: kBlack),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
