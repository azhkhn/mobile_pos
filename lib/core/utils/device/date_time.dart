import 'package:flutter/material.dart';

class DateTimeUtils {
  //========== Singleton Instance ==========
  DateTimeUtils._internal();
  static DateTimeUtils instance = DateTimeUtils._internal();
  factory DateTimeUtils() {
    return instance;
  }

  //========== Date Picker ==========
  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 30),
      ),
      lastDate: DateTime.now(),
    );
  }
}
