import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/routes/router.dart';

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
  'assets/images/reports/payment_report.png',
  'assets/images/reports/pending_payment.png',
  'assets/images/reports/sales_report.png',
  'assets/images/reports/purchase_report.png',
  'assets/images/reports/expense_report.png',
  'assets/images/reports/negative_stock_report.png',
  'assets/images/reports/stock_reorder_report.png',
  'assets/images/reports/tax_summary_report.png',
  'assets/images/reports/purchase_tax_report.png',
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20.0)),
          child: InkWell(
            onTap: () async {
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.pushNamed(context, routePaymentReport);
                  break;
                case 2:
                  Navigator.pushNamed(context, routePendingPayment);
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
            child: GridTileBar(
              title: Image(
                image: AssetImage(
                  reportGridIcons[index],
                ),
              ),
              subtitle: Center(
                child: Text(
                  reportGridName[index],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: kBlack),
                ),
              ),
            ),
          )),
    );
  }
}
