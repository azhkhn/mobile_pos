import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/model/expense/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({Key? key, required this.index, required this.expense}) : super(key: key);

  final int index;
  final ExpenseModel expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          dense: true,
          leading: CircleAvatar(
            backgroundColor: kTransparentColor,
            child: Text(
              '${index + 1}'.toString(),
              style: const TextStyle(fontSize: 12, color: kTextColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          title: Text(
            expense.expenseTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Converter.dateTimeFormatTransaction.format(DateTime.parse(expense.date)),
              style: kText12Lite,
            ),
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                child: Text(
                  expense.payBy,
                  style: kText12,
                ),
              ),
              Text(
                '-' + Converter.currency.format(num.parse(expense.amount)),
                style: const TextStyle(
                  color: kRed900,
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
