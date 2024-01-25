import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
    final Map preferences = jsonDecode(await SaveDatas.readData("preferences", "string") ?? "{}");

    //Default variables
    final username = Platform.isLinux ? split(current)[3] : null;
    final defaultGameDirectory = Platform.isLinux ? "~/" : "\\";
    final defaultPrefixDirectory = join(current, "prefixes");
    final steamCompatibilityDirectory = "~/.local/share/Steam";

    // Check if preferences is empty
    if (preferences.isEmpty) {
      //Object Creation
      final Map saveData = {
        "Username": username,
        "DefaultGameDirectory": defaultGameDirectory,
        "DefaultPrefixDirectory": defaultPrefixDirectory,
        "SteamCompatibilityDirectory": steamCompatibilityDirectory,
        "StartWindowHeight": 600.0,
        "StartWindowWidth": 800.0,
      };
      //Saving Preferences
      await SaveDatas.saveData("preferences", jsonEncode(saveData));
      //Updating Preferences
      userPreference.changeUsername(saveData["Username"] ?? "Protify User");
      userPreference.changeDefaultGameDirectory(saveData["DefaultGameDirectory"]);
      userPreference.changeDefaultPrefixDirectory(saveData["DefaultPrefixDirectory"]);
      userPreference.changeSteamCompatibilityDirectory(saveData["SteamCompatibilityDirectory"]);
      userPreference.changeStartWindowHeight(saveData["StartWindowHeight"]);
      userPreference.changeStartWindowWidth(saveData["StartWindowWidth"]);
      return;
    }
    // Updating Providers
    userPreference.changeUsername(preferences["Username"] ?? "");
    userPreference.changeDefaultGameDirectory(preferences["DefaultGameDirectory"] ?? defaultGameDirectory);
    userPreference.changeDefaultPrefixDirectory(preferences["DefaultPrefixDirectory"] ?? defaultPrefixDirectory);
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

  //Username
  String _username = "";
  get username => _username;
  void changeUsername(String value) => {
        _username = value,
        savePreferencesInData(option: "Username", value: value),
      };

  //Default Game Directory
  String _defaultGameDirectory = "";
  get defaultGameDirectory => _defaultGameDirectory;
  void changeDefaultGameDirectory(String value) => {
        _defaultGameDirectory = value,
        savePreferencesInData(option: "DefaultGameDirectory", value: value),
      };

  //Default Prefix Directory
  String _defaultPrefixDirectory = "";
  get defaultPrefixDirectory => _defaultPrefixDirectory;
  void changeDefaultPrefixDirectory(String value) => {
        _defaultPrefixDirectory = value,
        savePreferencesInData(option: "DefaultPrefixDirectory", value: value),
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
