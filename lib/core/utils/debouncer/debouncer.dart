import 'package:flutter/foundation.dart';
import 'dart:async';

class Debouncer {
  final int milliseconds;
  static Timer? timer;
  Debouncer({this.milliseconds = 1 * 300});

  run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
