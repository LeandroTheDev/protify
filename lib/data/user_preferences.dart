import 'dart:convert';

import 'package:protify/data/save_datas.dart';

class UserPreferences {
  static Future<Map> getUserGames() async {
    final games = jsonDecode(await SaveDatas.readData("games", "string") ?? "{}");
    print(games);
    return games;
  }
}