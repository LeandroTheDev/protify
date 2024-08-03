import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:protify/components/screens/add_item.dart';
import 'package:protify/components/screens/edit_item.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/screens/install_dll_item.dart';
import 'package:protify/components/screens/install_item.dart';
import 'package:protify/components/screens/install_libs_item.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class LibraryModel {
  /// Create a modal for adding new item
  static Future addItemModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) => const AddItemScreen(),
    );
  }

  /// Create a modal for editing new item
  static Future<void> editItemModal(BuildContext context, int? index) async {
    if (index == null) {
      DialogsModel.showAlert(
        context,
        title: "Error Loading Game",
        content: "Cannot load the game, index is bugged",
      );
      return;
    }
    return SaveDatas.readData("items", "string").then(
      (stringGames) {
        final List items = jsonDecode(stringGames ?? "[]");
        if (items[index] == null) {
          DialogsModel.showAlert(
            context,
            title: "Error Loading Game",
            content: "Cannot load the game, the data is corrupted",
          );
          return null;
        }
        ScreenBuilderProvider.readData(context, items[index]);
        return showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).primaryColor,
          isScrollControlled: true,
          builder: (BuildContext context) => const EditItemScreen(),
        );
      },
    );
  }

  /// Create a modal for installing libraries to the item
  static Future<void> installLibsItemModal(BuildContext context, int? index) async {
    if (index == null) {
      DialogsModel.showAlert(
        context,
        title: "Error Loading Game",
        content: "Cannot load the game, index is bugged",
      );
      return;
    }
    return SaveDatas.readData("items", "string").then(
      (stringGames) {
        final List items = jsonDecode(stringGames ?? "[]");
        if (items[index] == null) {
          DialogsModel.showAlert(
            context,
            title: "Error Loading Game",
            content: "Cannot load the game, the data is corrupted",
          );
          return null;
        }
        ScreenBuilderProvider.readLibraryData(context, items[index]);
        showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).primaryColor,
          isScrollControlled: true,
          builder: (BuildContext context) => const InstallLibsScreen(),
        );
      },
    );
  }

  /// Create a modal for installing dlls to the item
  static Future<void> installDllItemModal(BuildContext context, int? index) async {
    if (index == null) {
      DialogsModel.showAlert(
        context,
        title: "Error Loading Game",
        content: "Cannot load the game, index is bugged",
      );
      return;
    }
    return SaveDatas.readData("items", "string").then(
      (stringGames) {
        final List items = jsonDecode(stringGames ?? "[]");
        if (items[index] == null) {
          DialogsModel.showAlert(
            context,
            title: "Error Loading Game",
            content: "Cannot load the game, the data is corrupted",
          );
          return null;
        }
        ScreenBuilderProvider.readDllData(context, items[index]);
        showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).primaryColor,
          isScrollControlled: true,
          builder: (BuildContext context) => const InstallDllScreen(),
        );
      },
    );
  }

  /// Create a modal for installing a new item
  static Future installItemModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) => const InstallItemScreen(),
    );
  }

  /// Show a dialog to select the launchers located in the folder
  static Future<String?> selectLauncher(
    BuildContext context,
  ) async {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    Future<Future<String?>> chooseProton(List<String> protons) async {
      Completer<String?> completer = Completer<String?>();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Wine option
          protons.add("Wine");
          protons.add("None");
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text("Select the Launcher", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                content: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ListView.builder(
                    itemCount: protons.length,
                    itemBuilder: (context, index) => TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (protons[index] == "None") {
                          completer.complete(null);
                        } else {
                          completer.complete(protons[index]);
                        }
                      },
                      child: Text(protons[index], style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      return completer.future;
    }

    final directory = Directory(preferences.defaultProtonDirectory);

    List<String> protons = [];
    //Check if proton folder exist
    if (directory.existsSync()) {
      final folders = directory.listSync().whereType<Directory>();
      //Check if is not empty
      if (folders.isNotEmpty) {
        for (final proton in folders) {
          //Add proton to the list
          protons.add(proton.uri.pathSegments[proton.uri.pathSegments.length - 2]);
        }
        //Show dialog to choose the proton
        return await chooseProton(protons);
      }
      //Empty treatment
      else {
        // DialogsModel.showAlert(context, title: "Alert", content: "No protons can be found, add one.");
        return await chooseProton(protons);
      }
    }
    //No proton folder treatment
    else {
      // DialogsModel.showAlert(context, title: "Error", content: "Cannot find the folder for protons in protify folder, check if the folder exist if not create one and add your protons there.");
      return await chooseProton(protons);
    }
  }

  /// Show a dialog to select the protons located in the folder
  static Future<String?> selectRuntime(BuildContext context) async {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    Future<String?> chooseRuntime(List<String> runtimes) async {
      Completer<String?> completer = Completer<String?>();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          runtimes.add("No Runtime");
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text("Select the Runtime", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                content: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ListView.builder(
                    itemCount: runtimes.length,
                    itemBuilder: (context, index) => TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (runtimes[index] == "No Runtime") {
                          completer.complete(null);
                        } else {
                          completer.complete(runtimes[index]);
                        }
                      },
                      child: Text(runtimes[index], style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      return completer.future;
    }

    final directory = Directory(preferences.defaultRuntimeDirectory);

    List<String> runtimes = [];
    //Check if proton folder exist
    if (directory.existsSync()) {
      final folders = directory.listSync().whereType<Directory>();
      //Check if is not empty
      if (folders.isNotEmpty) {
        for (final proton in folders) {
          //Add proton to the list
          runtimes.add(proton.uri.pathSegments[proton.uri.pathSegments.length - 2]);
        }
        //Show dialog to choose the proton
        return await chooseRuntime(runtimes);
      }
      //Empty treatment
      else {
        DialogsModel.showAlert(context, title: "Alert", content: "No runtimes can be found, add one.");
      }
    }
    //No proton folder treatment
    else {
      DialogsModel.showAlert(context, title: "Error", content: "Cannot find the folder for runtimes in runtimes folder, check if the folder exist if not create one and add your runtimes there.");
    }
    return "none";
  }

  /// Show a dialog to select the protons located in the folder, need the list of categories
  static Future<String> selectCategory(BuildContext context, {required Map<String, List<int>> categories, bool disableNew = false}) async {
    Future<String> chooseCategory(List<String> categoriesList) async {
      Completer<String> completer = Completer<String>();
      if (!disableNew) categoriesList.add("Add New Category");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text("Select the Category", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                content: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ListView.builder(
                    itemCount: categoriesList.length,
                    itemBuilder: (context, index) => TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (categoriesList[index] == "Add New Category") {
                          completer.complete(DialogsModel.typeInput(context, title: "Category"));
                        } else {
                          completer.complete(categoriesList[index]);
                        }
                      },
                      child: Text(categoriesList[index], style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      return completer.future;
    }

    return await chooseCategory(categories.keys.toList());
  }
}
