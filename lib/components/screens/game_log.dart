import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class GameLogScreen extends StatefulWidget {
  final Map game;
  const GameLogScreen({super.key, required this.game});

  @override
  State<GameLogScreen> createState() => GameLogScreenState();
}

class GameLogScreenState extends State<GameLogScreen> {
  bool running = false;
  List gameLog = [];
  Process? process;
  StreamSubscription? stdOut;
  StreamSubscription? stdErr;
  startCommand() async {
    running = true;
    final String command;
    //Check if we are running a proton game
    if (widget.game["ProtonDirectory"] != null && widget.game["ProtonDirectory"] != "wine") {
      // Check Steam Compatibility
      String steamCompatibility = "";
      if (widget.game["EnableSteamCompatibility"]) {
        steamCompatibility = 'STEAM_COMPAT_CLIENT_INSTALL_PATH="~/.local/share/Steam"';
      }
      //Command Variables
      final String protonDirectory = widget.game["ProtonDirectory"] ?? "";
      final String protonWineDirectory = join(protonDirectory, "dist", "bin", "wine64");
      final String protonExecutable = join(protonDirectory, "proton");
      final String gamePrefix = widget.game["PrefixFolder"];
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";

      //Proton full command
      command = '$steamCompatibility WINEPREFIX="$gamePrefix/pfx" STEAM_COMPAT_DATA_PATH="$gamePrefix" "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$gameDirectory" $argumentsCommand';
    }
    //Non proton game
    else {
      // Check Steam Compatibility
      String steamCompatibility = "";
      if (widget.game["EnableSteamCompatibility"]) {
        steamCompatibility = 'STEAM_COMPAT_CLIENT_INSTALL_PATH="~/.local/share/Steam"';
      }
      final String launchCommand;
      if (widget.game["ProtonDirectory"] == "wine") {
        launchCommand = 'WINEPREFIX="${widget.game["PrefixFolder"]}" wine';
      } else {
        launchCommand = widget.game["LaunchCommand"] ?? "";
      }
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      command = '$steamCompatibility $launchCommand $gameDirectory $argumentsCommand';
    }

    try {
      //Resetting game log
      gameLog = [];
      process = await Process.start('/bin/bash', ['-c', command]);

      //Receive infos
      stdOut = process!.stdout.transform(utf8.decoder).listen((data) {
        setState(() => gameLog.add('[Info]: $data'));
      });

      //Receive Errors
      stdErr = process!.stderr.transform(utf8.decoder).listen((data) {
        setState(() => gameLog.add('[Error]: $data'));
      });

      //Waiting for process
      final exitCode = await process!.exitCode;
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
          //Log
          SizedBox(
            height: MediaQuery.of(context).size.height - 40,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 5, right: 5),
              child: ListView.builder(
                itemCount: gameLog.length,
                itemBuilder: (context, index) => Text(
                  gameLog[index],
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
            ),
          ),
          //Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close Log
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close Log",
                    ),
                  ),
                ),
                // Kill Process
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => process!.kill(ProcessSignal.sigkill),
                    child: const Text(
                      "Kill",
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //Check listeners and cancel
    if (stdOut != null) {
      stdOut!.cancel();
    }
    //Check listeners and cancel
    if (stdErr != null) {
      stdErr!.cancel();
    }
  }
}
