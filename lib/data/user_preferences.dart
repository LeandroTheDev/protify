import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/system/directory.dart';
import 'package:protify/components/system/user.dart';
import 'package:protify/data/save_datas.dart';
import 'package:path/path.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';

class UserPreferences with ChangeNotifier {
  static bool protifyExecutableExist = false;

  /// Returns a list of all games saved in device
  static Future<List> getItems() async {
    final items = jsonDecode(await SaveDatas.readData("items", "user") ?? "[]");
    return items;
  }

  /// Remove a specific game by the index, needs the items array to remove it, if context is not provided,
  /// the message asking will not appear
  static Future<List> removeItem(int index, List items, [BuildContext? context]) async {
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
    DebugLogs.print("[Protify] Loading preferences...");

    // Provider Declarations
    final UserPreferences userPreference = Provider.of<UserPreferences>(context, listen: false);
    final ConnectionModel connection = Provider.of<ConnectionModel>(context, listen: false);

    // Default variables
    final String userDirectory = await SystemUser.GetUserDefaultDirectory().catchError((error) {
      Navigator.pop(context);
      DialogsModel.showAlert(
        context,
        title: "ERROR",
        content: "Cannot get the default directory, reason: $error",
      );
      throw "Cannot get the default directory, reason: $error";
    });
    final String username = await SystemUser.GetUsername().catchError((error) {
      // This will not work because the loading dialog will cover it
      DialogsModel.showAlert(context, title: "ERROR", content: "Cannot get the system username, reason: $error");
      return "Protify User";
    });
    final String protifyDirectory = await SystemDirectory.GetProtifyDirectory().catchError((error) async {
      // This will not work because the loading dialog will cover it
      // DialogsModel.showAlert(context, title: "ERROR", content: "Cannot get the protify directory, reason: $error");
      return userDirectory;
    });

    DebugLogs.print("[Protify] Directories has been read");

    StorageInstance.instanceDirectory = join(protifyDirectory, "data");
    DebugLogs.print("[Protify] Protify directory: $protifyDirectory, Data directory: ${StorageInstance.instanceDirectory}");

    // Default datas
    final Map defaultData = {
      "Language": "english",
      "HttpAddress": "localhost:6161",
      "Username": username,
      "ProtifyDirectory": protifyDirectory,
      "DefaultGameInstallDirectory": userDirectory,
      "DefaultGameDirectory": userDirectory,
      "DefaultPrefixDirectory": join(protifyDirectory, "prefixes"),
      "DefaultRuntimeDirectory": join(protifyDirectory, "runtimes"),
      "DefaultWinePrefixDirectory": join(protifyDirectory, "prefixes", "Wine"),
      "DefaultProtonDirectory": join(protifyDirectory, "protons"),
      "SteamCompatibilityDirectory": "/home/$username/.local/share/Steam",
      "EACRuntimeDirectory": join(protifyDirectory, "runtimes", "Proton EasyAntiCheat Runtime"),
      "DefaultShaderCompileDirectory": join(protifyDirectory, "shaders"),
      "DefaultCategory": "Uncategorized",
      "IgnoreProtifyExecutable": false,
    };

    DebugLogs.print("[Protify] Reading stored preferences...");

    //Load preferences
    final Map storedPreference = jsonDecode(await SaveDatas.readData("preferences", "user") ?? "{}");

    DebugLogs.print("[Protify] Preferences has been read, starting to create preferences from default or reading into memory");
    // Updating Providers
    await userPreference.changeLanguage(storedPreference["Language"] ?? defaultData["Language"], false);
    await connection.changeHttpAddress(storedPreference["HttpAddress"] ?? defaultData["HttpAddress"], false);
    await userPreference.changeUsername(storedPreference["Username"] ?? defaultData["Username"], false);
    await userPreference.changeProtifyDirectory(storedPreference["ProtifyDirectory"] ?? defaultData["ProtifyDirectory"], false);
    await userPreference.changeDefaultGameInstallDirectory(storedPreference["DefaultGameInstallDirectory"] ?? defaultData["DefaultGameInstallDirectory"], false);
    await userPreference.changeDefaultGameDirectory(storedPreference["DefaultGameDirectory"] ?? defaultData["DefaultGameDirectory"], false);
    await userPreference.changeDefaultPrefixDirectory(storedPreference["DefaultPrefixDirectory"] ?? defaultData["DefaultPrefixDirectory"], false);
    await userPreference.changeDefaultRuntimeDirectory(storedPreference["DefaultRuntimeDirectory"] ?? defaultData["DefaultRuntimeDirectory"], false);
    await userPreference.changeDefaultWineprefixDirectory(storedPreference["DefaultWinePrefixDirectory"] ?? defaultData["DefaultWinePrefixDirectory"], false);
    await userPreference.changeDefaultProtonDirectory(storedPreference["DefaultProtonDirectory"] ?? defaultData["DefaultProtonDirectory"], false);
    await userPreference.changeSteamCompatibilityDirectory(storedPreference["SteamCompatibilityDirectory"] ?? defaultData["SteamCompatibilityDirectory"], false);
    await userPreference.changeEacRuntimeDefaultDirectory(storedPreference["EACRuntimeDirectory"] ?? defaultData["EACRuntimeDirectory"], false);
    await userPreference.changeShaderCompileDirectory(storedPreference["DefaultShaderCompileDirectory"] ?? defaultData["DefaultShaderCompileDirectory"], false);
    await userPreference.changeDefaultCategory(storedPreference["DefaultCategory"] ?? defaultData["DefaultCategory"], false);
    await userPreference.changeIgnoreProtifyExecutable(storedPreference["IgnoreProtifyExecutable"] ?? defaultData["IgnoreProtifyExecutable"], false);
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

        DebugLogs.print("[Configuration] Saving: $option, with value of $value", onlyFile: true);

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
  Future changeLanguage(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Language has been changed to: $value", onlyFile: true),
        _language = value,
        if (save) await savePreferencesInData(option: "Language", value: value),
      };

  //Username
  String _username = "";
  get username => _username;
  Future changeUsername(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Username has been changed to: $value", onlyFile: true),
        _username = value,
        if (save) await savePreferencesInData(option: "Username", value: value),
      };

  //Default Game Directory
  String _protifyDirectory = "";
  get protifyDirectory => _protifyDirectory;
  Future changeProtifyDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Protify Directory has been changed to: $value", onlyFile: true),
        _protifyDirectory = value,
        if (save) await savePreferencesInData(option: "ProtifyDirectory", value: value),
      };

