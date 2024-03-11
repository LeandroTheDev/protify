import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SaveDatas {
  /// Save datas of type: string, bool, int and double
  static Future saveData(String dataName, dynamic dataValue) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (dataValue.runtimeType == String) {
      await preferences.setString(dataName, dataValue);
    } else if (dataValue.runtimeType == bool) {
      await preferences.setBool(dataName, dataValue);
    } else if (dataValue.runtimeType == int) {
      await preferences.setInt(dataName, dataValue);
    } else if (dataValue.runtimeType == double) {
      await preferences.setDouble(dataName, dataValue);
    } else {
      throw "The Type is not Compatibile";
    }
  }

  /// Read data based in name and type, the types consist in: 'string', 'int', 'bool', 'double'
  static Future<dynamic> readData(String dataName, String dataType) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    switch (dataType) {
      case "string":
        return preferences.getString(dataName);
      case "double":
        return preferences.getDouble(dataName);
      case "int":
        return preferences.getInt(dataName);
      case "bool":
        return preferences.getBool(dataName);
    }
    throw "Invalid Data Type";
  }

  /// Remove a data based in data name
  static void removeData(String dataName) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(dataName);
  }

  /// Clean all data saved
  static Future clearData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  /// Clean all preferences saved
  static Future clearPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("preferences");
  }

  /// Clean all games saved
  static Future clearGames() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("items");
  }
}
