import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/device.dart';
import 'package:shop_ez/db/db_functions/customer/customer_database.dart';
import 'package:shop_ez/db/db_functions/supplier/supplier_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/model/supplier/supplier_model.dart';
import 'package:shop_ez/model/transactions/transactions_model.dart';

class TransactionsReportCard extends StatelessWidget {
  TransactionsReportCard({Key? key, required this.index, required this.transactionsModel}) : super(key: key);

  final int index;
  final TransactionsModel transactionsModel;

  final ValueNotifier<String?> personNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final bool isSmall = DeviceUtil.isSmall;
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
              style: isSmall ? kTextNo10 : kTextNo12,
            ),
          ),
          title: ValueListenableBuilder(
              valueListenable: personNotifier,
              builder: (context, String? person, _) {
                return Text(
                  person ?? 'Unknown',
                  style: isSmall ? kText12 : null,
                );
              }),
          subtitle: Text(
            Converter.dateTimeFormatTransaction.format(DateTime.parse(transactionsModel.dateTime)),
            style: isSmall ? kText10Lite : kText12Lite,
            textAlign: TextAlign.start,
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transactionsModel.transactionType == 'Income'
                    ? '+' + Converter.currency.format(num.parse(transactionsModel.amount))
                    : '-' + Converter.currency.format(num.parse(transactionsModel.amount)),
                style: TextStyle(
                  color: transactionsModel.transactionType == 'Income' ? kGreen900 : kRed900,
                  fontSize: isSmall ? 10 : 12,
                ),
              ),
              kHeight3,
              Text(
                transactionsModel.salesReturnId != null
                    ? ' ~ Sale Return'
                    : transactionsModel.purchaseReturnId != null
                        ? ' ~ Purchase Return'
                        : transactionsModel.salesId != null
                            ? ' ~ Sale'
                            : transactionsModel.purchaseId != null
                                ? ' ~ Purchase'
                                : ' ~ Expense',
                style: isSmall ? kText10Lite : kText12Lite,
              ),
              // Icon(Icons.verified_outlined, color: transactionsModel.transactionType == 'Income' ? kGreen : Colors.red),
            ],
          )),
    );
  }
}
