import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:protify/components/system/user.dart';
import 'package:protify/debug/logs.dart';

class SystemDirectory {
  /// Retrieves the system home directory
  static Future<String> GetDefaultSystemDirectory() async {
    if (Platform.isLinux)
      return join("/home", await SystemUser.GetUsername());
    else if (Platform.isWindows) {
      // Invalid global variable check
      if (Platform.environment['USERPROFILE'] == null) {
        DebugLogs.print("[FATAL] Global variable not set: USERPROFILE, check your windows global paths");
        throw "Global variable not set: USERPROFILE, check your windows global paths";
      }
      return Platform.environment['USERPROFILE']!;
    } else {
      DebugLogs.print("[FATAL] Operational System is not compatible");
      throw "Operational System is not compatible";
    }
  }

  static Future<String> GetProtifyDirectory() async {
    // Linux
    if (Platform.isLinux) {
      // Getting the file directory
      Process process = await Process.start('/bin/bash', ['-c', 'find "${await GetDefaultSystemDirectory()}" -type f -name protify_finder.txt']);
      // Getting the directories finded by the process
      List directories = await process.stdout.transform(utf8.decoder).toList();
      // Check if the file exist
      if (directories.isEmpty) {
        DebugLogs.print("[FATAL] protify_finder.txt cannot be found, the installation is incorrect");
        throw "protify_finder.txt cannot be found, the installation is incorrect";
      }
      // Getting the first directory and removing one folder behind
      return dirname(dirname(directories[0]));
    }
    // Windows
    else if (Platform.isWindows)
      return Directory.current.path;
    else {
      DebugLogs.print("[FATAL] Operational System is not compatible");
      throw "Operational System is not compatible";
    }
  }
}
