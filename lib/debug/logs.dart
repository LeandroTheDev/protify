import 'package:flutter/material.dart';
import 'package:protify/debug/time.dart';

class DebugLogs {
  static void print(String log) {
    debugPrint("${DebugTime.logDate()} $log");
  }
}
