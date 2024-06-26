import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';

// ignore: must_be_immutable
class SelectGameButton extends StatefulWidget {
  const SelectGameButton({super.key});
  @override
  State<SelectGameButton> createState() => _SelectGameButtonState();
}

class _SelectGameButtonState extends State<SelectGameButton> {
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    UserPreferences preferences = UserPreferences.getProvider(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selected Launcher
        Text(
          provider.datas["SelectedItem"] == null ? "No Game Selected" : basename(provider.datas["SelectedItem"]),
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        //Spacer
        const SizedBox(height: 5),
        //Select Launcher Button
        ElevatedButton(
          onPressed: () {
            // If is already clicked ignore subsequent
            if(busy) return;
            busy = true;
            
            FilePicker.platform
              .pickFiles(
            allowMultiple: false,
            dialogTitle: "Select the Game",
            initialDirectory: preferences.defaultGameDirectory,
          )
              .then((file) {
                busy = false;
            if (file == null) {
              DebugLogs.print("[Select Game] Canceled");
              return;
            } else if (file.files.isEmpty) {
              DebugLogs.print("[Select Game] Empty files");
              return;
            }
            setState(
              () => provider.changeData("SelectedItem", file.files[0].path),
            );
          });
          },
          child: const Text("Select Game"),
        ),
      ],
    );
  }
}
