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
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(buttonTitle),
            ),
          ],
        );
      },
    );
  }
}
