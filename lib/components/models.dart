import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/screens/game_log.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class Models {
  /// Generates the starting commands for running a game or program with Proton
  static String generateProtonStartCommand(BuildContext context, Map game) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    //Command Variables
    final String protonDirectory = game["ProtonDirectory"] ?? "";
    final String protonWineDirectory;
    // Check if want to use the proton script or default wine from proton
    if (game["EnableProtonScript"]) {
      protonWineDirectory = join(protonDirectory, "proton");
    }
    // Using default wine
    else {
      //Check Compatibility for protons
      if (Directory(join(protonDirectory, "dist")).existsSync()) {
        protonWineDirectory = join(protonDirectory, "dist", "bin", "wine64");
      } else {
        protonWineDirectory = join(protonDirectory, "files", "bin", "wine64");
      }
    }
    final String protonExecutable = join(protonDirectory, "proton");
    final String gamePrefix = game["PrefixFolder"];
    final String gameDirectory = game["LaunchDirectory"] ?? "";
    final String argumentsCommand = game["ArgumentsCommand"] ?? "";
    String checkEnviroments = 'STEAM_RUNTIME=3 STEAM_COMPAT_DATA_PATH="$gamePrefix" WINEPREFIX="${preferences.defaultWineprefixDirectory}" ';
    // Check Steam Compatibility
    if (game["EnableSteamCompatibility"]) {
      checkEnviroments += 'STEAM_COMPAT_CLIENT_INSTALL_PATH="${preferences.steamCompatibilityDirectory}" ';
    }
    // Check Shaders Compile NVIDIA
    if (game["EnableShadersCompileNVIDIA"] ?? false) {
      // Shaders folder
      final shadersDirectory = Directory('${preferences.protifyDirectory}/shaders');
      if (!shadersDirectory.existsSync()) {
        shadersDirectory.createSync();
      }
      // Game Shaders folder
      final shadersGameDirectory = Directory('${preferences.protifyDirectory}/shaders/${game["Title"]}');
      if (!shadersGameDirectory.existsSync()) {
        shadersGameDirectory.createSync();
      }
      checkEnviroments += '__GL_SHADER_DISK_CACHE_PATH="${preferences.protifyDirectory}/shaders/${game["Title"]}" __GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 ';
    }
    // Add arguments throught the enviroments
    checkEnviroments += "$argumentsCommand ";

    // Sensive commands that can break game launch if not launched together
    if (game["SteamReaperAppId"] != null) {
      checkEnviroments += '"${join(preferences.steamCompatibilityDirectory, "ubuntu12_32", "reaper")}" SteamLaunch AppId=${game["SteamReaperAppId"]} -- ';
    }
    // Check Steam Wrapper
    if (game["EnableSteamWrapper"] ?? false) {
      checkEnviroments += '"${join(preferences.steamCompatibilityDirectory, "ubuntu12_32", "steam-launch-wrapper")}" -- ';
    }
    // Check Steam Runtime
    if (game["SteamRuntimeDirectory"] != null) {
      checkEnviroments += '"${join(game["SteamRuntimeDirectory"], "_v2-entry-point")}" --verb=waitforexitandrun -- ';
    }

    //Proton full command
    return '$checkEnviroments "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$gameDirectory"';
  }

  /// Generates the starting commands for running a game or program with Wine
  static String generateWineStartCommand(BuildContext context, Map game) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    // Check Steam Compatibility
    String checkEnviroments = "";
    if (game["EnableSteamCompatibility"]) {
      checkEnviroments += 'STEAM_COMPAT_CLIENT_INSTALL_PATH="${preferences.steamCompatibilityDirectory}" ';
    }
    // Check Shaders Compile NVIDIA
    if (game["EnableShadersCompileNVIDIA"]) {
      checkEnviroments += '__GL_SHADER_DISK_CACHE_PATH="${preferences.protifyDirectory}/shaders/${game["Title"]} __GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 ';
    }
    final String launchCommand;
    if (game["ProtonDirectory"] == "wine") {
      launchCommand = 'WINEPREFIX="${preferences.defaultWineprefixDirectory}" wine';
    } else {
      launchCommand = game["LaunchCommand"] ?? "";
    }
    final String argumentsCommand = game["ArgumentsCommand"] ?? "";
    final String gameDirectory = game["LaunchDirectory"] ?? "";
    return '$checkEnviroments $launchCommand $gameDirectory $argumentsCommand';
  }

  /// Start the game and show the logs
  static void startGame({required BuildContext context, required Map game}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GameLogScreen(game: game);
      },
    );
  }

  /// Will check for dependencies for some necessary librarys in linux
  static void checkLinuxDependencies() {}
}
