import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/debug/logs.dart';

// ignore: must_be_immutable
class SelectDllButton extends StatefulWidget {
  const SelectDllButton({super.key});
  @override
  State<SelectDllButton> createState() => _SelectDllButtonState();
}

class _SelectDllButtonState extends State<SelectDllButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    // UserPreferences preferences = UserPreferences.getProvider(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Selected Dll
        Text(
          provider.datas["SelectedDll"] == null ? "No Dll Selected" : basename(provider.datas["SelectedDll"]),
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        //Spacer
        const SizedBox(height: 5),
        //Select DLL Button
        ElevatedButton(
          onPressed: () => FilePicker.platform.pickFiles(allowMultiple: false, dialogTitle: "Select the Game").then((file) {
            if (file == null) {
              DebugLogs.print("Canceled");
              return;
            } else if (file.files.isEmpty) {
              DebugLogs.print("Empty files");
              return;
            }
            setState(
              () => provider.changeData("SelectedDll", file.files[0].path),
            );
          }),
          child: const Text("Select Dll"),
        ),
      ],
    );
  }
}
