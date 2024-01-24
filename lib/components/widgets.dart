import 'dart:async';

import 'package:flutter/material.dart';

class Widgets {
  /// Simple show a alert dialog to the user
  static void showAlert(
    BuildContext context, {
    String title = "",
    String content = "",
    String buttonTitle = "OK",
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5, // Define a largura desejada (metade da tela)
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              title: Text(title, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              content: Text(content, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(buttonTitle, style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                ),
              ],
            ),
          ),
        );
      },
    );
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
}
