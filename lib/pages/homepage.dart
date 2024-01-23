import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models.dart';
import 'package:protify/data/user_preferences.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List games = [];
  Offset mousePosition = Offset(0, 0);
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    // Load Games
    UserPreferences.getGames().then((value) => setState(() => games = value));

    int getGridGamesCrossAxisCount(windowSize, gameCount) {
      if (windowSize.width <= 200) {
        return 2;
      } else if (windowSize.width <= 400) {
        return 4;
      } else if (windowSize.width <= 600) {
        return 6;
      } else if (windowSize.width <= 800) {
        return 8;
      } else {
        return 10;
      }
    }

    checkPrefixExistence(int index) {
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

    startGame(int index) async {
      // Creating the prefix folder if not exist
      checkPrefixExistence(index);

      // Call the functions for starting the game
      Models.startGame(context: context, game: games[index]);
    }

    hideGameInfo([index, mousePosition]) {
      //Remove game info
      overlayEntry?.remove();
      overlayEntry = null;
    }

    showGameInfo(int index, Offset mousePosition) {
      //Create the gameInfo widget
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: mousePosition.dx,
          top: mousePosition.dy,
          child: Material(
            color: Colors.transparent,
            child: Container(
                width: 70,
                padding: EdgeInsets.all(8.0),
                color: Theme.of(context).colorScheme.tertiary,
                child: Column(
                  children: [
                    // Game Title
                    SizedBox(
                      width: 50,
                      child: Text(
                        games[index]["Title"],
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Spacer
                    SizedBox(height: 10),
                    // Edit Game
                    GestureDetector(
                      onTap: () => {
                        // Close the overlay
                        hideGameInfo(),
                        // Open edit game modal
                        Models.editGameModal(context: context, index: index, game: games[index]),
                      },
                      child: SizedBox(
                        width: 70,
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Spacer
                    SizedBox(height: 10),
                    // Remove Game
                    GestureDetector(
                      onTap: () => {
                        // Close the overlay
                        hideGameInfo(),
                        // Remove the game
                        UserPreferences.removeGame(index, games).then((value) => setState(() => games = value)),
                      },
                      child: SizedBox(
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
      Overlay.of(context).insert(overlayEntry!);
    }

    final windowSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => hideGameInfo(),
      child: Scaffold(
        body: Row(
          children: [
            //Library
            SizedBox(
              height: windowSize.height,
              width: windowSize.width * 0.3,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: games.length,
                itemBuilder: (context, index) => Models.gameContainer(
                  context: context,
                  index: index,
                  gameTitle: games[index]["Title"] as String,
                ),
              ),
            ),

            //Divider
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                color: Theme.of(context).primaryColor,
                width: 2,
                height: windowSize.height,
              ),
            ),

            //Grid Games
            games.length > 0
                ? Column(
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
                            itemBuilder: (context, index) => Models.gameCard(
                              context: context,
                              startGame: startGame,
                              index: index,
                              gameTitle: games[index]["Title"] as String,
                              mousePosition: mousePosition,
                              showHideGameInfo: overlayEntry == null ? showGameInfo : hideGameInfo,
                            ),
                          ),
                        ),
                      ),

                      //Add Game button
                      SizedBox(
                        height: 30,
                        child: ElevatedButton(onPressed: () => {hideGameInfo(), Models.addGameModal(context: context)}, child: Text("Add Game")),
                      ),
                    ],
                  )
                : Center(
                    child: SizedBox(
                      width: windowSize.width * 0.7 - 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your library is empty try adding a game to it",
                            style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          //Add Game button
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(onPressed: () => Models.addGameModal(context: context), child: Text("Add First Game")),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
