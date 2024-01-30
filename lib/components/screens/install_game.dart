import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models.dart';
import 'package:protify/components/widgets.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class InstallGameScreen extends StatefulWidget {
  const InstallGameScreen({super.key});

  @override
  State<InstallGameScreen> createState() => _InstallGameScreenState();
}

class _InstallGameScreenState extends State<InstallGameScreen> {
  TextEditingController gameArguments = TextEditingController();
  String gameDirectory = "";
  String gameProton = "none";
  bool gameSteamCompatibility = false;
  @override
  Widget build(BuildContext context) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    return Padding(
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
          //Select Library
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Spacer
                  const SizedBox(height: 5),
                  //Screen Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Title
                      Text(
                        'Game Installation',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      //Info Button
                      IconButton(
                        icon: const Icon(Icons.info),
                        color: Theme.of(context).secondaryHeaderColor,
                        onPressed: () => Widgets.showAlert(
                          context,
                          title: "Game Installation",
                          content: "Allows you to install .exe/.iso into your default game search directory",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  //Select Installer
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Installer Directory
                      Text(gameDirectory == "" ? "No Installer Selected" : basename(gameDirectory), style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                      //Spacer
                      const SizedBox(height: 5),
                      //Button
                      ElevatedButton(
                        onPressed: () => FilesystemPicker.open(
                          context: context,
                          rootDirectory: Platform.isLinux ? Directory("/home/") : Directory("\\"),
                          fsType: FilesystemType.file,
                          folderIconColor: Theme.of(context).secondaryHeaderColor,
                        ).then((directory) => setState(() => gameDirectory = directory ?? "")),
                        child: const Text("Select Installer"),
                      ),
                    ],
                  ),
                  //Spacer
                  const SizedBox(height: 35),
                  //Select Proton
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Selected Proton
                      Text(
                        gameProton == "none" ? "Wine" : gameProton,
                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      ),
                      //Spacer
                      const SizedBox(height: 5),
                      //Select Proton Button
                      ElevatedButton(
                        onPressed: () => Widgets.selectProton(context, showWine: true, hideProton: true).then(
                          (selectedProton) => setState(() => gameProton = selectedProton),
                        ),
                        child: const Text("Select Proton/Wine"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  //Installer Arguments
                  SizedBox(
                    height: 60,
                    child: TextField(
                      controller: gameArguments,
                      decoration: InputDecoration(
                        labelText: 'Installer Arguments',
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
                  const SizedBox(height: 35),
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
                  const SizedBox(height: 10),
                  //Confirmation Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final gamePrefixDirectory = join(preferences.protifyDirectory, "data", "temp_prefix");
                        //.iso files
                        if (gameDirectory.endsWith(".iso")) {
                          try {
                            final Directory mountDirectory = Directory(join(preferences.protifyDirectory, "data", "temp_mount"));
                            // Checking if prefix folder exist
                            if (!mountDirectory.existsSync()) {
                              // Create
                              await mountDirectory.create();
                            }
                            //If exist then umount previous iso iso
                            else {
                              await Process.start('/bin/bash', ['-c', 'umount "${mountDirectory.path}"']);
                            }
                            //Mount iso
                            await Process.start('/bin/bash', ['-c', 'mount -o loop "$gameDirectory" "${mountDirectory.path}"']);
                            //Inform the user what he need to do
                            await Widgets.showAlert(context, title: "Select Installer", content: "The iso sucessfully mounted, select the .exe installer now");
                            //Get installer directory
                            gameDirectory = await FilesystemPicker.open(
                                  context: context,
                                  rootDirectory: mountDirectory,
                                  fsType: FilesystemType.file,
                                  folderIconColor: Theme.of(context).secondaryHeaderColor,
                                ) ??
                                "";
                            if (gameDirectory == "") {
                              return;
                            }
                          } catch (error) {
                            Widgets.showAlert(context, title: "Error", content: "Cannot create prefix directory reason: $error");
                            return;
                          }
                        }
                        //.exe files
                        else {
                          try {
                            final Directory prefixDirectory = Directory(gamePrefixDirectory);
                            // Checking if prefix folder exist
                            if (!prefixDirectory.existsSync()) {
                              // Create
                              await prefixDirectory.create();
                            }
                          } catch (error) {
                            Widgets.showAlert(context, title: "Error", content: "Cannot create prefix directory reason: $error");
                            return;
                          }
                        }
                        Models.startGame(context: context, game: {
                          //gameProton == "none": "none"
                          //gameProton == "Wine": "wine"
                          //everthing else return the directory to the proton folder
                          "ProtonDirectory": gameProton == "none"
                              ? null
                              : gameProton == "Wine"
                                  ? "wine"
                                  : join(preferences.defaultProtonDirectory, gameProton),
                          "EnableSteamCompatibility": gameSteamCompatibility,
                          "PrefixFolder": gamePrefixDirectory,
                          "LaunchDirectory": gameDirectory,
                          "ArgumentsCommand": gameArguments.text,
                          "CreateGameShortcut": join(gamePrefixDirectory, "pfx", "drive_c", "Games Search Directory"),
                        });
                      },
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
    );
  }
}
