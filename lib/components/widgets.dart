import 'dart:convert';
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';

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
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5, // Define a largura desejada (metade da tela)
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: Text(title, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              content: Text(content, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(buttonTitle, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WidgetsAddGameModal extends StatefulWidget {
  const WidgetsAddGameModal({super.key});

  @override
  State<WidgetsAddGameModal> createState() => _WidgetsAddGameModalState();
}

class _WidgetsAddGameModalState extends State<WidgetsAddGameModal> {
  TextEditingController gameName = TextEditingController();
  TextEditingController gameLaunchCommand = TextEditingController();
  TextEditingController gameArgumentsCommand = TextEditingController();
  String gameProton = "none";
  String gameDirectory = "";
  String gamePrefix = "";

  confirmation(context) async {
    //Receiving old data
    List games = await UserPreferences.getGames();
    //Adding new game
    games.add({
      "Title": gameName.text,
      "Image": "",
      "LaunchCommand": gameLaunchCommand.text == "" ? null : gameLaunchCommand.text,
      "ArgumentsCommand": gameArgumentsCommand.text == "" ? null : gameArgumentsCommand.text,
      "LaunchDirectory": gameDirectory,
      "PrefixFolder": gamePrefix == "" ? join(current, "prefixes", gameName.text) : gamePrefix,
      "ProtonDirectory": gameProton == "none" ? null : join(current, "protons", gameProton),
      "Category": "My Games",
      "Ignore": [],
    });
    //Saving data
    SaveDatas.saveData("games", jsonEncode(games));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Back Button
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).secondaryHeaderColor,
                  )),
              //Spacer
              SizedBox(height: 5),
              //Game Name
              SizedBox(
                height: 60,
                child: TextField(
                  controller: gameName,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Cor da borda inferior quando o campo não está focado
                    ),
                  ),
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
                ),
              ),
              //Spacer
              SizedBox(height: 35),
              //Select Proton
              Row(
                children: [
                  //Selected Proton Text
                  Text(
                    gameProton == "none" ? "No Proton" : gameProton,
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
                  ),
                  //Spacer
                  SizedBox(width: 15),
                  //Select Proton Button
                  ElevatedButton(onPressed: () => Models.selectProton(context).then((selectedProton) => setState(() => gameProton = selectedProton)), child: Text("Select Proton")),
                ],
              ),
              //Spacer
              SizedBox(height: 25),
              //Divider
              Divider(color: Theme.of(context).colorScheme.tertiary),
              //Spacer
              SizedBox(height: 25),
              //Launch Command
              gameProton == "none"
                  ? SizedBox(
                      height: 60,
                      child: TextField(
                        controller: gameLaunchCommand,
                        decoration: InputDecoration(
                          labelText: 'Launch Command',
                          labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Cor da borda inferior quando o campo não está focado
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
                      ),
                    )
                  : SizedBox(),
              //Spacer
              SizedBox(height: gameProton == "none" ? 25 : 0),
              //Arguments Commands
              SizedBox(
                height: 60,
                child: TextField(
                  controller: gameArgumentsCommand,
                  decoration: InputDecoration(
                    labelText: 'Arguments Command',
                    labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Cor da borda inferior quando o campo não está focado
                    ),
                  ),
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
                ),
              ),
              //Spacer
              SizedBox(height: 25),
              //Select Game
              Column(
                children: [
                  //Game File
                  Text(gameDirectory == "" ? "No Game Selected" : basename(gameDirectory), style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  //Spacer
                  SizedBox(height: 5),
                  //Button
                  ElevatedButton(
                    onPressed: () => FilesystemPicker.open(
                      context: context,
                      rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
                      fsType: FilesystemType.file,
                      folderIconColor: Theme.of(context).secondaryHeaderColor,
                    ).then((directory) => setState(() => gameDirectory = directory ?? "")),
                    child: Text("Select Game"),
                  ),
                ],
              ), //Select Game
              //Spacer
              SizedBox(height: 25),
              //Select Prefix
              Column(
                children: [
                  //Game File
                  Text(gamePrefix == "" ? "Default Prefix" : gamePrefix, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  //Spacer
                  SizedBox(height: 5),
                  //Button
                  ElevatedButton(
                    onPressed: () => FilesystemPicker.open(
                      context: context,
                      rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
                      fsType: FilesystemType.folder,
                      folderIconColor: Theme.of(context).secondaryHeaderColor,
                    ).then((directory) => setState(() => gamePrefix = directory ?? "")),
                    child: Text("Select Prefix"),
                  ),
                ],
              ),
              //Spacer
              SizedBox(height: 25),
              //Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => confirmation(context),
                  child: Text("Confirm"),
                ),
              ),
              //Spacer
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetsGameLog extends StatefulWidget {
  final Map game;
  WidgetsGameLog({super.key, required this.game});

  @override
  State<WidgetsGameLog> createState() => _WidgetsGameLogState();
}

class _WidgetsGameLogState extends State<WidgetsGameLog> {
  bool running = false;
  List gameLog = [];
  startCommand() async {
    running = true;
    //Command Variables
    const String steamCompatibility = 'export STEAM_COMPAT_CLIENT_INSTALL_PATH="~/.local/share/Steam"';
    final String protonDirectory = widget.game["ProtonDirectory"] as String;
    final String protonWineDirectory = '${join(protonDirectory, "dist", "bin", "wine64")}';
    final String protonExecutable = '${join(protonDirectory, "proton")}';
    final String gameDirectory = widget.game["LaunchDirectory"] as String;

    //Proton full command
    final String command = '$steamCompatibility && STEAM_COMPAT_DATA_PATH="$protonDirectory" "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$gameDirectory"';

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
      setState(() => gameLog.add('Command Finished: $exitCode'));
    }
    //Fatal Error Treatment
    catch (e) {
      setState(() => gameLog.add('Fatal error running game: $e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!running) startCommand();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          //Button
          SizedBox(
            height: MediaQuery.of(context).size.height - 30,
            width: double.infinity,
            child: ListView.builder(
              itemCount: gameLog.length,
              itemBuilder: (context, index) => Text(
                gameLog[index],
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
            ),
          ),
          //Button
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Force Close",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
