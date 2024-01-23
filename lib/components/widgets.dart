import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Widgets {
  /// Simple show a alert dialog to the user
  static void showAlert(
    BuildContext context, {
    String title = "",
    String content = "",
    String buttonTitle = "OK",
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.5, // Define a largura desejada (metade da tela)
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: Text(title,
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              content: Text(content,
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(buttonTitle,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Simple show a alert dialog to the user
  static Future<bool> showQuestion(
    BuildContext context, {
    String title = "",
    String content = "",
    String buttonTitle = "Yes",
    String buttonTitle2 = "No",
  }) {
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: Text(title,
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              content: Text(content,
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              actions: [
                //yes
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    completer.complete(true);
                  },
                  child: Text(buttonTitle,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor)),
                ),
                //no
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    completer.complete(false);
                  },
                  child: Text(buttonTitle2,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor)),
                ),
              ],
            ),
          ),
        );
      },
    );

    return completer.future;
  }
}

class WidgetsGameLog extends StatefulWidget {
  final Map game;
  const WidgetsGameLog({super.key, required this.game});

  @override
  State<WidgetsGameLog> createState() => _WidgetsGameLogState();
}

class _WidgetsGameLogState extends State<WidgetsGameLog> {
  bool running = false;
  List gameLog = [];
  startCommand() async {
    running = true;
    final String command;
    //Check if we are running a proton game
    if (widget.game["ProtonDirectory"] != null) {
      // Check Steam Compatibility
      String steamCompatibility = "";
      if (widget.game["EnableSteamCompatibility"]) {
        steamCompatibility =
            'export STEAM_COMPAT_CLIENT_INSTALL_PATH="~/.local/share/Steam" &&';
      }
      //Command Variables
      final String protonDirectory = widget.game["ProtonDirectory"] ?? "";
      final String protonWineDirectory =
          join(protonDirectory, "dist", "bin", "wine64");
      final String protonExecutable = join(protonDirectory, "proton");
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";

      //Proton full command
      command =
          '$steamCompatibility STEAM_COMPAT_DATA_PATH="$protonDirectory" "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$gameDirectory" $argumentsCommand';
    }
    //Non proton game
    else {
      // Check Steam Compatibility
      String steamCompatibility = "";
      if (widget.game["EnableSteamCompatibility"]) {
        steamCompatibility =
            'export STEAM_COMPAT_CLIENT_INSTALL_PATH="~/.local/share/Steam" &&';
      }
      final String launchCommand = widget.game["LaunchCommand"] ?? "";
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      command =
          '$steamCompatibility $launchCommand $gameDirectory $argumentsCommand';
    }

    try {
      //Resetting game log
      gameLog = [];
      var process = await Process.start('/bin/bash', ['-c', command]);

      //Receive infos
      process.stdout.transform(utf8.decoder).listen((data) {
        setState(() => gameLog.add('[Info]: $data'));
      });

      //Receive Errors
      process.stderr.transform(utf8.decoder).listen((data) {
        setState(() => gameLog.add('[Error]: $data'));
      });

      //Waiting for process
      var exitCode = await process.exitCode;
      //Process Finished
      if (exitCode == 0) {
        setState(() => gameLog.add('[Info] Success Launching Game'));
      } else {
        setState(() => gameLog.add('[Alert] Process Finished: $exitCode'));
      }
    }
    //Fatal Error Treatment
    catch (e) {
      setState(() => gameLog.add('Fatal error running game: $e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!running) startCommand();
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          //Button
          SizedBox(
            height: MediaQuery.of(context).size.height - 40,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 5, right: 5),
              child: ListView.builder(
                itemCount: gameLog.length,
                itemBuilder: (context, index) => Text(
                  gameLog[index],
                  style:
                      TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
            ),
          ),
          //Button
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: 30,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close Log",
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
