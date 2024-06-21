import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';

// ignore: must_be_immutable
class SelectShaderCompileButton extends StatefulWidget {
  const SelectShaderCompileButton({super.key});
  @override
  State<SelectShaderCompileButton> createState() => _SelectShaderCompileButtonState();
}

class _SelectShaderCompileButtonState extends State<SelectShaderCompileButton> {
  @override
  Widget build(BuildContext context) {
    ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    UserPreferences preferences = UserPreferences.getProvider(context);

    //Dependencies
    bool isVisible = ScreenBuilderProvider.getListenProvider(context).datas["EnableNvidiaCompile"] == true;

    return isVisible
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Selected Prefix
              Text(
                provider.datas["SelectedShaderCompile"] ?? "Default Shader Compile Directory",
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
              //Spacer
              const SizedBox(height: 5),
              //Select Prefix Button
              ElevatedButton(
                onPressed: () => FilePicker.platform
                    .getDirectoryPath(
                  dialogTitle: "Select the Shader Compile Directory",
                  initialDirectory: preferences.defaultPrefixDirectory,
                )
                    .then((directory) {
                  if (directory == null) {
                    DebugLogs.print("Canceled");
                    return;
                  }
                  setState(
                    () => provider.changeData("SelectedShaderCompile", directory),
                  );
                }),
                child: const Text("Select Shader Compile Directory"),
              ),
            ],
          )
        : const SizedBox();
  }
}
