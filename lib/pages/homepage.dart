import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/screens/install_dll.dart';
import 'package:protify/components/screens/install_game.dart';
import 'package:protify/components/screens/install_libs.dart';
import 'package:protify/components/screens/preferences.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/library/category_list.dart';
import 'package:protify/components/widgets/library/item_info.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loaded = false;
  Offset mousePosition = const Offset(0, 0);
  int? selectedGameIndex;

  @override
  Widget build(BuildContext context) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    final LibraryProvider libraryProvider = LibraryProvider.getProvider(context);

    if (!loaded) {
      loaded = true;
      // Load Preferences
      UserPreferences.loadPreference(context);
      // Load Items
      UserPreferences.getItems().then(
        (items) => setState(
          () {
            libraryProvider.changeItems(items);
            //Swipe all games and add the category to it
            for (int i = 0; i < libraryProvider.items.length; i++) {
              //Add the index
              libraryProvider.addItemCategory(libraryProvider.items[i]["Category"] ?? "Uncategorized", i);
            }
          },
        ),
      );
    }

    openFriends() {}

    // Return the grid horizontal count
    int getGridGamesCrossAxisCount(screenSize, gameCount) {
      if (screenSize.width <= 400) {
        return 2;
      } else if (screenSize.width <= 600) {
        return 3;
      } else if (screenSize.width <= 800) {
        return 4;
      } else {
        return 5;
      }
    }

    // Start the game
    startGame(int index) async {
      // // Creating the prefix folder if not exist
      // checkPrefixExistence(index);

      // // Call the functions for starting the game
      // Models.startGame(context: context, game: games[index]);
    }

    // Install libraries for the prefix
    installLibs(int index) {
      // showModalBottomSheet(
      //   context: context,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   isScrollControlled: true,
      //   builder: (BuildContext context) {
      //     return InstallLibsScreen(index: index);
      //   },
      // );
    }

    // Install libraries for the prefix
    installDll(int index) {
      // showModalBottomSheet(
      //   context: context,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   isScrollControlled: true,
      //   builder: (BuildContext context) {
      //     return InstallDllScreen(index: index);
      //   },
      // );
    }

    // Install game in game search directory
    installGame() {
      // showModalBottomSheet(
      //   context: context,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   isScrollControlled: true,
      //   builder: (BuildContext context) {
      //     return const InstallGameScreen();
      //   },
      // );
    }

    // Dynamic shows the right side of the window
    Widget rightSide() {
      final screenSize = MediaQuery.of(context).size;
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
                width: screenSize.width * 0.7 - 10,
                height: screenSize.height * 0.2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(
                      libraryProvider.items[selectedGameIndex!]["Title"],
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
                width: screenSize.width * 0.7 - 23,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Play Button
                    SizedBox(
                      width: screenSize.width * 0.15 < 56 ? 56 : screenSize.width * 0.15,
                      height: screenSize.height * 0.07,
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
                      width: screenSize.width * 0.15 < 56 ? 56 : screenSize.width * 0.15,
                      height: screenSize.height * 0.07,
                      child: ElevatedButton(
                        onPressed: () => LibraryModel.addItemModal(context),
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
            libraryProvider.items[selectedGameIndex!]["ProtonDirectory"] != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: screenSize.width * 0.7 - 23,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Empty
                          const SizedBox(),
                          //Install Dependencie
                          SizedBox(
                            width: screenSize.width * 0.15 < 56 ? 56 : screenSize.width * 0.15,
                            height: screenSize.height * 0.07,
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
            libraryProvider.items[selectedGameIndex!]["ProtonDirectory"] != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: screenSize.width * 0.7 - 23,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Empty
                          const SizedBox(),
                          //Install DLLs
                          SizedBox(
                            width: screenSize.width * 0.15 < 56 ? 56 : screenSize.width * 0.15,
                            height: screenSize.height * 0.07,
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
      if (libraryProvider.items.isNotEmpty) {
        return Column(
          children: [
            //Grid
            SizedBox(
              height: screenSize.height - 50,
              width: screenSize.width * 0.7 - 10,
              child: MouseRegion(
                onHover: (event) => mousePosition = event.position,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getGridGamesCrossAxisCount(screenSize, libraryProvider.items.length),
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.5,
                  ),
                  shrinkWrap: true,
                  itemCount: libraryProvider.itemsCategories[libraryProvider.selectedItemCategory] == null ? 0 : libraryProvider.itemsCategories[libraryProvider.selectedItemCategory].length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        selectedGameIndex = index;
                        libraryProvider.hideItemInfo();
                      }),
                      onSecondaryTap: libraryProvider.itemInfo == null
                          ? () {
                              libraryProvider.hideItemInfo();
                              //Create the gameInfo widget
                              libraryProvider.changeItemInfo(context, ItemInfoWidget.build(context));
                            }
                          : () => libraryProvider.hideItemInfo(),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Center(
                          child: Text(
                            libraryProvider.items[libraryProvider.itemsCategories[libraryProvider.selectedItemCategory]![index]]["ItemName"] ?? "Unknown",
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

            //Bottom Buttons
            Container(
              padding: const EdgeInsets.all(8.0),
              width: screenSize.width * 0.7 - 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Add game
                  SizedBox(
                    height: 30,
                    width: screenSize.width > 380.0 ? null : 30,
                    child: ElevatedButton(
                        onPressed: () => {
                              libraryProvider.hideItemInfo(),
                              ScreenBuilderProvider.resetProviderDatas(context),
                              LibraryModel.addItemModal(context),
                            },
                        child: const Text("Add Game")),
                  ),
                  //Edit game
                  SizedBox(
                    height: 30,
                    width: screenSize.width > 380.0 ? null : 30,
                    child: ElevatedButton(onPressed: () => {libraryProvider.hideItemInfo(), installGame()}, child: const Text("Install Game")),
                  ),
                ],
              ),
            ),
          ],
        );
      }
      //No games message
      else {
        return Center(
          child: SizedBox(
            width: screenSize.width * 0.7 - 10,
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
                  child: ElevatedButton(onPressed: () => LibraryModel.addItemModal(context), child: const Text("Add First Game")),
                ),
                const SizedBox(height: 10),
                Text(
                  "Or install one",
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                //Add Game button
                SizedBox(
                  height: 30,
                  child: ElevatedButton(onPressed: () => installGame(), child: const Text("Install Game")),
                ),
              ],
            ),
          ),
        );
      }
    }

    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      //Clicking everwhere will close the gameInfo
      onTap: () => libraryProvider.hideItemInfo(),
      child: Scaffold(
        body: Row(
          children: [
            //Left Side
            SizedBox(
              height: screenSize.height,
              width: screenSize.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Top Buttons
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: screenSize.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: IconButton(
                            onPressed: () => Navigator.pushNamed(context, 'store'),
                            icon: const Icon(Icons.library_books),
                          ),
                        ),
                        FittedBox(child: IconButton(onPressed: () => openFriends(), icon: const Icon(Icons.person))),
                      ],
                    ),
                  ),
                  //Category List
                  const CategoryList(),
                  //Bottom Buttons
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: screenSize.width * 0.3,
                      height: screenSize.height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Theme.of(context).primaryColor,
                            isScrollControlled: true,
                            builder: (BuildContext context) => const PreferencesScreen(),
                          );
                        },
                        child: const Text("Preferences"),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Divider
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Container(
                color: Theme.of(context).primaryColor,
                width: 2,
                height: screenSize.height,
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
