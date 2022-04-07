import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Converter {
  //Convert Amount to Currency depending on the locale
  static final NumberFormat currency =
      NumberFormat.currency(symbol: '₹', locale: "en_IN");

  //Force keyboard to input digits only
  static final List<FilteringTextInputFormatter> digitsOnly = [
    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
  ];

  // static final NumberFormat roundNumber = NumberFormat("###.0#", "en_US");

}
