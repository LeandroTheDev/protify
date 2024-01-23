import 'dart:convert';

import 'package:protify/components/widgets.dart';
import 'package:protify/data/save_datas.dart';

class UserPreferences {
  /// Returns a list of all games saved in device
  static Future<List> getGames() async {
    final games = jsonDecode(await SaveDatas.readData("games", "string") ?? "[]");
    return games;
  }

  /// Remove a specific game by the index, needs the games, if context is not provided,
  /// the message asking will not appear
  static Future<List> removeGame(int index, List games, [context]) async {
    if (context != null) {
      final result = await Widgets.showQuestion(context, title: "Remove Game", content: "Do you wish to remove this game from your library?");
      if (!result) return games;
    }
    //Removing
    games.removeAt(index);
    //Update new data
    await SaveDatas.saveData('games', jsonEncode(games));
    return games;
  }
}
