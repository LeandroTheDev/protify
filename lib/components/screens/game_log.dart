import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class GameLogScreen extends StatefulWidget {
  final Map game;
  const GameLogScreen({super.key, required this.game});

  @override
  State<GameLogScreen> createState() => GameLogScreenState();
}

class GameLogScreenState extends State<GameLogScreen> {
  final ScrollController scrollController = ScrollController();
  bool running = false;
  List gameLog = [];
  List futureLog = [];
  Timer? logShower;
  Process? process;
  StreamSubscription? stdOut;
  StreamSubscription? stdErr;

  Timer? symbolicLinkTimer;

  addLog(String log) {
    futureLog.add(log);
    //Check if timer is already created
    if (logShower != null) return;
    logShower = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      //Update gamelog
      setState(() => gameLog.add(futureLog[0]));
      //Add animation
      Future.delayed(
        const Duration(milliseconds: 100),
        () => WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          },
        ),
      );
      //Remove the actuall futureLog
      futureLog.removeAt(0);
      //Check if timer is unecessary
      if (futureLog.isEmpty) {
        logShower!.cancel();
        logShower = null;
      }
    });
  }

  startCommand(BuildContext context) async {
    running = true;
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    final String command;
    //Check if we are running a proton game
    if (widget.game["ProtonDirectory"] != null && widget.game["ProtonDirectory"] != "wine") {
      String checkEnviroments = "";
      // Check Steam Wrapper
      if (widget.game["EnableSteamWrapper"]) {
        checkEnviroments += '"${preferences.steamCompatibilityDirectory}/ubuntu12_32/steam-launch-wrapper" -- ';
      }
      // Check Steam Runtime
      if (widget.game["SteamRuntimeDirectory"] != null) {
        checkEnviroments += '"${join(widget.game["SteamRuntimeDirectory"], "_v2-entry-point")}" --verb=waitforexitandrun -- ';
      }
      // Check Steam Compatibility
      if (widget.game["EnableSteamCompatibility"]) {
        checkEnviroments += 'STEAM_COMPAT_CLIENT_INSTALL_PATH="${preferences.steamCompatibilityDirectory}" ';
      }
      // Check Shaders Compile NVIDIA
      if (widget.game["EnableShadersCompileNVIDIA"]) {
        // Shaders folder
        final shadersDirectory = Directory('${preferences.protifyDirectory}/shaders');
        if (!shadersDirectory.existsSync()) {
          shadersDirectory.createSync();
        }
        // Game Shaders folder
        final shadersGameDirectory = Directory('${preferences.protifyDirectory}/shaders/${widget.game["Title"]}');
        if (!shadersGameDirectory.existsSync()) {
          shadersGameDirectory.createSync();
        }
        checkEnviroments += '__GL_SHADER_DISK_CACHE_PATH="${preferences.protifyDirectory}/shaders/${widget.game["Title"]} __GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 ';
      }

      //Command Variables
      final String protonDirectory = widget.game["ProtonDirectory"] ?? "";
      final String protonWineDirectory;
      //Check Compatibility for protons
      if (Directory(join(protonDirectory, "dist")).existsSync()) {
        protonWineDirectory = join(protonDirectory, "dist", "bin", "wine64");
      } else {
        protonWineDirectory = join(protonDirectory, "files", "bin", "wine64");
      }

      final String protonExecutable = join(protonDirectory, "proton");
      final String gamePrefix = widget.game["PrefixFolder"];
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";

      //Proton full command
      command = '$checkEnviroments $argumentsCommand STEAM_COMPAT_DATA_PATH="$gamePrefix" "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$gameDirectory"';
    }
    //Non proton game
    else {
      // Check Steam Compatibility
      String checkEnviroments = "";
      if (widget.game["EnableSteamCompatibility"]) {
        checkEnviroments += 'STEAM_COMPAT_CLIENT_INSTALL_PATH="${preferences.steamCompatibilityDirectory}" ';
      }
      // Check Shaders Compile NVIDIA
      if (widget.game["EnableShadersCompileNVIDIA"]) {
        checkEnviroments += '__GL_SHADER_DISK_CACHE_PATH="${preferences.protifyDirectory}/shaders/${widget.game["Title"]} __GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 ';
      }
      final String launchCommand;
      if (widget.game["ProtonDirectory"] == "wine") {
        launchCommand = 'WINEPREFIX="${preferences.defaultWineprefixDirectory}" wine';
      } else {
        launchCommand = widget.game["LaunchCommand"] ?? "";
      }
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      command = '$checkEnviroments $launchCommand $gameDirectory $argumentsCommand';
    }

    try {
      //Resetting game log
      gameLog = [];
      process = await Process.start('/bin/bash', ['-c', command]);

      //Receive infos
      stdOut = process!.stdout.transform(utf8.decoder).listen((data) => addLog('[Info]: $data'));

      //Receive Errors
      stdErr = process!.stderr.transform(utf8.decoder).listen((data) => addLog('[Error]: $data'));

      //Waiting for process
      final exitCode = await process!.exitCode;
      //Process Finished
      if (exitCode == 0) {
        addLog('[Protify] Success Launching Process');
        if (widget.game["CreateGameShortcut"] != null) {
          symbolicLinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
            if (Directory(preferences.defaultGameDirectory).existsSync()) {
              process = await Process.start('/bin/bash', ['-c', 'ln -s "${preferences.defaultGameDirectory}" "${widget.game["CreateGameShortcut"]}"']);
              addLog('[Protify] Successfully created symbolic in prefix');
              timer.cancel();
            }
          });
        }
      } else {
        addLog('[Alert] Process Finished: $exitCode');
      }
    }
    //Fatal Error Treatment
    catch (e) {
      addLog('Fatal error running game: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!running) {
      startCommand(context);
    }
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
                controller: scrollController,
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
    //Check logs timer null
    if (logShower != null) {
      logShower!.cancel();
    }
    //Check symbolic timer null
    if (symbolicLinkTimer != null) {
      symbolicLinkTimer!.cancel();
    }
  }
}
