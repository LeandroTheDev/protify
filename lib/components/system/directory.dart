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
      // First ---> Last, to be searched
      List<String> directoriesToSearch = [join(Directory.current.path, "lib"), await GetDefaultSystemDirectory()];

      // Search for the file, if not finded search for the next directory, if not find anyone, crash it
      for (int i = 0; i < directoriesToSearch.length; i++) {
        // Getting the file directory
        Process process = await Process.start('/bin/bash', ['-c', 'find "${directoriesToSearch[i]}" -type f -name protify_finder.txt']);
        // Getting the directories finded by the process
        List directories = await process.stdout.transform(utf8.decoder).toList();
        // Check if the file exist
        if (directories.isEmpty) {
          // No directories has been found
          if (i == directoriesToSearch.length - 1) {
            DebugLogs.print("[FATAL] protify_finder.txt cannot be found, the installation is incorrect");
            throw "protify_finder.txt cannot be found, the installation is incorrect";
          }
          continue;
        }
        // Getting the first directory and removing one folder behind
        else
          return dirname(dirname(directories[0]));
      }
      // Dart does not undestand the ``if (i == directoriesToSearch.length - 1)``
      // so we need to explicity return any string here to the compiler understand
      throw "Something impossible just happened...";
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
