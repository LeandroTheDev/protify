import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/widgets.dart';
import 'package:protify/data/user_preferences.dart';

class InstallDll extends StatefulWidget {
  final int index;
  const InstallDll({super.key, required this.index});

  @override
  State<InstallDll> createState() => _InstallDllState();
}

class _InstallDllState extends State<InstallDll> {
  bool loaded = false;
  late final Map game;
  String dllDirectory = "";
  String dllPrefixFolder = "";
  String defaultdllPrefixFolder = "";

  void confirm(BuildContext context) async {
    try {
      // Get dll as File
      File dllFile = File(dllDirectory);
      // Get Dll Bytes
      List<int> bytes = await dllFile.readAsBytes();

      // Getting installation Path
      String installationPath = join(dllPrefixFolder == "" ? defaultdllPrefixFolder : dllPrefixFolder, dllFile.uri.pathSegments.last);

      // Declaring Installation File
      File installationFile = File(installationPath);
      // Writing Bytes into Installation File
      await installationFile.writeAsBytes(bytes);
      // ignore: use_build_context_synchronously
      Widgets.showAlert(context, title: "Sucess", content: "Sucess installing dll in: ${dllPrefixFolder == "" ? defaultdllPrefixFolder : dllPrefixFolder}");
    } catch (error) {
      // ignore: use_build_context_synchronously
      Widgets.showAlert(context, title: "Fail", content: "Cannot install dll into prefix: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    if (!loaded) {
      loaded = true;
      //Load game settings
      UserPreferences.getGames().then(
        (games) => setState(() {
          game = games[index];
          defaultdllPrefixFolder = join(games[index]["PrefixFolder"], "pfx", "drive_c", "windows", "system32");
        }),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Back Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          //Select Dlls
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Spacer
                  const SizedBox(height: 5),
                  //Screen Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dll Installation',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      //Info Button
                      IconButton(
                        icon: const Icon(Icons.info),
                        color: Theme.of(context).secondaryHeaderColor,
                        onPressed: () => Widgets.showAlert(
                          context,
                          title: "Dll Installation",
                          content: "Easily install a dll in the game prefix by selecting it in your device folder",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  //Select Dll
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Library Directory
                      Text(dllDirectory == "" ? "No Dll Selected" : basename(dllDirectory), style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                      //Spacer
                      const SizedBox(height: 5),
                      //Button
                      ElevatedButton(
                        onPressed: () => FilesystemPicker.open(
                          context: context,
                          rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/home/"),
                          fsType: FilesystemType.file,
                          folderIconColor: Theme.of(context).secondaryHeaderColor,
                        ).then((directory) => setState(() => dllDirectory = directory ?? "")),
                        child: const Text("Select Dll"),
                      ),
                    ],
                  ),
                  //Spacer
                  const SizedBox(height: 35),
                  //Installation Directory
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Library Directory
                      Text(dllPrefixFolder == "" ? "Default Installation Folder" : basename(dllPrefixFolder), style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                      //Spacer
                      const SizedBox(height: 5),
                      //Button
                      ElevatedButton(
                        onPressed: () => FilesystemPicker.open(
                          context: context,
                          rootDirectory: Directory(join(game["PrefixFolder"], "pfx", "drive_c")),
                          fsType: FilesystemType.file,
                          folderIconColor: Theme.of(context).secondaryHeaderColor,
                        ).then((directory) => setState(() => dllPrefixFolder = directory ?? "")),
                        child: const Text("Select Folder"),
                      ),
                    ],
                  ),
                  //Spacer
                  const SizedBox(height: 35),
                  //Prefix installation
                  Text(
                    'Dll Prefix Installation Directory: ${dllPrefixFolder == "" ? defaultdllPrefixFolder : dllPrefixFolder}',
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  ),
                  const SizedBox(height: 10),
                  //Confirmation Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => confirm(context),
                      child: const Text("Install"),
                    ),
                  ),
                  //Spacer
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
