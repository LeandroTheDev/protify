import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

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
          onPressed: () => FilesystemPicker.open(
            context: context,
            rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
            fsType: FilesystemType.file,
            folderIconColor: Theme.of(context).secondaryHeaderColor,
          ).then((selectedDll) => setState(
                () => provider.changeData("SelectedDll", selectedDll),
              )),
          child: const Text("Select Dll"),
        ),
      ],
    );
  }
}
