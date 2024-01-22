import 'dart:convert';

import 'package:protify/data/save_datas.dart';

class UserPreferences {
  static Future<List> getGames() async {
    final games = jsonDecode(await SaveDatas.readData("games", "string") ?? "[]");
    return games;
  }

  static Future<List> removeGame(int index, List games) async {
    //Removing
    games.removeAt(index);
    //Update new data
    await SaveDatas.saveData('games', jsonEncode(games));
    return games;
  }
}
