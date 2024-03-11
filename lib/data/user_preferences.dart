import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/data/save_datas.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences with ChangeNotifier {
  /// Returns a list of all games saved in device
  static Future<List> getItems() async {
    final items = jsonDecode(await SaveDatas.readData("items", "string") ?? "[]");
    return items;
  }

  /// Remove a specific game by the index, needs the games, if context is not provided,
  /// the message asking will not appear
  static Future<List> removeItem(int index, List items, [context]) async {
    if (context != null) {
      final result = await DialogsModel.showQuestion(context, title: "Remove Game", content: "Do you wish to remove this game from your library?");
      if (!result) return items;
    }
    //Removing
    items.removeAt(index);
    //Update new data
    await SaveDatas.saveData('items', jsonEncode(items));
    return items;
  }

  /// Load all preferences into provider context
  static Future loadPreference(BuildContext context) async {
    // Provider Declarations
    final UserPreferences userPreference = Provider.of<UserPreferences>(context, listen: false);
    final ConnectionModel connection = Provider.of<ConnectionModel>(context, listen: false);

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
      DialogsModel.showAlert(context, title: "Error", content: "Cannot find the protify_finder.txt in protify/lib, check if exists, or if /home/$username exists");
      protifyDirectory = "/home/$username/protify";
    }
    //Object Creation
    final Map defaultData = {
      "Language": "english",
      "HttpAddress": "localhost:6161",
      "SocketAddress": "localhost:6262",
      "Username": username,
      "ProtifyDirectory": protifyDirectory,
      "DefaultGameInstallDirectory": Platform.isLinux ? "/home/$username" : "\\",
      "DefaultGameDirectory": Platform.isLinux ? "/home/$username" : "\\",
      "DefaultPrefixDirectory": join(protifyDirectory, "prefixes"),
      "DefaultRuntimeDirectory": join(protifyDirectory, "runtimes"),
      "DefaultWinePrefixDirectory": join(protifyDirectory, "prefixes", "Wine"),
      "DefaultProtonDirectory": join(protifyDirectory, "protons"),
      "SteamCompatibilityDirectory": "/home/$username/.local/share/Steam",
      "StartWindowHeight": 600.0,
      "StartWindowWidth": 800.0,
      "DefaultCategory": "Uncategorized",
    };

    //Load preferences
    final Map storedPreference = jsonDecode(await SaveDatas.readData("preferences", "string") ?? "{}");
    // Updating Providers
    userPreference.changeLanguage(storedPreference["Language"] ?? defaultData["Language"]);
    connection.changeHttpAddress(storedPreference["HttpAddress"] ?? defaultData["HttpAddress"]);
    connection.changeSocketAddress(storedPreference["SocketAddress"] ?? defaultData["SocketAddress"]);
    userPreference.changeUsername(storedPreference["Username"] ?? defaultData["Username"]);
    userPreference.changeProtifyDirectory(storedPreference["ProtifyDirectory"] ?? defaultData["ProtifyDirectory"]);
    userPreference.changeDefaultGameInstallDirectory(storedPreference["DefaultGameInstallDirectory"] ?? defaultData["DefaultGameInstallDirectory"]);
    userPreference.changeDefaultGameDirectory(storedPreference["DefaultGameDirectory"] ?? defaultData["DefaultGameDirectory"]);
    userPreference.changeDefaultPrefixDirectory(storedPreference["DefaultPrefixDirectory"] ?? defaultData["DefaultPrefixDirectory"]);
    userPreference.changeDefaultRuntimeDirectory(storedPreference["DefaultRuntimeDirectory"] ?? defaultData["DefaultRuntimeDirectory"]);
    userPreference.changeDefaultWineprefixDirectory(storedPreference["DefaultWinePrefixDirectory"] ?? defaultData["DefaultWinePrefixDirectory"]);
    userPreference.changeDefaultProtonDirectory(storedPreference["DefaultProtonDirectory"] ?? defaultData["DefaultProtonDirectory"]);
    userPreference.changeSteamCompatibilityDirectory(storedPreference["SteamCompatibilityDirectory"] ?? defaultData["SteamCompatibilityDirectory"]);
    userPreference.changeStartWindowHeight(storedPreference["StartWindowHeight"] ?? defaultData["StartWindowHeight"]);
    userPreference.changeStartWindowWidth(storedPreference["StartWindowWidth"] ?? defaultData["StartWindowWidth"]);
    userPreference.changeDefaultCategory(storedPreference["DefaultCategory"] ?? defaultData["DefaultCategory"]);
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

  /// Update game category with a index and the category
  static Future<List> updateItemCategory(int index, String category) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // Get all games
    final games = jsonDecode(preferences.getString("items")!);
    // Change the specific game index and his category
    games[index]["Category"] = category;
    // Save the new category
    await preferences.setString("items", jsonEncode(games));
    return games;
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
  String _defaultGameInstallDirectory = "";
  get defaultGameInstallDirectory => _defaultGameInstallDirectory;
  void changeDefaultGameInstallDirectory(String value) => {
        _defaultGameInstallDirectory = value,
        savePreferencesInData(option: "DefaultGameInstallDirectory", value: value),
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

  //Default Category when load
  String _defaultCategory = "";
  get defaultCategory => _defaultCategory;
  void changeDefaultCategory(String value) => {
        _defaultCategory = value,
        savePreferencesInData(option: "DefaultCategory", value: value),
      };

  static UserPreferences getProvider(BuildContext context) {
    return Provider.of<UserPreferences>(context, listen: false);
  }
}
