import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class Widgets {
  /// Simple show a alert dialog to the user
  static Future showAlert(
    BuildContext context, {
    String title = "",
    String content = "",
    String buttonTitle = "OK",
  }) {
    Completer<void> completer = Completer<void>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: Text(title, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              content: Text(content, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    completer.complete();
                  },
                  child: Text(buttonTitle, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                ),
              ],
            ),
          ),
        );
      },
    );
    return completer.future;
  }

  /// Simple show a alert dialog to the user
  static Future<bool> showQuestion(
    BuildContext context, {
    String title = "",
    String content = "",
    String buttonTitle = "Yes",
    String buttonTitle2 = "No",
  }) {
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: Text(title, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              content: Text(content, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              actions: [
                //yes
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    completer.complete(true);
                  },
                  child: Text(buttonTitle, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                ),
                //no
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    completer.complete(false);
                  },
                  child: Text(buttonTitle2, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                ),
              ],
            ),
          ),
        );
      },
    );

    return completer.future;
  }

  /// Show a dialog to select the protons located in the folder
  static Future<String> selectProton(BuildContext context, {bool showWine = false, bool hideProton = false}) async {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
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
