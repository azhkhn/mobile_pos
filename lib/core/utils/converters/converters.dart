import 'dart:convert';

import 'package:intl/intl.dart';

class Converter {
  //==================== Convert Amount to Currency depending on the locale ====================
  static final NumberFormat currency = NumberFormat.currency(symbol: '', locale: 'en_US');

  //==================== Round Number ====================
  static String amountRounderString(num amount) {
    final roundedAmount = num.parse(amount.toStringAsFixed(2));
    return roundedAmount.toString();
  }

  //==================== Round Number ====================
  static num amountRounder(num amount) {
    final roundedAmount = num.parse(amount.toStringAsFixed(2));
    return roundedAmount;
  }

  //==================== Compare Dates ====================
  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  //==================== Model to Json String ====================
  static String modelToJsonString(dynamic model) {
    return jsonEncode(model.toJson());
  }

  // static final NumberFormat roundNumber = NumberFormat("###.0#", "en_US");

  //==================== Convert Date and Time to readable Format ====================
  static final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  static final DateFormat dateFormatReverse = DateFormat('yyyy-MM-dd');
  static final DateFormat dateForDatabase = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final DateFormat dateFormatEInvoice = DateFormat('yyyy-MM-dd h:mm');
  static final DateFormat dateTimeFormatAmPm = DateFormat('dd-MM-yyyy h:mm a');
  static final DateFormat dateTimeFormatTransaction = DateFormat("dd MMMM yyyy 'at' hh:mm");
  static final DateFormat dateTimeFormat = DateFormat('dd-MM-yyyy, h:mm');
  static final DateFormat dateTimeForFileName = DateFormat('dd-MM-yyyy-h~mma');
}
