import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models.dart';
import 'package:protify/components/screens/add_remove_game.dart';
import 'package:protify/components/screens/install_dll.dart';
import 'package:protify/components/screens/install_libs.dart';
import 'package:protify/components/screens/preferences.dart';
import 'package:protify/data/user_preferences.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loaded = false;
  List games = [];
  Offset mousePosition = const Offset(0, 0);
  OverlayEntry? gameInfo;
  int? selectedGameIndex;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      loaded = true;
      UserPreferences.loadPreference(context); // Load Preferences
    }
    UserPreferences.getGames().then((value) => setState(() => games = value)); // Load Games

    // To add just call the function to edit simple add the index in parameter
    addOrEditGameModal([index]) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        isScrollControlled: true,
        builder: (BuildContext context) => AddOrEditGameScreen(index: index),
      );
    }

    preferencesScreen() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        isScrollControlled: true,
        builder: (BuildContext context) => const PreferencesScreen(),
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
      if (games[index]["ProtonDirectory"] == null || games[index]["PrefixFolder"] == null) return;
      String currentDirectory = Directory.current.path;
      // Prefixes Folder
      currentDirectory = join(currentDirectory, "prefixes");
      // Check if not exist
      if (!Directory(currentDirectory).existsSync()) {
        // Create
        Directory(currentDirectory).createSync();
      }

      // Game Prefix Folder
      currentDirectory = games[index]["PrefixFolder"] as String;
      // Check if not exist
      if (!Directory(currentDirectory).existsSync()) {
        // Create
        Directory(currentDirectory).createSync();
      }
      // Wine Prefix Folder
      currentDirectory = join(currentDirectory, 'pfx');
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

    // Install libraries for the prefix
    installLibs(int index) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return InstallLibsScreen(index: index);
        },
      );
    }

    // Install libraries for the prefix
    installDll(int index) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).primaryColor,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return InstallDll(index: index);
        },
      );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView.builder(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: windowSize.width * 0.3,
                height: 30,
                child: ElevatedButton(
                  onPressed: () => preferencesScreen(),
                  child: const Text("Preferences"),
                ),
              ),
            ),
          ],
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
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Container(
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
            ),
            //Title Buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: windowSize.width * 0.7 - 23,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Play Button
                    SizedBox(
                      width: windowSize.width * 0.15 < 56 ? 56 : windowSize.width * 0.15,
                      height: windowSize.height * 0.07,
                      child: ElevatedButton(
                        onPressed: () => startGame(selectedGameIndex!),
                        child: const FittedBox(
                          child: Text(
                            "Play",
                            style: TextStyle(fontSize: 999),
                          ),
                        ),
                      ),
                    ),
                    //Edit Button
                    SizedBox(
                      width: windowSize.width * 0.15 < 56 ? 56 : windowSize.width * 0.15,
                      height: windowSize.height * 0.07,
                      child: ElevatedButton(
                        onPressed: () => addOrEditGameModal(selectedGameIndex!),
                        child: const FittedBox(
                          child: Text(
                            "Edit",
                            style: TextStyle(fontSize: 999),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Library
            games[selectedGameIndex!]["ProtonDirectory"] != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: windowSize.width * 0.7 - 23,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Empty
                          const SizedBox(),
                          //Install Dependencie
                          SizedBox(
                            width: windowSize.width * 0.15 < 56 ? 56 : windowSize.width * 0.15,
                            height: windowSize.height * 0.07,
                            child: ElevatedButton(
                              onPressed: () => installLibs(selectedGameIndex!),
                              child: const FittedBox(
                                child: Text(
                                  "Libs",
                                  style: TextStyle(fontSize: 999),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            //Dlls
            games[selectedGameIndex!]["ProtonDirectory"] != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: windowSize.width * 0.7 - 23,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Empty
                          const SizedBox(),
                          //Install DLLs
                          SizedBox(
                            width: windowSize.width * 0.15 < 56 ? 56 : windowSize.width * 0.15,
                            height: windowSize.height * 0.07,
                            child: ElevatedButton(
                              onPressed: () => installDll(selectedGameIndex!),
                              child: const FittedBox(
                                child: Text(
                                  "Dll",
                                  style: TextStyle(fontSize: 999),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
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
                      onTap: () => {selectedGameIndex = index, hideGameInfo()},
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
      //Clicking everwhere will close the gameInfo
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
