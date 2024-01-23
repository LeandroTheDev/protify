import 'dart:convert';
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models.dart';
import 'package:protify/components/widgets.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List games = [];
  Offset mousePosition = const Offset(0, 0);
  OverlayEntry? gameInfo;
  int? selectedGameIndex;

  @override
  Widget build(BuildContext context) {
    // Load Games
    UserPreferences.getGames().then((value) => setState(() => games = value));

    // To add just call the function to edit simple add the index in parameter
    addOrEditGameModal([index]) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        isScrollControlled: true,
        builder: (BuildContext context) => AddOrEditGamesModal(index: index),
      );
    }

    // Return the grid horizontal count
    int getGridGamesCrossAxisCount(windowSize, gameCount) {
      if (windowSize.width <= 400) {
        return 2;
      } else if (windowSize.width <= 600) {
        return 3;
      } else if (windowSize.width <= 800) {
        return 4;
      } else {
        return 5;
      }
    }

    // Create the prefix folder before the game initializes
    checkPrefixExistence(int index) {
      //No prefix if is not proton
      if (games[index]["ProtonDirectory"] == null) return;
      String currentDirectory = Directory.current.path;
      // Prefixes Folder
      currentDirectory = join(currentDirectory, "prefixes");
      // Check if not exist
      if (!Directory(currentDirectory).existsSync()) {
        // Create
        Directory(currentDirectory).createSync();
      }

      // Game Prefix Folder
      currentDirectory = join(currentDirectory, games[index]["Title"] as String);
      // Check if not exist
      if (!Directory(currentDirectory).existsSync()) {
        // Create
        Directory(currentDirectory).createSync();
      }
    }

    // Start the game
    startGame(int index) async {
      // Creating the prefix folder if not exist
      checkPrefixExistence(index);

      // Call the functions for starting the game
      Models.startGame(context: context, game: games[index]);
    }

    // Hide game infos
    hideGameInfo([index, mousePosition]) {
      //Remove game info
      gameInfo?.remove();
      gameInfo = null;
    }

    // Show the game infos
    showGameInfo(int index, Offset mousePosition) {
      //Create the gameInfo widget
      gameInfo = OverlayEntry(
        builder: (context) => Positioned(
          left: mousePosition.dx,
          top: mousePosition.dy,
          child: Material(
            color: Colors.transparent,
            child: Container(
                width: 70,
                padding: const EdgeInsets.all(8.0),
                color: Theme.of(context).colorScheme.tertiary,
                child: Column(
                  children: [
                    // Game Title
                    SizedBox(
                      width: 50,
                      child: Text(
                        games[index]["Title"],
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Spacer
                    const SizedBox(height: 10),
                    // Edit Game
                    GestureDetector(
                      onTap: () => {
                        // Close the overlay
                        hideGameInfo(),
                        // Open edit game modal
                        addOrEditGameModal(index),
                      },
                      child: const SizedBox(
                        width: 70,
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Spacer
                    const SizedBox(height: 10),
                    // Remove Game
                    GestureDetector(
                      onTap: () => {
                        // Close the overlay
                        hideGameInfo(),
                        // Remove the game
                        UserPreferences.removeGame(index, games, context).then((value) => setState(() => games = value)),
                      },
                      child: const SizedBox(
                        width: 70,
                        child: Text(
                          'Remove',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
      //Inserting into context
      Overlay.of(context).insert(gameInfo!);
    }

    // Left side of the window
    Widget leftSide() {
      final windowSize = MediaQuery.of(context).size;
      return SizedBox(
        height: windowSize.height,
        width: windowSize.width * 0.3,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: games.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 1.0,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    games[index]["Title"],
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Right side of the window
    Widget rightSide() {
      final windowSize = MediaQuery.of(context).size;
      //Selected game
      if (selectedGameIndex.runtimeType == int) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Back Button
            IconButton(
              onPressed: () => setState(() => selectedGameIndex = null),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            //Game Title
            Container(
              color: Theme.of(context).colorScheme.tertiary,
              width: windowSize.width * 0.7 - 10,
              height: windowSize.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    games[selectedGameIndex!]["Title"],
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ),
            ),
            //Play Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: windowSize.width * 0.1 < 60 ? 60 : windowSize.width * 0.1,
                height: windowSize.height * 0.1 < 20 ? 20 : windowSize.height * 0.1,
                child: ElevatedButton(
                  onPressed: () => startGame(selectedGameIndex!),
                  child: const FittedBox(
                      child: Text(
                    "Play",
                    style: TextStyle(fontSize: 999),
                  )),
                ),
              ),
            ),
          ],
        );
      }
      //Show Game Grid
      if (games.isNotEmpty) {
        return Column(
          children: [
            //Grid
            SizedBox(
              height: windowSize.height - 40,
              width: windowSize.width * 0.7 - 10,
              child: MouseRegion(
                onHover: (event) => mousePosition = event.position,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getGridGamesCrossAxisCount(windowSize, games.length),
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.5,
                  ),
                  shrinkWrap: true,
                  itemCount: games.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => selectedGameIndex = index,
                      onSecondaryTap: gameInfo == null ? () => showGameInfo(index, mousePosition) : () => hideGameInfo(),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(
                            games[index]["Title"],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //Add Game button
            SizedBox(
              height: 30,
              child: ElevatedButton(onPressed: () => {hideGameInfo(), addOrEditGameModal()}, child: const Text("Add Game")),
            ),
          ],
        );
      }
      //No games message
      else {
        return Center(
          child: SizedBox(
            width: windowSize.width * 0.7 - 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your library is empty try adding a game to it",
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                //Add Game button
                SizedBox(
                  height: 30,
                  child: ElevatedButton(onPressed: () => addOrEditGameModal(), child: const Text("Add First Game")),
                )
              ],
            ),
          ),
        );
      }
    }

    final windowSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => hideGameInfo(),
      child: Scaffold(
        body: Row(
          children: [
            //Left Side
            leftSide(),

            //Divider
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Container(
                color: Theme.of(context).primaryColor,
                width: 2,
                height: windowSize.height,
              ),
            ),

            //Right Side
            rightSide(),
          ],
        ),
      ),
    );
  }
}

class AddOrEditGamesModal extends StatefulWidget {
  final int? index;
  const AddOrEditGamesModal({super.key, required this.index});

  @override
  State<AddOrEditGamesModal> createState() => _AddOrEditGamesModalState();
}

class _AddOrEditGamesModalState extends State<AddOrEditGamesModal> {
  bool loaded = false;
  TextEditingController gameName = TextEditingController();
  TextEditingController gameLaunchCommand = TextEditingController();
  TextEditingController gameArgumentsCommand = TextEditingController();
  String gameProton = "none";
  String gameDirectory = "";
  String gamePrefix = "";
  bool gameSteamCompatibility = false;

  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    confirmation() {
      //Receiving old data
      UserPreferences.getGames().then((games) {
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
      }).catchError((error) {
        Widgets.showAlert(context, title: "Error", content: "Cannot add game because of a retrieve game error: $error");
      });
    }

    edit() {
      //Receiving old data
      UserPreferences.getGames().then((games) {
        //Adding new game
        games[index!] = {
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
              const SizedBox(height: 5),
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
                  //Game File
                  Text(
                    gameProton == "none" ? "No Proton" : gameProton,
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  ),
                  //Spacer
                  const SizedBox(height: 5),
                  //Button
                  //Select Proton Button
                  ElevatedButton(onPressed: () => Models.selectProton(context).then((selectedProton) => setState(() => gameProton = selectedProton)), child: const Text("Select Proton")),
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
                      rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
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
              //Spacer
              const SizedBox(height: 25),
              //Button
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
    );
  }
}
