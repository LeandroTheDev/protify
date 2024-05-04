import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/debug/logs.dart';

// ignore: must_be_immutable
class SelectDllInstallationButton extends StatefulWidget {
  const SelectDllInstallationButton({super.key});
  @override
  State<SelectDllInstallationButton> createState() => _SelectDllInstallationButtonState();
}

class _SelectDllInstallationButtonState extends State<SelectDllInstallationButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    // UserPreferences preferences = UserPreferences.getProvider(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selected Prefix
        Text(
          provider.datas["SelectedDllInstallation"] ?? "Default Dll Installation",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        //Spacer
        const SizedBox(height: 5),
        //Select Prefix Button
        ElevatedButton(
          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Game").then((directory) {
            if (directory == null) {
              DebugLogs.print("Canceled");
              return;
            }
            setState(
              () => provider.changeData("SelectedDllInstallation", directory),
            );
          }),
          child: const Text("Select Dll Installation"),
        ),
      ],
    );
  }
}
