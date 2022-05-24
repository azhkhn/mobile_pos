import 'package:intl/intl.dart';

class Converter {
  //==================== Convert Amount to Currency depending on the locale ====================
  static final NumberFormat currency = NumberFormat.currency(symbol: '₹', locale: "en_IN");

  //==================== Round Number ====================
  static String amountRounder(num amount) {
    final roundedAmount = num.parse(amount.toStringAsFixed(2));
    return roundedAmount.toString();
  }

  // static final NumberFormat roundNumber = NumberFormat("###.0#", "en_US");

  //==================== Convert Date and Time to readable Format ====================
  static final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  static final DateFormat dateFormatReverse = DateFormat('yyyy-MM-dd');
  static final DateFormat dateTimeFormatAmPm = DateFormat('dd-MM-yyyy, h:mm a');
  static final DateFormat dateTimeFormat = DateFormat('dd-MM-yyyy, h:mm');
}
