import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/debug/time.dart';

class DebugLogs {
  /// If true then the logs will be reseted after next log
  static bool shouldResetLogs = true;

  static File? logFile;

  /// If in debug mode will print in the terminal, also will be printed in the protify/log if the storage has been loaded
  static void print(String log, {onlyFile = false}) {
    String message = "${DebugTime.logDate()} $log";

    // Check if storage instance exist
    if (StorageInstance.instanceDirectory != null) {
      // Create the file if necessary
      if (logFile == null) {
        logFile = File(join(StorageInstance.instanceDirectory!, "log"));

        // Remove old file if exist
        if (logFile!.existsSync()) {
          logFile!.deleteSync();
        }

        // First message creation
        logFile!.writeAsStringSync(message, mode: FileMode.write);
      } else {
        // Add new log message
        logFile!.writeAsStringSync("\n$message", mode: FileMode.append);
      }
    }

    // Show the mensage on debug terminal
    if (!onlyFile) debugPrint(message);
  }
}
