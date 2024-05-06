import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protify/components/models/launcher.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class ItemLogScreen extends StatefulWidget {
  final Map item;
  const ItemLogScreen({super.key, required this.item});

  @override
  State<ItemLogScreen> createState() => LaunchLogScreenState();
}

class LaunchLogScreenState extends State<ItemLogScreen> {
  final ScrollController scrollController = ScrollController();
  bool running = false;
  List gameLog = [];
  List futureLog = [];
  Timer? logShower;
  Process? process;
  StreamSubscription? stdOut;
  StreamSubscription? stdErr;

  int symbolicLinkChances = 10;

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

    //Wine Command
    if (widget.item["SelectedLauncher"] == "Wine") {
      command = LauncherModel.generateWineStartCommand(context, widget.item);
    }
    //Proton Command
    else if (widget.item["SelectedLauncher"] != null) {
      command = LauncherModel.generateProtonStartCommand(context, widget.item);
    }
    //Shell Command
    else {
      command = LauncherModel.generateShellStartCommand(context, widget.item);
    }

    try {
      addLog('[Protify]: command: $command');
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
        //Check for creation symbolic links
        if (widget.item["CreateItemShortcut"] != null) {
          //Timer repeat if symbolic cannot be create
          symbolicLinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
            //Check if exist
            if (Directory(preferences.defaultGameDirectory).existsSync()) {
              process = await Process.start('/bin/bash', ['-c', 'ln -s "${preferences.defaultGameDirectory}" "${widget.item["CreateGameShortcut"]}"']);
              addLog('[Protify] Successfully created symbolic in prefix');
              timer.cancel();
            }
            //If not exist
            else {
              //Check chances
              if (symbolicLinkChances <= 0) {
                addLog('[Protify Error] Cannot create the symbolic link after 10 tries, giving up...');
                timer.cancel();
                return;
              }
              //Log the error
              symbolicLinkChances--;
              addLog('[Protify Error] Trying to create symbolic in prefix but the directory doesn\'t exist...');
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
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: gameLog[index]));
                  },
                  child: Text(
                    gameLog[index],
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  ),
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
                    onPressed: () => {process!.kill(ProcessSignal.sigkill)},
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
