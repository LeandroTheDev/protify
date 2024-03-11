import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/user_preferences.dart';

// ignore: must_be_immutable
class SelectGameButton extends StatefulWidget {
  const SelectGameButton({super.key});
  @override
  State<SelectGameButton> createState() => _SelectGameButtonState();
}

class _SelectGameButtonState extends State<SelectGameButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    UserPreferences preferences = UserPreferences.getProvider(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selected Launcher
        Text(
          provider.datas["SelectedGame"] == null ? "No Game Selected" : basename(provider.datas["SelectedGame"]),
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        //Spacer
        const SizedBox(height: 5),
        //Select Launcher Button
        ElevatedButton(
          onPressed: () => FilesystemPicker.open(
            context: context,
            rootDirectory: Directory(preferences.defaultGameDirectory),
            fsType: FilesystemType.file,
            folderIconColor: Theme.of(context).secondaryHeaderColor,
          ).then((selectedGame) => setState(
                () => provider.changeData("SelectedGame", selectedGame),
              )),
          child: const Text("Select Game"),
        ),
      ],
    );
  }
}
