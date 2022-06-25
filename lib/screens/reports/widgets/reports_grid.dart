import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';

const List homeGridName = [
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
                  break;
                case 3:
                  break;
                case 4:
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
                default:
              }
            },
            child: GridTile(
              footer: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  homeGridName[index],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              child: const Icon(
                Icons.flag,
                size: 40,
              ),
            ),
          )),
    );
  }
}
