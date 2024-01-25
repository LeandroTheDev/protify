import 'package:flutter/material.dart';
import 'package:protify/components/screens/game_log.dart';

class Models {
  /// Start the game and show the logs
  static void startGame({required BuildContext context, required Map game}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GameLogScreen(game: game);
      },
    );
  }

  /// Will check for dependencies for some necessary librarys in linux
  static void checkLinuxDependencies() {}
}
