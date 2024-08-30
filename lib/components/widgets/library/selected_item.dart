import 'package:flutter/material.dart';
import 'package:protify/components/models/launcher.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';

class SelectedItem extends StatelessWidget {
  const SelectedItem({super.key});

  @override
  Widget build(BuildContext context) {
    final LibraryProvider libraryProvider = LibraryProvider.getProviderListenable(context);
    final screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        IconButton(
          onPressed: () => {libraryProvider.clearItemSelection(), libraryProvider.updateScreen()},
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        // Game Title
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
                  libraryProvider.itemSelected["ItemName"] ?? "Unknown",
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
              ),
            ),
          ),
        ),
        // Title Buttons
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
                    onPressed: () => LauncherModel.launchItem(context),
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
                    onPressed: () => LibraryModel.editItemModal(context, libraryProvider.itemIndex).then((value) => libraryProvider.updateScreen()),
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
        // Library
        libraryProvider.itemSelected["SelectedLauncher"] != null
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
                          onPressed: () => LibraryModel.installLibsItemModal(context, libraryProvider.itemIndex),
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
        // Dlls
        libraryProvider.itemSelected["SelectedLauncher"] != null
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
                          onPressed: () => LibraryModel.installDllItemModal(context, libraryProvider.itemIndex),
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
        // Winetricks
        libraryProvider.itemSelected["SelectedLauncher"] != null
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
                          onPressed: () => LibraryModel.runWinetricksIntoPrefix(context, libraryProvider.itemIndex),
                          child: const FittedBox(
                            child: Text(
                              "Winetricks",
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
        // Create shortcut
        Padding(
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
                    onPressed: () => LibraryModel.createShortcutForTheUser(context, libraryProvider.itemIndex),
                    child: const FittedBox(
                      child: Text(
                        "Shortcut",
                        style: TextStyle(fontSize: 999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Remove item
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: screenSize.width * 0.7 - 23,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Remove Item
                SizedBox(
                  width: screenSize.width * 0.15 < 56 ? 56 : screenSize.width * 0.15,
                  height: screenSize.height * 0.07,
                  child: ElevatedButton(
                    onPressed: () {
                      final int previousQuantity = libraryProvider.items.length;
                      UserPreferences.removeItem(libraryProvider.itemIndex, libraryProvider.items, context).then((items) {
                        // Check if the games was removed
                        if (previousQuantity > items.length) {
                          DebugLogs.print("[Library] Item removed: ${libraryProvider.itemIndex}");
                          libraryProvider.clearItemSelection();
                          libraryProvider.updateScreen();
                        }
                      });
                    },
                    child: const FittedBox(
                      child: Text(
                        "Remove",
                        style: TextStyle(fontSize: 999),
                      ),
                    ),
                  ),
                ),
                //Empty
                const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
