import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/data/save_datas.dart';
import 'package:provider/provider.dart';

/// Handles the OS system methods
class ProtifySystem with ChangeNotifier {
  Map _itemsDownloading = {};
  get itemsDownloading => _itemsDownloading;
  void cleanItemsDownloading() {
    _itemsDownloading = {};
  }

  void addItemsDownloading() {}

  ///Save items downloading state
  static void saveItemDownloadState(BuildContext context) {
    //Saving the value
    SaveDatas.saveData("downloads", "user", jsonEncode(Provider.of<ProtifySystem>(context, listen: false).itemsDownloading));
  }

  ///Function to start downloading the item
  static void startReceivingItemDownload(BuildContext context, Map item) {
    // final system = Provider.of<ProtifySystem>(context, listen: false);
  }
}