  //Default Game Directory
  String _defaultGameInstallDirectory = "";
  get defaultGameInstallDirectory => _defaultGameInstallDirectory;
  Future changeDefaultGameInstallDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Game Install Directory has been changed to: $value", onlyFile: true),
        _defaultGameInstallDirectory = value,
        if (save) await savePreferencesInData(option: "DefaultGameInstallDirectory", value: value),
      };

  //Default Game Directory
  String _defaultGameDirectory = "";
  get defaultGameDirectory => _defaultGameDirectory;
  Future changeDefaultGameDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Game Directory has been changed to: $value", onlyFile: true),
        _defaultGameDirectory = value,
        if (save) await savePreferencesInData(option: "DefaultGameDirectory", value: value),
      };

  //Default Proton Directory
  String _defaultProtonDirectory = "";
  get defaultProtonDirectory => _defaultProtonDirectory;
  Future changeDefaultProtonDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Proton Directory has been changed to: $value", onlyFile: true),
        _defaultProtonDirectory = value,
        if (save) await savePreferencesInData(option: "DefaultProtonDirectory", value: value),
      };
  //Default Prefix Directory
  String _defaultPrefixDirectory = "";
  get defaultPrefixDirectory => _defaultPrefixDirectory;
  Future changeDefaultPrefixDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Prefix Directory has been changed to: $value", onlyFile: true),
        _defaultPrefixDirectory = value,
        if (save) await savePreferencesInData(option: "DefaultPrefixDirectory", value: value),
      };
  //Default Prefix Directory
  String _defaultRuntimeDirectory = "";
  get defaultRuntimeDirectory => _defaultRuntimeDirectory;
  Future changeDefaultRuntimeDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Runtime Directory has been changed to: $value", onlyFile: true),
        _defaultRuntimeDirectory = value,
        if (save) await savePreferencesInData(option: "DefaultRuntimeDirectory", value: value),
      };
  //Default Wine Prefix Directory
  String _defaultWineprefixDirectory = "";
  get defaultWineprefixDirectory => _defaultWineprefixDirectory;
  Future changeDefaultWineprefixDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Wine Prefix Directory has been changed to: $value", onlyFile: true),
        _defaultWineprefixDirectory = value,
        if (save) await savePreferencesInData(option: "DefaultWineprefixDirectory", value: value),
      };

  //Default Steam Compatibility Directory
  String _steamCompatibilityDirectory = "";
  get steamCompatibilityDirectory => _steamCompatibilityDirectory;
  Future changeSteamCompatibilityDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Steam Compatibility Directory has been changed to: $value", onlyFile: true),
        _steamCompatibilityDirectory = value,
        if (save) await savePreferencesInData(option: "SteamCompatibilityDirectory", value: value),
      };

  //Default Steam Compatibility Directory
  String _eacRuntimeDefaultDirectory = "";
  get eacRuntimeDefaultDirectory => _eacRuntimeDefaultDirectory;
  Future changeEacRuntimeDefaultDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] EAC Runtime Default Directory has been changed to: $value", onlyFile: true),
        _eacRuntimeDefaultDirectory = value,
        if (save) await savePreferencesInData(option: "EacRuntimeDefaultDirectory", value: value),
      };

  //Default Shader Compile Directory
  String _shaderCompileDirectory = "";
  get defaultShaderCompileDirectory => _shaderCompileDirectory;
  Future changeShaderCompileDirectory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Shader Compile Directory has been changed to: $value", onlyFile: true),
        _shaderCompileDirectory = value,
        if (save) await savePreferencesInData(option: "DefaultShaderCompileDirectory", value: value),
      };

  //Default Category when load
  String _defaultCategory = "";
  get defaultCategory => _defaultCategory;
  Future changeDefaultCategory(String value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Category has been changed to: $value", onlyFile: true),
        _defaultCategory = value,
        if (save) await savePreferencesInData(option: "DefaultCategory", value: value),
      };

  //Default Category when load
  bool _ignoreProtifyExecutable = false;
  get ignoreProtifyExecutable => _ignoreProtifyExecutable;
  Future changeIgnoreProtifyExecutable(bool value, [save = true]) async => {
        DebugLogs.print("[Configuration] Default Category has been changed to: $value", onlyFile: true),
        _ignoreProtifyExecutable = value,
        if (save) await savePreferencesInData(option: "IgnoreProtifyExecutable", value: value),
      };

  static UserPreferences getProvider(BuildContext context) {
    return Provider.of<UserPreferences>(context, listen: false);
  }
}
