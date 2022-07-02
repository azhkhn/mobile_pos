import 'package:flutter/material.dart';

class DateTimeUtils {
  //========== Singleton Instance ==========
  DateTimeUtils._internal();
  static DateTimeUtils instance = DateTimeUtils._internal();
  factory DateTimeUtils() {
    return instance;
  }

  //========== Date Picker ==========
  Future<DateTime?> datePicker(BuildContext context, {final DateTime? initDate, final bool endDate = false}) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: DateTime(1998, 04, 14),
      // firstDate: DateTime.now().subtract(
      //   const Duration(days: 30),
      // ),

      lastDate: DateTime.now(),
    );

    if (selectedDate != null && endDate) {
      final DateTime updated = selectedDate.add(const Duration(hours: 23, minutes: 59));
      return updated;
    } else {
      return selectedDate;
    }
  }
}
