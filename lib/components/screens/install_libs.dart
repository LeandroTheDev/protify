import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models.dart';
import 'package:protify/components/widgets.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class InstallLibsScreen extends StatefulWidget {
  final int index;
  const InstallLibsScreen({super.key, required this.index});

  @override
  State<InstallLibsScreen> createState() => _InstallLibsScreenState();
}

class _InstallLibsScreenState extends State<InstallLibsScreen> {
  bool loaded = false;
  TextEditingController libraryArguments = TextEditingController();
  String libraryDirectory = "";
  String libraryProton = "none";
  String libraryPrefixFolder = "";
  bool librarySteamCompatibility = false;
  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    if (!loaded) {
      loaded = true;
      //Load game settings
      UserPreferences.getGames().then(
        (games) => setState(() {
          libraryPrefixFolder = games[index]["PrefixFolder"];
        }),
      );
    }
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
                      Text(
                        'Library Installation',
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
                          title: "Library Installation",
                          content: "Allows you to install and execute .exe into your prefix, like the vcruntimes,drivers, etc using proton or native wine",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Library Directory
                      Text(libraryDirectory == "" ? "No Library Selected" : basename(libraryDirectory), style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                      //Spacer
                      const SizedBox(height: 5),
                      //Button
                      ElevatedButton(
                        onPressed: () => FilesystemPicker.open(
                          context: context,
                          rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
                          fsType: FilesystemType.file,
                          folderIconColor: Theme.of(context).secondaryHeaderColor,
                        ).then((directory) => setState(() => libraryDirectory = directory ?? "")),
                        child: const Text("Select Library"),
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
                        libraryProton == "none" ? "Wine" : libraryProton,
                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      ),
                      //Spacer
                      const SizedBox(height: 5),
                      //Select Proton Button
                      ElevatedButton(
                        onPressed: () => Widgets.selectProton(context, showWine: true, hideProton: true).then(
                          (selectedProton) => setState(() => libraryProton = selectedProton),
                        ),
                        child: const Text("Select Proton/Wine"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  //Library Arguments
                  SizedBox(
                    height: 60,
                    child: TextField(
                      controller: libraryArguments,
                      decoration: InputDecoration(
                        labelText: 'Library Arguments',
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
                          value: librarySteamCompatibility,
                          onChanged: (value) => setState(() => librarySteamCompatibility = value!),
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
                  const SizedBox(height: 35),
                  //Prefix installation
                  Text('Library Prefix Installation Directory: $libraryPrefixFolder', style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  const SizedBox(height: 10),
                  //Confirmation Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Models.startGame(context: context, game: {
                        //libraryProton == "none": "none"
                        //libraryProton == "Wine": "wine"
                        //everthing else return the directory to the proton folder
                        "ProtonDirectory": libraryProton == "none"
                            ? null
                            : libraryProton == "Wine"
                                ? "wine"
                                : join(preferences.defaultProtonDirectory, libraryProton),
                        "EnableSteamCompatibility": librarySteamCompatibility,
                        "PrefixFolder": libraryPrefixFolder,
                        "LaunchDirectory": libraryDirectory,
                        "ArgumentsCommand": libraryArguments.text,
                      }),
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
