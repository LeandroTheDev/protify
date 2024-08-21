import 'dart:convert';
import 'dart:io';

import 'package:protify/debug/logs.dart';

class SystemUser {
  static Future<String> GetUsername() async {
    // Linux
    if (Platform.isLinux) {
      // Getting username
      Process process = await Process.start('/bin/bash', ['-c', "whoami"]);
      return await process.stdout.transform(utf8.decoder).join();
    }
    // Windows
    else if (Platform.isWindows) {
      // Getting username
      Process process = await Process.start('whoami', []);
      String output = await process.stdout.transform(utf8.decoder).join();
      // Removing the enterprise if exist
      if (output.contains(r'\'))
        return output.split(r'\').last;
      else
        return output;
    } else {
      DebugLogs.print("[FATAL] Operational System is not compatible");
      throw "Operational System is not compatible";
    }
  }

  static GetUserDefaultDirectory() {}
}
