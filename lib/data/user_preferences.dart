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
    // Check if preferences is empty
    if (preferences.isEmpty) {
      final username = Platform.isLinux ? split(current)[3] : null;
      //Object Creation
      final Map saveData = {
        "Username": username,
        "DefaultGameDirectory": Platform.isLinux ? join("/", "home", username!) : "C:\\",
        "RunBackground": true,
      };
      //Saving Preferences
      await SaveDatas.saveData("preferences", jsonEncode(saveData));
      //Updating Preferences
      userPreference.changeUsername(saveData["Username"]);
      userPreference.changeDefaultGameDirectory(saveData["DefaultGameDirectory"]);
      return;
    }
    final defaultDirectory = Platform.isLinux ? "/" : "C:\\";
    // Updating Providers
    userPreference.changeUsername(preferences["Username"] ?? "");
    print(preferences["DefaultGameDirectory"]);
    userPreference.changeDefaultGameDirectory(preferences["DefaultGameDirectory"] ?? defaultDirectory);
  }

  //Username
  String _username = "";
  get username => _username;
  void changeUsername(String value) => _username = value;

  //Default Game Directory
  String _defaultGameDirectory = "";
  get defaultGameDirectory => _defaultGameDirectory;
  void changeDefaultGameDirectory(String value) => {
        _defaultGameDirectory = value,
        //Reading preferences
        SaveDatas.readData("preferences", "string").then(
          //Saving DefaultGameDirectory Preference
          (preferences) {
            final updatedPreferences = jsonDecode(preferences);
            SaveDatas.saveData("preferences", jsonEncode(updatedPreferences["DefaultGameDirectory"]));
          },
        ),
      };
}
