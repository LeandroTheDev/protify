import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenBuilderProvider extends ChangeNotifier {
  Map<String, dynamic> _datas = {};

  /// Stores all datas from Widgets
  get datas => _datas;

  /// Update a data from key and value
  void changeData(String key, dynamic value) {
    if (value == null) _datas.remove(key);

    _datas[key] = value;
  }

  /// Reset all datas from Widgets
  void resetDatas() {
    _datas = {};
  }

  /// Forces set all datas from Widgets
  void setData(Map<String, dynamic> value) {
    _datas = value;
  }

  /// Returns the provider for getting the datas
  static ScreenBuilderProvider getProvider(BuildContext context) {
    return Provider.of<ScreenBuilderProvider>(context, listen: false);
  }

  /// Construct the data into a map
  static Map buildData(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    return provider.datas;
  }

  /// Reset datas from WidgetProvider that stores datas from widgets
  static void resetProviderDatas(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    provider.resetDatas();
  }

  /// Reads the data from item and add to the ScreenBuilderProvider
  static void readData(BuildContext context, Map item) {
    final ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    provider.setData({
      "ItemName": item["ItemName"] ?? "Undefined",
      "LaunchCommand": item["LaunchCommand"] ?? "",
      "Arguments": item["Arguments"] ?? "",
      "ReaperID": item["ReaperID"] ?? "",
      "EnableNvidiaCompile": item["EnableNvidiaCompile"] ?? false,
      "EnableProtonScript": item["EnableProtonScript"] ?? false,
      "EnableSteamCompatibility": item["EnableSteamCompatibility"] ?? false,
      "EnableSteamWrapper": item["EnableSteamWrapper"] ?? false,
      "SelectedGame": item["SelectedGame"],
      "SelectedPrefix": item["SelectedPrefix"],
      "SelectedLauncher": item["SelectedLauncher"],
      "SelectedRuntime": item["SelectedRuntime"],
    });
  }
}
