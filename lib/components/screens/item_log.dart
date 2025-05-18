import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:protify/components/models/dialogs.dart';
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
  bool disposed = false;
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
      if (disposed) return;
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

  /// Will check if the inserted code is successfully
  checkSuccessCodes(int code) {
    switch (code) {
      case 0:
        return true;
      case 3:
        return true;
    }
    return false;
  }

  startCommand(BuildContext context) async {
    running = true;
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);

    final String command = LauncherModel.generateCommandBasedOnLauncher(context, widget.item);

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
      if (checkSuccessCodes(exitCode)) {
        addLog('[Protify] Success Launching Process');
        //Check for creation symbolic links
        if (widget.item["CreateItemShortcut"] != null) {
          //Timer repeat if symbolic cannot be create
          symbolicLinkTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
            //Check if exist
            if (Directory(preferences.defaultGameDirectory).existsSync()) {
              process = await Process.start('/bin/bash', ['-c', 'ln -s "${preferences.defaultGameDirectory}" "${widget.item["CreateItemShortcut"]}"']);
              addLog('[Protify] Successfully created symbolic in prefix to ${preferences.defaultGameDirectory}');
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
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    final String temporaryPrefixDirectoryString = join(preferences.protifyDirectory, "data", "temp_prefix");

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
                  width: MediaQuery.of(context).size.width / 4 > 200 ? 200 : MediaQuery.of(context).size.width / 4,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close Log",
                    ),
                  ),
                ),
                
                // Convert temp prefix | Check if the prefix is from temp directory
                widget.item["SelectedPrefix"] == temporaryPrefixDirectoryString
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 4 > 200 ? 150 : MediaQuery.of(context).size.width / 6,
                        height: 30,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await DialogsModel.showQuestion(
                              context,
                              title: "Move Temp Prefix",
                              content: "To move the prefix before make sure the installation is finished and all the softwares is closed.",
                              buttonTitle: "Confirm",
                              buttonTitle2: "Cancel",
                            );
                            if (!result) return;

                            final folderName = await DialogsModel.typeInput(context, title: "Prefix Name");
                            if (folderName.isEmpty) return;

                            DialogsModel.showLoading(context);

                            try {
                              final Directory destinationDirectory = Directory(join(preferences.defaultPrefixDirectory, folderName));
                              destinationDirectory.create(recursive: true);

                              final Directory temporaryPrefixDirectory = Directory(temporaryPrefixDirectoryString);

                              await temporaryPrefixDirectory.rename(destinationDirectory.path);

                              if (DialogsModel.isLoading) Navigator.pop(context);
                              DialogsModel.showAlert(context, title: "Success", content: "Temporary prefix was moved to ${destinationDirectory.path}");
                            } catch (error) {
                              if (DialogsModel.isLoading) Navigator.pop(context);
                              DialogsModel.showAlert(context, title: "Error", content: "Any error occurs while moving temporary prefix to default prefix directory: $error");
                            }
                          },
                          child: const Text(
                            "Convert Prefix",
                          ),
                        ),
                      )
                    : const SizedBox(),
                
                // Kill Process
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4 > 200 ? 200 : MediaQuery.of(context).size.width / 4,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Getting the item executable
                      final String executableName = basename(widget.item["SelectedItem"]);
                      // Checking executables with the item name
                      final executableFinderProcess = await Process.start('/bin/bash', ['-c', "ps aux | grep '$executableName'"]);
                      //Receive executables info
                      executableFinderProcess.stdout.transform(utf8.decoder).listen((data) {
                        final executablesLines = data.split("\n");

                        /// Stores the executable pid and name [[123, "test.exe"]]
                        final List PIDs = [];
                        String warningText = "Process finded with the name: ${widget.item["ItemName"]}";

                        // Swiping all executables from that name
                        for (var line in executablesLines) {
                          // Getting the parts of that line dividing it by spaces
                          final parts = line.split(RegExp(r'\s+'));
                          // Check if the line exist
                          if (parts.length > 1) {
                            // Saving the PID and Name
                            PIDs.add([int.parse(parts[1]), parts[10]]);
                            // warningText += "\n${parts[1]} -- ${parts[10]}";
                            warningText += "\n${parts[1]}";
                          }
                        }

                        warningText += "\nKill all?";
                        DialogsModel.showQuestion(context, title: "Killing ${widget.item["ItemName"]}", content: warningText, buttonTitle: "Yes", buttonTitle2: "No").then((result) {
                          if (!result) return;
                          process!.kill(ProcessSignal.sigkill);
                          // Swiping all pids to kill
                          for (int i = 0; i < PIDs.length; i++) {
                            // Getting the pid
                            int processPID = PIDs[i][0];
                            // Killing it
                            Process.run('kill', ['-9', processPID.toString()]);
                            addLog("[Protify] process killed: $processPID");
                          }
                        });
                      });
                    },
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
    disposed = true;
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
