import 'dart:async';

import 'package:flutter/material.dart';

class DialogsModel {
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
              backgroundColor: Theme.of(context).primaryColor,
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

  /// Show a prompt to user type something
  static Future<String> typeInput(BuildContext context, {title = ""}) {
    Completer<String> completer = Completer<String>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController input = TextEditingController();
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                title: Column(
                  children: [
                    TextField(
                      controller: input,
                      decoration: InputDecoration(
                        labelText: title,
                        labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary), // Cor da borda inferior quando o campo não está focado
                        ),
                      ),
                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
                    ),
                    // Spacer
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => {
                        completer.complete(input.text),
                        Navigator.pop(context),
                      },
                      child: const Text("Confirm"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    return completer.future;
  }

  /// If this variable is true this means the loading widget is enabled
  static bool isLoading = false;

  /// Simple show a loading dialog to the user, if no buttonTitle
  /// is provided the dialog will not return in case of manually clicked
  static Future showLoading(
    BuildContext context, {
    String title = "Loading",
    String content = "This will take a while...",
    String? buttonTitle,
  }) {
    isLoading = true;
    Completer<void> completer = Completer<void>();
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(title, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(content, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ],
              ),
              actions: [
                buttonTitle != null
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          completer.complete();
                        },
                        child: Text(buttonTitle, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    ).then((_) => isLoading = false);
    return completer.future;
  }
}
