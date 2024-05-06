import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';

// ignore: must_be_immutable
class SelectPrefixButton extends StatefulWidget {
  const SelectPrefixButton({super.key});
  @override
  State<SelectPrefixButton> createState() => _SelectPrefixButtonState();
}

class _SelectPrefixButtonState extends State<SelectPrefixButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    UserPreferences preferences = UserPreferences.getProvider(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selected Prefix
        Text(
          provider.datas["SelectedPrefix"] ?? "Default Prefix",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        //Spacer
        const SizedBox(height: 5),
        //Select Prefix Button
        ElevatedButton(
          onPressed: () => FilePicker.platform
              .getDirectoryPath(
            dialogTitle: "Select the Prefix Directory",
            initialDirectory: preferences.defaultPrefixDirectory,
          )
              .then((directory) {
            if (directory == null) {
              DebugLogs.print("Canceled");
              return;
            }
            setState(
              () => provider.changeData("SelectedPrefix", directory),
            );
          }),
          child: const Text("Select Prefix"),
        ),
      ],
    );
  }
}
