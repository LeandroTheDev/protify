import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/data/save_datas.dart';
import 'package:path/path.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';

class UserPreferences with ChangeNotifier {
  /// Returns a list of all games saved in device
  static Future<List> getItems() async {
    final items = jsonDecode(await SaveDatas.readData("items", "user") ?? "[]");
    return items;
  }

  /// Remove a specific game by the index, needs the items array to remove it, if context is not provided,
  /// the message asking will not appear
  static Future<List> removeItem(int index, List items, [context]) async {
    if (context != null) {
      final result = await DialogsModel.showQuestion(context, title: "Remove ${items[index]["ItemName"]}", content: "Do you wish to remove ${items[index]["ItemName"]} from your library?");
      if (!result) return items;
    }
    //Removing
    items.removeAt(index);
    //Update new data
    SaveDatas.saveData("items", "user", jsonEncode(items));
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

    StorageInstance.instanceDirectory = join(protifyDirectory, "data");
    DebugLogs.print("[Protify] Data directory: ${StorageInstance.instanceDirectory}");

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
      "DefaultShaderCompileDirectory": join(protifyDirectory, "shaders"),
      "StartWindowHeight": 600.0,
      "StartWindowWidth": 800.0,
      "DefaultCategory": "Uncategorized",
    };

    //Load preferences
    final Map storedPreference = jsonDecode(await SaveDatas.readData("preferences", "user") ?? "{}");
    // Updating Providers
    await userPreference.changeLanguage(storedPreference["Language"] ?? defaultData["Language"]);
    await connection.changeHttpAddress(storedPreference["HttpAddress"] ?? defaultData["HttpAddress"]);
    await connection.changeSocketAddress(storedPreference["SocketAddress"] ?? defaultData["SocketAddress"]);
    await userPreference.changeUsername(storedPreference["Username"] ?? defaultData["Username"]);
    await userPreference.changeProtifyDirectory(storedPreference["ProtifyDirectory"] ?? defaultData["ProtifyDirectory"]);
    await userPreference.changeDefaultGameInstallDirectory(storedPreference["DefaultGameInstallDirectory"] ?? defaultData["DefaultGameInstallDirectory"]);
    await userPreference.changeDefaultGameDirectory(storedPreference["DefaultGameDirectory"] ?? defaultData["DefaultGameDirectory"]);
    await userPreference.changeDefaultPrefixDirectory(storedPreference["DefaultPrefixDirectory"] ?? defaultData["DefaultPrefixDirectory"]);
    await userPreference.changeDefaultRuntimeDirectory(storedPreference["DefaultRuntimeDirectory"] ?? defaultData["DefaultRuntimeDirectory"]);
    await userPreference.changeDefaultWineprefixDirectory(storedPreference["DefaultWinePrefixDirectory"] ?? defaultData["DefaultWinePrefixDirectory"]);
    await userPreference.changeDefaultProtonDirectory(storedPreference["DefaultProtonDirectory"] ?? defaultData["DefaultProtonDirectory"]);
    await userPreference.changeSteamCompatibilityDirectory(storedPreference["SteamCompatibilityDirectory"] ?? defaultData["SteamCompatibilityDirectory"]);
    await userPreference.changeShaderCompileDirectory(storedPreference["DefaultShaderCompileDirectory"] ?? defaultData["DefaultShaderCompileDirectory"]);
    await userPreference.changeStartWindowHeight(storedPreference["StartWindowHeight"] ?? defaultData["StartWindowHeight"]);
    await userPreference.changeStartWindowWidth(storedPreference["StartWindowWidth"] ?? defaultData["StartWindowWidth"]);
    await userPreference.changeDefaultCategory(storedPreference["DefaultCategory"] ?? defaultData["DefaultCategory"]);
  }

  /// Save a preference option in data storage
  static Future savePreferencesInData({required String option, required value}) {
    //Reading preferences
    return SaveDatas.readData("preferences", "user").then(
      //Saving DefaultGameDirectory Preference
      (preferences) async {
        preferences ??= "{}";
        final updatedPreferences = jsonDecode(preferences);
        //Updating the value
        updatedPreferences[option] = value;
        //Saving the value
        return SaveDatas.saveData("preferences", "user", jsonEncode(updatedPreferences));
      },
    );
  }

  /// Update game category with a index and the category
  static Future<List> updateItemCategory(int index, String category) async {
    // Get all games
    final games = jsonDecode(await StorageInstance.getInstance().readValue("items", "user") ?? "[]");
    // Change the specific game index and his category
    games[index]["Category"] = category;
    // Save the new category
    StorageInstance().setValue("items", "user", jsonEncode(games));
    return games;
  }

  //Language
  String _language = "english";
  get language => _language;
  Future changeLanguage(String value) async => {
        _language = value,
        await savePreferencesInData(option: "Language", value: value),
      };

  //Username
  String _username = "";
  get username => _username;
  Future changeUsername(String value) async => {
        _username = value,
        await savePreferencesInData(option: "Username", value: value),
      };

  //Default Game Directory
  String _protifyDirectory = "";
  get protifyDirectory => _protifyDirectory;
  Future changeProtifyDirectory(String value) async => {
        _protifyDirectory = value,
        await savePreferencesInData(option: "ProtifyDirectory", value: value),
      };

  //Default Game Directory
  String _defaultGameInstallDirectory = "";
  get defaultGameInstallDirectory => _defaultGameInstallDirectory;
  Future changeDefaultGameInstallDirectory(String value) async => {
        _defaultGameInstallDirectory = value,
        await savePreferencesInData(option: "DefaultGameInstallDirectory", value: value),
      };

  //Default Game Directory
  String _defaultGameDirectory = "";
  get defaultGameDirectory => _defaultGameDirectory;
  Future changeDefaultGameDirectory(String value) async => {
        _defaultGameDirectory = value,
        await savePreferencesInData(option: "DefaultGameDirectory", value: value),
      };

  //Default Proton Directory
  String _defaultProtonDirectory = "";
  get defaultProtonDirectory => _defaultProtonDirectory;
  Future changeDefaultProtonDirectory(String value) async => {
        _defaultProtonDirectory = value,
        await savePreferencesInData(option: "DefaultProtonDirectory", value: value),
      };
  //Default Prefix Directory
  String _defaultPrefixDirectory = "";
  get defaultPrefixDirectory => _defaultPrefixDirectory;
  Future changeDefaultPrefixDirectory(String value) async => {
        _defaultPrefixDirectory = value,
        await savePreferencesInData(option: "DefaultPrefixDirectory", value: value),
      };
  //Default Prefix Directory
  String _defaultRuntimeDirectory = "";
  get defaultRuntimeDirectory => _defaultRuntimeDirectory;
  Future changeDefaultRuntimeDirectory(String value) async => {
        _defaultRuntimeDirectory = value,
        await savePreferencesInData(option: "DefaultRuntimeDirectory", value: value),
      };
  //Default Wine Prefix Directory
  String _defaultWineprefixDirectory = "";
  get defaultWineprefixDirectory => _defaultWineprefixDirectory;
  Future changeDefaultWineprefixDirectory(String value) async => {
        _defaultWineprefixDirectory = value,
        await savePreferencesInData(option: "DefaultWineprefixDirectory", value: value),
      };

  //Default Steam Compatibility Directory
  String _steamCompatibilityDirectory = "";
  get steamCompatibilityDirectory => _steamCompatibilityDirectory;
  Future changeSteamCompatibilityDirectory(String value) async => {
        _steamCompatibilityDirectory = value,
        await savePreferencesInData(option: "SteamCompatibilityDirectory", value: value),
      };

  //Default Steam Compatibility Directory
  String _shaderCompileDirectory = "";
  get defaultShaderCompileDirectory => _shaderCompileDirectory;
  Future changeShaderCompileDirectory(String value) async => {
        _shaderCompileDirectory = value,
        await savePreferencesInData(option: "DefaultShaderCompileDirectory", value: value),
      };

  //Start Window Height
  double _startWindowHeight = 600.0;
  get startWindowHeight => _startWindowHeight;
  Future changeStartWindowHeight(double value) async => {
        //Minimum Height
        if (value < 230) {value = 230},
        _startWindowHeight = value,
        await savePreferencesInData(option: "StartWindowHeight", value: value),
      };

  //Start Window Width
  double _startWindowWidth = 800.0;
  get startWindowWidth => _startWindowWidth;
  Future changeStartWindowWidth(double value) async => {
        //Minimum Width
        if (value < 230) {value = 230},
        _startWindowWidth = value,
        await savePreferencesInData(option: "StartWindowWidth", value: value),
      };

  //Default Category when load
  String _defaultCategory = "";
  get defaultCategory => _defaultCategory;
  Future changeDefaultCategory(String value) async => {
        _defaultCategory = value,
        await savePreferencesInData(option: "DefaultCategory", value: value),
      };

  static UserPreferences getProvider(BuildContext context) {
    return Provider.of<UserPreferences>(context, listen: false);
  }
}
