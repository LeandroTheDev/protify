import 'package:flutter/material.dart';
import 'package:protify/components/screens/game_log.dart';
import 'package:protify/components/screens/install_libs.dart';

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

  /// Show severall options to install libraries to the game prefix
  static void installLibs({required BuildContext context, required int index}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return InstallLibsScreen(index: index);
      },
    );
  }

  /// Will check for dependencies for some necessary librarys in linux
  static void checkLinuxDependencies() {}
}
