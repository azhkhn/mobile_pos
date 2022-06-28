import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';

const List reportGridName = [
  'OPERATION SUMMARY',
  'PAYMENT REPORT',
  'PENDING PAYMENT',
  'SALES REPORT',
  'EXPENSE REPORT',
  'NEGATIVE STOCK REPORT',
  'STOCK RE-ORDER REPORT',
  'TAX SUMMARY REPORT',
  'PURCHASE TAX REPORT',
  'SALES TAX REPORT',
];

const List reportGridIcons = [
  'assets/images/reports/operation_summary.png',
  'assets/images/reports/payment_report.png',
  'assets/images/reports/pending_payment.png',
  'assets/images/reports/sales_report.png',
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
                  Navigator.pushNamed(context, routeExpenseReport);
                  break;
                case 5:
                  break;
                case 6:
                  break;
                case 7:
                  break;
                case 8:
                  break;
                case 9:
                  break;
                case 10:
                  break;
                default:
              }
            },
            child: GridTile(
              footer: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Text(
                  reportGridName[index],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: Image(
                image: AssetImage(
                  reportGridIcons[index],
                ),
              ),
            ),
          )),
    );
  }
}
