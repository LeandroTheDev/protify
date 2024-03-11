import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/screens/preferences.dart';
import 'package:protify/components/widgets/library/category_list.dart';
import 'package:protify/components/widgets/library/empty_widget.dart';
import 'package:protify/components/widgets/library/grid_game.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/components/widgets/library/selected_game.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Offset mousePosition = const Offset(0, 0);
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    final LibraryProvider libraryProvider = LibraryProvider.getProviderListenable(context);

    if (libraryProvider.screenUpdate) {
      DebugLogs.print("Home Page Loaded");
      // Clear previous datas
      libraryProvider.clearItemSelection();
      libraryProvider.clearDatas();
      // Block homepage update
      libraryProvider.changeScreenUpdate(false);
      // Load Items
      UserPreferences.getItems().then((items) {
        libraryProvider.changeItems(items);
        //Swipe all games and add the category to it
        for (int i = 0; i < libraryProvider.items.length; i++) {
          //Add the index
          libraryProvider.addItemCategory(libraryProvider.items[i]["Category"] ?? "Uncategorized", i);
        }
        // Protify first load
        if (!loaded) {
          loaded = true;
          // Load Preferences
          UserPreferences.loadPreference(context).then(
            (value) => {
              libraryProvider.changeSelectedItemCategory(preferences.defaultCategory),
              libraryProvider.updateScreen(),
            },
          );
        }
        //Subsequent loads
        else {
          libraryProvider.updateScreen();
        }
      });
    }

    // Dynamic shows the right side of the window
    Widget rightSide() {
      final screenSize = MediaQuery.of(context).size;
      //Selected game
      if (libraryProvider.itemSelected != null) return const SelectedGame();
      //Show Game Grid
      if (libraryProvider.items.isNotEmpty)
        return Column(
          children: [
            const GridGame(),
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
                  //Install Game
                  SizedBox(
                    height: 30,
                    width: screenSize.width > 380.0 ? null : 30,
                    child: ElevatedButton(
                        onPressed: () => {
                              libraryProvider.hideItemInfo(),
                              LibraryModel.installItemModal(context),
                            },
                        child: const Text("Install Game")),
                  ),
                ],
              ),
            ),
          ],
        );
      //No games message
      else
        return const EmptyWidget();
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
                            onPressed: () {
                              DialogsModel.showAlert(
                                context,
                                title: "Not Implemented",
                                content: "This features is not implemented yet",
                              );
                            },
                            icon: Icon(
                              Icons.library_books,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                        FittedBox(
                            child: IconButton(
                          onPressed: () {
                            DialogsModel.showAlert(
                              context,
                              title: "Not Implemented",
                              content: "This features is not implemented yet",
                            );
                          },
                          icon: Icon(
                            Icons.person,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        )),
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
