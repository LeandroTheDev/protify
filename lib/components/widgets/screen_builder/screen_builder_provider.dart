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
    notifyListeners();
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

  static ScreenBuilderProvider getListenProvider(BuildContext context) {
    return Provider.of<ScreenBuilderProvider>(context, listen: true);
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
      "ItemName": item["ItemName"] == "" ? null : item["ItemName"], // Because this is from a input it can be any empty string
      "LaunchCommand": item["LaunchCommand"] ?? "",
      "ArgumentsCommand": item["ArgumentsCommand"] ?? "",
      "EnableNvidiaCompile": item["EnableNvidiaCompile"] ?? false,
      "EnableSteamCompatibility": item["EnableSteamCompatibility"] ?? false,
      "EnableSteamWrapper": item["EnableSteamWrapper"] ?? false,
      "SelectedReaperID": item["SelectedReaperID"] == "" ? null : item["SelectedReaperID"], // Because this is from a input it can be any empty string
      "SelectedItem": item["SelectedItem"],
      "SelectedPrefix": item["SelectedPrefix"],
      "SelectedLauncher": item["SelectedLauncher"],
      "SelectedRuntime": item["SelectedRuntime"],
    });
  }

  /// Reads the specific data for the library installation
  static void readLibraryData(BuildContext context, Map item) {
    final ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    provider.setData({
      "ItemName": item["ItemName"] ?? "Undefined",
      "SelectedPrefix": item["SelectedPrefix"],
    });
  }

  /// Reads the specific data for the library installation
  static void readDllData(BuildContext context, Map item) {
    final ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    provider.setData({
      "ItemName": item["ItemName"] ?? "Undefined",
      "SelectedPrefix": item["SelectedPrefix"],
    });
  }
}
