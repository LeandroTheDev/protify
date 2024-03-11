import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/screens/game_log.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';

class LauncherModel {
  /// Generates the starting commands for running a game or program with Proton
  static String generateProtonStartCommand(BuildContext context, Map item) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    //Command Variables
    final String protonDirectory = join(preferences.defaultProtonDirectory, item["SelectedLauncher"] ?? "");
    final String protonWineDirectory;
    //Check Compatibility for protons
    if (Directory(join(protonDirectory, "dist")).existsSync()) {
      protonWineDirectory = join(protonDirectory, "dist", "bin", "wine64");
    } else {
      protonWineDirectory = join(protonDirectory, "files", "bin", "wine64");
    }

    final String protonExecutable = join(protonDirectory, "proton");
    final String itemPrefix = item["SelectedPrefix"] ?? join(preferences.defaultPrefixDirectory, item["ItemName"]);
    final String itemDirectory = item["SelectedItem"] ?? "";
    final String argumentsCommand = item["ArgumentsCommand"] ?? "";
    String checkEnviroments = 'STEAM_RUNTIME=3 STEAM_COMPAT_DATA_PATH="$itemPrefix" WINEPREFIX="${preferences.defaultWineprefixDirectory}" ';
    // Check Steam Compatibility
    if (item["EnableSteamCompatibility"] ?? false) {
      checkEnviroments += 'STEAM_COMPAT_CLIENT_INSTALL_PATH="${preferences.steamCompatibilityDirectory}" ';
    }
    // Check Shaders Compile NVIDIA
    if (item["EnableNvidiaCompile"] ?? false) {
      // Shaders folder
      final shadersDirectory = Directory('${preferences.protifyDirectory}/shaders');
      // Creates if not exist
      if (!shadersDirectory.existsSync()) {
        shadersDirectory.createSync();
      }
      // Game Shaders folder
      final shadersGameDirectory = Directory('${preferences.protifyDirectory}/shaders/${item["ItemName"]}');
      // Creates if not exist
      if (!shadersGameDirectory.existsSync()) {
        shadersGameDirectory.createSync();
      }
      // Creating the variable
      checkEnviroments += '__GL_SHADER_DISK_CACHE_PATH="${preferences.protifyDirectory}/shaders/${item["ItemName"]}" __GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 ';
    }
    // Add arguments throught the enviroments
    checkEnviroments += "$argumentsCommand ";

    // Sensive commands that can break game launch if not launched together
    if (item["SelectedReaperID"] != null) {
      checkEnviroments += '"${join("/home/bobs/.local/share/Steam/", "ubuntu12_32", "reaper")}" SteamLaunch AppId=${item["SelectedReaperID"]} -- ';
    }
    // Check Steam Wrapper
    if (item["EnableSteamWrapper"] ?? false) {
      checkEnviroments += '"${join(preferences.steamCompatibilityDirectory, "ubuntu12_32", "steam-launch-wrapper")}" -- ';
    }
    // Check Steam Runtime
    if (item["SelectedRuntime"] != null) {
      checkEnviroments += '"${join(item["SteamRuntimeDirectory"], "_v2-entry-point")}" --verb=waitforexitandrun -- ';
    }

    //Proton full command
    return '$checkEnviroments "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$itemDirectory"';
  }

  /// Generates the starting commands for running a game or program with Wine
  static String generateWineStartCommand(BuildContext context, Map item) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    // Check Steam Compatibility
    String checkEnviroments = "";
    // Check Shaders Compile NVIDIA
    if (item["EnableShadersCompileNVIDIA"]) {
      checkEnviroments += '__GL_SHADER_DISK_CACHE_PATH="${preferences.protifyDirectory}/shaders/${item["ItemName"]} __GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 ';
    }
    final String launchCommand = 'WINEPREFIX="${preferences.defaultWineprefixDirectory}" wine';
    final String argumentsCommand = item["ArgumentsCommand"] ?? "";
    final String itemDirectory = item["LaunchDirectory"] ?? "";
    return '$checkEnviroments $launchCommand $itemDirectory $argumentsCommand';
  }

  /// Generates the starting commands for running a game or program with Wine
  static String generateShellStartCommand(BuildContext context, Map item) {
    final String launchCommand = item["LaunchCommand"] ?? "";
    final String argumentsCommand = item["ArgumentsCommand"] ?? "";
    final String itemDirectory = item["LaunchDirectory"] ?? "";
    return '$launchCommand $itemDirectory $argumentsCommand';
  }

  /// Start the game and show the logs, if item is not specified it will get from the library provider instead
  static void launchItem(BuildContext context, [Map? item]) {
    late final Map selectedItem;
    DebugLogs.print("Launcher command called");
    final LibraryProvider libraryProvider = LibraryProvider.getProvider(context);
    if (libraryProvider.itemSelected == null && item == null) {
      DialogsModel.showAlert(
        context,
        title: "Error",
        content: "Cannot launch the game, the data is corrupted",
      );
      return;
    }
    if (item != null)
      selectedItem = item;
    else
      selectedItem = libraryProvider.itemSelected;

    // Create prefix folder if not exist
    checkPrefixExistence(context, selectedItem);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LaunchLogScreen(item: selectedItem);
      },
    );
  }

  /// Create the prefix folder if not exist
  static Future checkPrefixExistence(BuildContext context, Map item) async {
    UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    // No prefix if is not proton or wine
    if (item["SelectedLauncher"] == null) return;

    // Get prefix directory
    late String currentDirectory;
    if (item["SelectedPrefix"] == null)
      currentDirectory = join(preferences.defaultPrefixDirectory, item["ItemName"] ?? "Unknown");
    else
      currentDirectory = dirname(item["SelectedPrefix"]);

    // Checking if prefix folder exist
    if (!Directory(currentDirectory).existsSync()) {
      // Create
      await Directory(currentDirectory).create();
    }
    // Create the wine prefix
    if (!Directory(preferences.defaultWineprefixDirectory).existsSync()) {
      // Create
      await Directory(preferences.defaultWineprefixDirectory).create();
    }
  }
}
