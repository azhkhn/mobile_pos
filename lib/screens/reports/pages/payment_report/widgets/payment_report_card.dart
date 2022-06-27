import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';

class PaymentReportCard extends StatelessWidget {
  PaymentReportCard({Key? key, required this.index, required this.transactionsModel}) : super(key: key);

  final int index;
  final TransactionsModel transactionsModel;

  final ValueNotifier<String?> personNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (transactionsModel.customerId != null) {
        final CustomerModel _customer = await CustomerDatabase.instance.getCustomerById(transactionsModel.customerId!);
        personNotifier.value = _customer.customer;
      } else if (transactionsModel.supplierId != null) {
        final SupplierModel _supplier = await SupplierDatabase.instance.getSupplierById(transactionsModel.supplierId!);
        personNotifier.value = _supplier.supplierName;
      } else if (transactionsModel.payBy != null) {
        personNotifier.value = transactionsModel.payBy;
      }
    });

    return Card(
      child: ListTile(
          dense: true,
          leading: CircleAvatar(
            backgroundColor: kTransparentColor,
            child: Text(
              '${index + 1}'.toString(),
              style: const TextStyle(fontSize: 12, color: kTextColor),
            ),
          ),
          title: ValueListenableBuilder(
              valueListenable: personNotifier,
              builder: (context, String? person, _) {
                return Text(
                  person ?? 'Unknown',
                  style: TextStyle(color: person == null ? kGrey : null),
                );
              }),
          subtitle: Row(
            children: [
              FittedBox(
                child: Text(
                  Converter.dateTimeFormatTransaction.format(DateTime.parse(transactionsModel.dateTime)),
                  style: kText12Lite,
                ),
              ),
              kWidth5,
              const Text(' ~ '),
              FittedBox(
                child: Text(
                  transactionsModel.salesReturnId != null
                      ? 'Sale Return'
                      : transactionsModel.purchaseReturnId != null
                          ? 'Purchase Return'
                          : transactionsModel.salesId != null
                              ? 'Sale'
                              : transactionsModel.purchaseId != null
                                  ? 'Purchase'
                                  : 'Expense',
                  style: kText12Black,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                transactionsModel.transactionType == 'Income'
                    ? '+' + Converter.currency.format(num.parse(transactionsModel.amount))
                    : '-' + Converter.currency.format(num.parse(transactionsModel.amount)),
                style: TextStyle(
                  color: transactionsModel.transactionType == 'Income' ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C),
                  fontSize: 12,
                ),
              ),
              // kWidth10,
              // Icon(Icons.verified_outlined, color: transactionsModel.transactionType == 'Income' ? kGreen : Colors.red),
            ],
          )),
    );
  }
}
