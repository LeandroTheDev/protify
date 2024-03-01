import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/data/save_datas.dart';
import 'package:provider/provider.dart';

class ProtifySystem with ChangeNotifier {
  Map itemsDownloading = {};

  ///Save items downloading state
  static void saveItemDownloadState(BuildContext context) {
    //Saving the value
    SaveDatas.saveData("preferences", jsonEncode(Provider.of<ProtifySystem>(context, listen: false).itemsDownloading));
  }
}
