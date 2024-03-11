import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

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
          onPressed: () => FilesystemPicker.open(
            context: context,
            rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
            fsType: FilesystemType.folder,
            folderIconColor: Theme.of(context).secondaryHeaderColor,
          ).then((selectedPrefix) => setState(
                () => provider.changeData("SelectedDllInstallation", selectedPrefix),
              )),
          child: const Text("Select Dll Installation"),
        ),
      ],
    );
  }
}
