import 'dart:convert';
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/widgets.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class AddOrEditGameScreen extends StatefulWidget {
  final int? index;
  const AddOrEditGameScreen({super.key, required this.index});

  @override
  State<AddOrEditGameScreen> createState() => _AddOrEditGameScreenState();
}

class _AddOrEditGameScreenState extends State<AddOrEditGameScreen> {
  bool loaded = false;
  TextEditingController gameName = TextEditingController();
  TextEditingController gameLaunchCommand = TextEditingController();
  TextEditingController gameArgumentsCommand = TextEditingController();
  String gameProton = "none";
  String gameRuntime = "none";
  String gameDirectory = "";
  String gamePrefix = "";
  bool gameSteamCompatibility = false;
  bool gameShadersCompileNVIDIA = false;
  bool gameUseSteamRuntime = false;
  bool gameUseSteamWrapper = false;

  @override
  Widget build(BuildContext context) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    final index = widget.index;
    //Add new game
    confirmation() async {
      //Check validations
      if (!await validate(context)) {
        return;
      }
      //Receiving old data
      UserPreferences.getGames().then((games) {
        //Adding new game
        games.add({
          "Title": gameName.text,
          "Image": "",
          "LaunchCommand": gameLaunchCommand.text == "" ? null : gameLaunchCommand.text,
          "ArgumentsCommand": gameArgumentsCommand.text == "" ? null : gameArgumentsCommand.text,
          "LaunchDirectory": gameDirectory,
          "PrefixFolder": gamePrefix == "" ? join(preferences.defaultPrefixDirectory, gameName.text) : gamePrefix,
          "ProtonDirectory": gameProton == "none" ? null : join(preferences.defaultProtonDirectory, gameProton),
          "Category": "Uncategorized",
          "Ignore": [],
          "EnableSteamCompatibility": gameSteamCompatibility,
          "EnableShadersCompileNVIDIA": gameShadersCompileNVIDIA,
          "SteamRuntimeDirectory": gameRuntime == "none" || !gameUseSteamRuntime ? null : join(preferences.protifyDirectory, "runtimes", gameRuntime),
          "EnableSteamWrapper": gameUseSteamWrapper,
        });
        //Saving data
        SaveDatas.saveData("games", jsonEncode(games));
        Navigator.pop(context);
      }).catchError((error) {
        Widgets.showAlert(context, title: "Error", content: "Cannot add game because of a retrieve game error: $error");
      });
    }

    //Edit actual game index
    edit() async {
      //Validations
      if (!await validate(context)) {
        return;
      }
      //Receiving old data
      UserPreferences.getGames().then((games) {
        //Adding new game
        games[index!] = {
          "Title": gameName.text,
          "Image": "",
          "LaunchCommand": gameLaunchCommand.text == "" ? null : gameLaunchCommand.text,
          "ArgumentsCommand": gameArgumentsCommand.text == "" ? null : gameArgumentsCommand.text,
          "LaunchDirectory": gameDirectory,
          "PrefixFolder": gamePrefix == "" ? join(preferences.defaultPrefixDirectory, gameName.text) : gamePrefix,
          "ProtonDirectory": gameProton == "none" ? null : join(preferences.defaultProtonDirectory, gameProton),
          "Category": games[index]["Category"],
          "Ignore": [],
          "EnableSteamCompatibility": gameSteamCompatibility,
          "EnableShadersCompileNVIDIA": gameShadersCompileNVIDIA,
          "SteamRuntimeDirectory": gameRuntime == "none" || !gameUseSteamRuntime ? null : join(preferences.protifyDirectory, "runtimes", gameRuntime),
          "EnableSteamWrapper": gameUseSteamWrapper,
        };
        //Saving data
        SaveDatas.saveData("games", jsonEncode(games));
        Navigator.pop(context);
      }).catchError((error) {
        Widgets.showAlert(context, title: "Error", content: "Cannot edit game because of a retrieve game error: $error");
      });
    }

