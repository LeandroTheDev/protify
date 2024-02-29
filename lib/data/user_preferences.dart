import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:protify/components/connection.dart';
import 'package:protify/components/widgets.dart';
import 'package:protify/data/save_datas.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UserPreferences with ChangeNotifier {
  /// Returns a list of all games saved in device
  static Future<List> getGames() async {
    final games = jsonDecode(await SaveDatas.readData("games", "string") ?? "[]");
    return games;
  }

  /// Remove a specific game by the index, needs the games, if context is not provided,
  /// the message asking will not appear
  static Future<List> removeGame(int index, List games, [context]) async {
    if (context != null) {
      final result = await Widgets.showQuestion(context, title: "Remove Game", content: "Do you wish to remove this game from your library?");
      if (!result) return games;
    }
    //Removing
    games.removeAt(index);
    //Update new data
    await SaveDatas.saveData('games', jsonEncode(games));
    return games;
  }

  /// Load all preferences into provider context
  static Future loadPreference(BuildContext context) async {
    // ignore: use_build_context_synchronously
    final UserPreferences userPreference = Provider.of<UserPreferences>(context, listen: false);
    final Connection connection = Provider.of<Connection>(context, listen: false);
    final Map preferences = jsonDecode(await SaveDatas.readData("preferences", "string") ?? "{}");

    //Default variables
    final username = Platform.isLinux ? split(current)[2] : "Protify User";
    late final List protifyDirectoryResult;
    if (Platform.isLinux) {
      final protifyDirectoryProcess = await Process.start('/bin/bash', ['-c', 'find "/home/$username/" -type f -name protify_finder.txt']);
      protifyDirectoryResult = await protifyDirectoryProcess.stdout.transform(utf8.decoder).toList();
    } else {
      protifyDirectoryResult = [current];
    }
    String protifyDirectory;
    if (protifyDirectoryResult.isNotEmpty) {
      protifyDirectory = Platform.isLinux ? dirname(dirname(protifyDirectoryResult[0])) : protifyDirectoryResult[0];
      //Check multiples protify_finder files
      while (true) {
        //Remove others protify_finders
        if (protifyDirectory.contains('\n')) {
          //+1 remove also the lane break
          protifyDirectory = protifyDirectory.substring(protifyDirectory.indexOf('\n') + 1);
        } else {
          //Everthings ok
          break;
        }
      }
    } else {
      // ignore: use_build_context_synchronously
      Widgets.showAlert(context, title: "Error", content: "Cannot find the protify_finder.txt in protify/lib, check if exists, or if /home/$username exists");
      protifyDirectory = "/home/$username/protify";
    }
    const defaultServerAddress = "localhost:6161";
    final defaultGameDirectory = Platform.isLinux ? "/home/$username" : "\\";
    final defaultPrefixDirectory = join(protifyDirectory, "prefixes");
    final defaultRuntimeDirectory = join(protifyDirectory, "runtimes");
    final defaultWinePrefixDirectory = join(defaultPrefixDirectory, "Wine");
    final defaultProtonDirectory = join(protifyDirectory, "protons");
    const steamCompatibilityDirectory = "~/.local/share/Steam";
    const defaultLanguage = "english";

    // Check if preferences is empty
    if (preferences.isEmpty) {
      //Object Creation
      final Map saveData = {
        "Language": defaultLanguage,
        "ServerAddress": defaultServerAddress,
        "Username": username,
        "ProtifyDirectory": protifyDirectory,
        "DefaultGameDirectory": defaultGameDirectory,
        "DefaultPrefixDirectory": defaultPrefixDirectory,
        "DefaultRuntimeDirectory": defaultRuntimeDirectory,
        "DefaultWinePrefixDirectory": defaultWinePrefixDirectory,
        "DefaultProtonDirectory": defaultProtonDirectory,
        "SteamCompatibilityDirectory": steamCompatibilityDirectory,
        "StartWindowHeight": 600.0,
        "StartWindowWidth": 800.0,
      };
      //Saving Preferences
      await SaveDatas.saveData("preferences", jsonEncode(saveData));
      //Updating Providers
      userPreference.changeLanguage(saveData["Language"]);
      connection.changeServerAddress(saveData["ServerAddress"]);
      userPreference.changeUsername(saveData["Username"]);
      userPreference.changeProtifyDirectory(saveData["ProtifyDirectory"]);
      userPreference.changeDefaultGameDirectory(saveData["DefaultGameDirectory"]);
      userPreference.changeDefaultPrefixDirectory(saveData["DefaultPrefixDirectory"]);
      userPreference.changeDefaultRuntimeDirectory(saveData["DefaultRuntimeDirectory"]);
      userPreference.changeDefaultWineprefixDirectory(saveData["DefaultWinePrefixDirectory"]);
      userPreference.changeDefaultProtonDirectory(saveData["DefaultProtonDirectory"]);
      userPreference.changeSteamCompatibilityDirectory(saveData["SteamCompatibilityDirectory"]);
      userPreference.changeStartWindowHeight(saveData["StartWindowHeight"]);
      userPreference.changeStartWindowWidth(saveData["StartWindowWidth"]);
      return;
    }
    // Updating Providers
    userPreference.changeLanguage(preferences["Language"] ?? defaultLanguage);
    connection.changeServerAddress(preferences["ServerAddress"] ?? defaultServerAddress);
    userPreference.changeUsername(preferences["Username"] ?? username);
    userPreference.changeProtifyDirectory(preferences["ProtifyDirectory"] ?? protifyDirectory);
    userPreference.changeDefaultGameDirectory(preferences["DefaultGameDirectory"] ?? defaultGameDirectory);
    userPreference.changeDefaultPrefixDirectory(preferences["DefaultPrefixDirectory"] ?? defaultPrefixDirectory);
    userPreference.changeDefaultRuntimeDirectory(preferences["DefaultRuntimeDirectory"] ?? defaultRuntimeDirectory);
    userPreference.changeDefaultWineprefixDirectory(preferences["DefaultWinePrefixDirectory"] ?? defaultWinePrefixDirectory);
    userPreference.changeDefaultProtonDirectory(preferences["DefaultProtonDirectory"] ?? defaultProtonDirectory);
    userPreference.changeSteamCompatibilityDirectory(preferences["SteamCompatibilityDirectory"] ?? steamCompatibilityDirectory);
    userPreference.changeStartWindowHeight(preferences["StartWindowHeight"] ?? 600.0);
    userPreference.changeStartWindowWidth(preferences["StartWindowWidth"] ?? 800.0);
  }

  /// Save a preference option in data storage
  static void savePreferencesInData({required String option, required value}) {
    //Reading preferences
    SaveDatas.readData("preferences", "string").then(
      //Saving DefaultGameDirectory Preference
      (preferences) {
        final updatedPreferences = jsonDecode(preferences);
        //Updating the value
        updatedPreferences[option] = value;
        //Saving the value
        SaveDatas.saveData("preferences", jsonEncode(updatedPreferences));
      },
    );
  }

  //Language
  String _language = "english";
  get language => _language;
  void changeLanguage(String value) => {
        _language = value,
        savePreferencesInData(option: "Language", value: value),
      };

  //Username
  String _username = "";
  get username => _username;
  void changeUsername(String value) => {
        _username = value,
        savePreferencesInData(option: "Username", value: value),
      };

  //Default Game Directory
  String _protifyDirectory = "";
  get protifyDirectory => _protifyDirectory;
  void changeProtifyDirectory(String value) => {
        _protifyDirectory = value,
        savePreferencesInData(option: "ProtifyDirectory", value: value),
      };

  //Default Game Directory
  String _defaultGameDirectory = "";
  get defaultGameDirectory => _defaultGameDirectory;
  void changeDefaultGameDirectory(String value) => {
        _defaultGameDirectory = value,
        savePreferencesInData(option: "DefaultGameDirectory", value: value),
      };

  //Default Proton Directory
  String _defaultProtonDirectory = "";
  get defaultProtonDirectory => _defaultProtonDirectory;
  void changeDefaultProtonDirectory(String value) => {
        _defaultProtonDirectory = value,
        savePreferencesInData(option: "DefaultProtonDirectory", value: value),
      };
  //Default Prefix Directory
  String _defaultPrefixDirectory = "";
  get defaultPrefixDirectory => _defaultPrefixDirectory;
  void changeDefaultPrefixDirectory(String value) => {
        _defaultPrefixDirectory = value,
        savePreferencesInData(option: "DefaultPrefixDirectory", value: value),
      };
  //Default Prefix Directory
  String _defaultRuntimeDirectory = "";
  get defaultRuntimeDirectory => _defaultRuntimeDirectory;
  void changeDefaultRuntimeDirectory(String value) => {
        _defaultRuntimeDirectory = value,
        savePreferencesInData(option: "DefaultRuntimeDirectory", value: value),
      };
  //Default Wine Prefix Directory
  String _defaultWineprefixDirectory = "";
  get defaultWineprefixDirectory => _defaultWineprefixDirectory;
  void changeDefaultWineprefixDirectory(String value) => {
        _defaultWineprefixDirectory = value,
        savePreferencesInData(option: "DefaultWineprefixDirectory", value: value),
      };

  //Default Steam Compatibility Directory
  String _steamCompatibilityDirectory = "";
  get steamCompatibilityDirectory => _steamCompatibilityDirectory;
  void changeSteamCompatibilityDirectory(String value) => {
        _steamCompatibilityDirectory = value,
        savePreferencesInData(option: "SteamCompatibilityDirectory", value: value),
      };

  //Start Window Height
  double _startWindowHeight = 600.0;
  get startWindowHeight => _startWindowHeight;
  void changeStartWindowHeight(double value) => {
        //Minimum Height
        if (value < 230) {value = 230},
        _startWindowHeight = value,
        savePreferencesInData(option: "StartWindowHeight", value: value),
      };

  //Start Window Width
  double _startWindowWidth = 800.0;
  get startWindowWidth => _startWindowWidth;
  void changeStartWindowWidth(double value) => {
        //Minimum Width
        if (value < 230) {value = 230},
        _startWindowWidth = value,
        savePreferencesInData(option: "StartWindowWidth", value: value),
      };
}
