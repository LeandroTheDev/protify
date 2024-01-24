import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/screens/game_log.dart';
import 'package:protify/components/screens/install_libs.dart';
import 'package:protify/components/widgets.dart';

class Models {
  /// Start the game and show the logs
  static void startGame({required BuildContext context, required Map game}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GameLogScreen(game: game);
      },
    );
  }

  /// Show severall options to install libraries to the game prefix
  static void installLibs({required BuildContext context, required int index}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return InstallLibsScreen(index: index);
      },
    );
  }

  /// Show a dialog to select the protons located in the folder
  static Future<String> selectProton(BuildContext context, {bool showWine = false, bool hideProton = false}) async {
    Future<String> chooseProton(List<String> protons) async {
      Completer<String> completer = Completer<String>();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          //Default alternatives
          if (showWine && hideProton) {
            protons.add("Wine");
          } else if (showWine) {
            protons.add("Wine");
            protons.add("No Proton");
          } else {
            protons.add("No Proton");
          }
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                title: Text("Select the Proton", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                content: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ListView.builder(
                    itemCount: protons.length,
                    itemBuilder: (context, index) => TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (protons[index] == "No Proton") {
                          completer.complete("none");
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

    final directory = Directory(join(current, "protons"));

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
        Widgets.showAlert(context, title: "Alert", content: "No protons can be found, add one.");
      }
    }
    //No proton folder treatment
    else {
      Widgets.showAlert(context, title: "Error", content: "Cannot find the folder for protons in protify folder, check if the folder exist if not create one and add your protons there.");
    }
    return "none";
  }
}
