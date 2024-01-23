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
  bool gameSteamCompatibility = false;

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
      "EnableSteamCompatibility": gameSteamCompatibility,
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
                    ).then((directory) => setState(() {
                          gameDirectory = directory ?? "";
                          //If name is empty automatically add the game name
                          if (gameName.text == "") {
                            gameName.text = basename(gameDirectory);
                          }
                        })),
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
              //Steam Compatibility
              Row(
                children: [
                  //Checkbox
                  Checkbox(
                    value: gameSteamCompatibility,
                    onChanged: (value) => setState(() => gameSteamCompatibility = value!),
                    //Fill Color
                    fillColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.secondary;
                        }
                        return null;
                      },
                    ),
                    //Check Color
                    checkColor: Theme.of(context).colorScheme.tertiary,
                    //Border Color
                    side: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 2.0),
                  ),
                  //Text
                  Text("Enable Steam Compatibility", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  //Info Button
                  IconButton(
                    icon: Icon(Icons.info),
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () => Widgets.showAlert(
                      context,
                      title: "Steam Compatibility",
                      content: "Enables steam compatibility making the game open with STEAM_COMPAT_CLIENT_INSTALL_PATH to play online games in steam if you are using a legit install",
                    ),
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

class WidgetsEditGameModal extends StatefulWidget {
  final int index;
  final Map game;
  const WidgetsEditGameModal({super.key, required this.index, required this.game});

  @override
  State<WidgetsEditGameModal> createState() => _WidgetsEditGameModalState();
}

class _WidgetsEditGameModalState extends State<WidgetsEditGameModal> {
  bool loaded = false;
  TextEditingController gameName = TextEditingController();
  TextEditingController gameLaunchCommand = TextEditingController();
  TextEditingController gameArgumentsCommand = TextEditingController();
  String gameProton = "";
  String gameDirectory = "";
  String gamePrefix = "";
  bool gameSteamCompatibility = false;

  confirmation(context) async {
    //Receiving old data
    List games = await UserPreferences.getGames();
    //Adding new game
    games[widget.index] = {
      "Title": gameName.text,
      "Image": "",
      "LaunchCommand": gameLaunchCommand.text == "" ? null : gameLaunchCommand.text,
      "ArgumentsCommand": gameArgumentsCommand.text == "" ? null : gameArgumentsCommand.text,
      "LaunchDirectory": gameDirectory,
      "PrefixFolder": gamePrefix == "" ? join(current, "prefixes", gameName.text) : gamePrefix,
      "ProtonDirectory": gameProton == "none" ? null : join(current, "protons", gameProton),
      "Category": "My Games",
      "Ignore": [],
      "EnableSteamCompatibility": gameSteamCompatibility,
    };
    //Saving data
    SaveDatas.saveData("games", jsonEncode(games));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //Load Game Data
    if (!loaded) {
      loaded = true;
      gameName.text = widget.game["Title"] ?? "";
      gameLaunchCommand.text = widget.game["LaunchCommand"] ?? "";
      gameArgumentsCommand.text = widget.game["ArgumentsCommands"] ?? "";
      gameDirectory = widget.game["LaunchDirectory"] ?? "";
      gamePrefix = widget.game["PrefixFolder"] ?? "";
      gameProton = basename(widget.game["ProtonDirectory"] ?? "none");
      gameSteamCompatibility = widget.game["EnableSteamCompatibility"] ?? false;
    }
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
                ),
              ),
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
                    ).then((directory) => setState(() {
                          gameDirectory = directory ?? "";
                          //If name is empty automatically add the game name
                          if (gameName.text == "") {
                            gameName.text = basename(gameDirectory);
                          }
                        })),
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
              //Steam Compatibility
              Row(
                children: [
                  //Checkbox
                  Checkbox(
                    value: gameSteamCompatibility,
                    onChanged: (value) => setState(() => gameSteamCompatibility = value!),
                    //Fill Color
                    fillColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.secondary;
                        }
                        return null;
                      },
                    ),
                    //Check Color
                    checkColor: Theme.of(context).colorScheme.tertiary,
                    //Border Color
                    side: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 2.0),
                  ),
                  //Text
                  Text("Enable Steam Compatibility", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  //Info Button
                  IconButton(
                    icon: Icon(Icons.info),
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () => Widgets.showAlert(
                      context,
                      title: "Steam Compatibility",
                      content: "Enables steam compatibility making the game open with STEAM_COMPAT_CLIENT_INSTALL_PATH to play online games in steam if you are using a legit install",
                    ),
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
    final String command;
    //Check if we are running a proton game
    if (widget.game["ProtonDirectory"] != null) {
      // Check Steam Compatibility
      String steamCompatibility = "";
      if (widget.game["EnableSteamCompatibility"]) steamCompatibility = 'export STEAM_COMPAT_CLIENT_INSTALL_PATH="~/.local/share/Steam" &&';
      //Command Variables
      final String protonDirectory = widget.game["ProtonDirectory"] ?? "";
      final String protonWineDirectory = '${join(protonDirectory, "dist", "bin", "wine64")}';
      final String protonExecutable = '${join(protonDirectory, "proton")}';
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";

      //Proton full command
      command = '$steamCompatibility STEAM_COMPAT_DATA_PATH="$protonDirectory" "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$gameDirectory" $argumentsCommand';
    }
    //Non proton game
    else {
      // Check Steam Compatibility
      String steamCompatibility = "";
      if (widget.game["EnableSteamCompatibility"]) steamCompatibility = 'export STEAM_COMPAT_CLIENT_INSTALL_PATH="~/.local/share/Steam" &&';
      final String launchCommand = widget.game["LaunchCommand"] ?? "";
      final String argumentsCommand = widget.game["ArgumentsCommand"] ?? "";
      final String gameDirectory = widget.game["LaunchDirectory"] ?? "";
      command = '$steamCompatibility $launchCommand $gameDirectory $argumentsCommand';
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
      if (exitCode == 0)
        setState(() => gameLog.add('[Info] Success Launching Game'));
      else
        setState(() => gameLog.add('[Alert] Process Finished: $exitCode'));
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
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          //Button
          SizedBox(
            height: MediaQuery.of(context).size.height - 40,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 25, left: 5, right: 5),
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
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: 30,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close Log",
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