    //Load Game Data if necessary
    if (!loaded) {
      loaded = true;
      if (index != null) {
        //Get games
        UserPreferences.getGames().then((games) {
          setState(() {
            //Get game
            final Map game = games[index];
            //Update variables
            gameName.text = game["Title"] ?? "";
            gameLaunchCommand.text = game["LaunchCommand"] ?? "";
            gameArgumentsCommand.text = game["ArgumentsCommands"] ?? "";
            gameDirectory = game["LaunchDirectory"] ?? "";
            gamePrefix = game["PrefixFolder"] ?? "";
            gameProton = basename(game["ProtonDirectory"] ?? "none");
            gameSteamCompatibility = game["EnableSteamCompatibility"] ?? false;
            gameShadersCompileNVIDIA = game["EnableShadersCompileNVIDIA"] ?? false;
            gameRuntime = basename(game["SteamRuntimeDirectory"] ?? "none");
            gameUseSteamRuntime = (game["SteamRuntimeDirectory"] ?? "none") != "none";
            gameUseSteamWrapper = game["EnableSteamWrapper"] ?? false;
          });
        }).catchError((error) {
          Widgets.showAlert(context, title: "Error", content: "Cannot load edit because of a retrieve game error: $error");
        });
      }
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
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
            //Items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Spacer
                    const SizedBox(height: 5),
                    //Screen Title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        index == null ? 'Adding a Game' : 'Editing ${gameName.text}',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
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
                    const SizedBox(height: 35),
                    //Select Proton
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Selected Proton
                        Text(
                          gameProton == "none" ? "No Proton" : gameProton,
                          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        ),
                        //Spacer
                        const SizedBox(height: 5),
                        //Select Proton Button
                        ElevatedButton(
                          onPressed: () => Widgets.selectProton(context).then((selectedProton) => setState(() => gameProton = selectedProton)),
                          child: const Text("Select Proton"),
                        ),
                      ],
                    ),
                    //Spacer
                    const SizedBox(height: 25),
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
                        : const SizedBox(),
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
                    const SizedBox(height: 25),
                    //Select Game
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Game File
                        Text(gameDirectory == "" ? "No Game Selected" : basename(gameDirectory), style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                        //Spacer
                        const SizedBox(height: 5),
                        //Button
                        ElevatedButton(
                          onPressed: () => FilesystemPicker.open(
                            context: context,
                            rootDirectory: Directory(preferences.defaultGameDirectory),
                            fsType: FilesystemType.file,
                            folderIconColor: Theme.of(context).secondaryHeaderColor,
                          ).then((directory) => setState(() {
                                gameDirectory = directory ?? "";
                                //If name is empty automatically add the game name
                                if (gameName.text == "") {
                                  gameName.text = basename(gameDirectory);
                                }
                              })),
                          child: const Text("Select Game"),
                        ),
                      ],
                    ),
                    //Spacer
                    const SizedBox(height: 25),
                    //Select Prefix
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Game File
                        Text(gamePrefix == "" ? "Default Prefix" : gamePrefix, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                        //Spacer
                        const SizedBox(height: 5),
                        //Button
                        ElevatedButton(
                          onPressed: () => FilesystemPicker.open(
                            context: context,
                            rootDirectory: Directory(preferences.defaultPrefixDirectory),
                            fsType: FilesystemType.folder,
                            folderIconColor: Theme.of(context).secondaryHeaderColor,
                          ).then((directory) => setState(() => gamePrefix = directory ?? "")),
                          child: const Text("Select Prefix"),
                        ),
                      ],
                    ),
                    //Spacer
                    const SizedBox(height: 25),
                    //Steam Compatibility
                    FittedBox(
                      child: Row(
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
                            icon: const Icon(Icons.info),
                            color: Theme.of(context).secondaryHeaderColor,
                            onPressed: () => Widgets.showAlert(
                              context,
                              title: "Steam Compatibility",
                              content: "Enables steam compatibility making the game open with STEAM_COMPAT_CLIENT_INSTALL_PATH to play online games in steam if you are using a legit install",
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Shaders Compile NVIDIA
                    FittedBox(
                      child: Row(
                        children: [
                          //Checkbox
                          Checkbox(
                            value: gameShadersCompileNVIDIA,
                            onChanged: (value) => setState(() => gameShadersCompileNVIDIA = value!),
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
                          Text("Enable Shader Compile NVIDIA", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                          //Info Button
                          IconButton(
                            icon: const Icon(Icons.info),
                            color: Theme.of(context).secondaryHeaderColor,
                            onPressed: () => Widgets.showAlert(
                              context,
                              title: "Shader Compile",
                              content: "Sets the global enviroments from nvidia: \"__GL_SHADER_DISK_CACHE\" to 1 to enable compiling shaders and automatic configure shaders save location in protify/shaders",
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Steam Runtime Mode
                    FittedBox(
                      child: Row(
                        children: [
                          //Checkbox
                          Checkbox(
                            value: gameUseSteamRuntime,
                            onChanged: (value) => setState(() => gameUseSteamRuntime = value!),
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
                          Text("Enable Steam Runtime Mode", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                          //Info Button
                          IconButton(
                            icon: const Icon(Icons.info),
                            color: Theme.of(context).secondaryHeaderColor,
                            onPressed: () => Widgets.showAlert(
                              context,
                              title: "Steam Runtime",
                              content: "Steam Runtime is a tool for running the game in a container to make it more compatible with all devices, use it if you are having trouble running your game",
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Select Runtime
                    gameUseSteamRuntime
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Selected Runtime
                              Text(
                                gameRuntime == "none" ? "No Runtime" : gameRuntime,
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                              ),
                              //Spacer
                              const SizedBox(height: 5),
                              //Select Runtime Button
                              ElevatedButton(
                                onPressed: () => Widgets.selectRuntime(context).then((selectedRuntime) => setState(() => gameRuntime = selectedRuntime)),
                                child: const Text("Select Runtime"),
                              ),
                              //Spacer
                              const SizedBox(height: 5),
                            ],
                          )
                        : SizedBox(),
                    //Steam Wrapper Mode
                    FittedBox(
                      child: Row(
                        children: [
                          //Checkbox
                          Checkbox(
                            value: gameUseSteamWrapper,
                            onChanged: (value) => setState(() => gameUseSteamWrapper = value!),
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
                          Text("Enable Steam Wrapper Mode", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                          //Info Button
                          IconButton(
                            icon: const Icon(Icons.info),
                            color: Theme.of(context).secondaryHeaderColor,
                            onPressed: () => Widgets.showAlert(
                              context,
                              title: "Steam Wrapper",
                              content: "Helps lauching games and compatibility problems, use if you are having trouble launching your game",
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Spacer
                    const SizedBox(height: 25),
                    //Confirmation Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: index == null ? () => confirmation() : () => edit(),
                        child: const Text("Confirm"),
                      ),
                    ),
                    //Spacer
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> validate(BuildContext context) async {
    if (gameName.text.isEmpty) {
      // ignore: use_build_context_synchronously
      if (!await Widgets.showQuestion(context, title: "No Name", content: "You are trying to add a game without title are you sure?")) {
        return false;
      }
    }
    if (gameDirectory.isEmpty) {
      // ignore: use_build_context_synchronously
      if (!await Widgets.showQuestion(context, title: "No Game", content: "You are about to add a game without a game are you sure?")) {
        return false;
      }
    }
    return true;
  }
}
