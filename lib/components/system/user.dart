import 'dart:convert';
import 'dart:io';

import 'package:protify/debug/logs.dart';

class SystemUser {
  static Future<String> GetUsername() async {
    // Linux
    if (Platform.isLinux) {
      // Starting the proccess to get the username
      Process process = await Process.start('/bin/bash', ['-c', "whoami"]);
      // Getting the output from the process
      String output = await process.stdout.transform(utf8.decoder).join();

      // Removing the spaces if exist, strange behaviour from output
      if (output.endsWith('\n')) output = output.substring(0, output.length - 1);

      return output;
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
