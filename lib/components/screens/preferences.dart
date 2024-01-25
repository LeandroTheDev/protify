import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:protify/components/widgets.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final String defaultDirectory = Platform.isWindows ? "\\" : "/home/";
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final UserPreferences userPreferences = Provider.of<UserPreferences>(context, listen: false);
    final windowSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
            //Preferences
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Spacer
                        const SizedBox(height: 5),
                        //Username
                        Row(
                          children: [
                            //Input
                            SizedBox(
                              height: 60,
                              width: windowSize.width / 2,
                              child: TextField(
                                controller: username,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Cor da borda inferior quando o campo não está focado
                                  ),
                                ),
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
                              ),
                            ),
                            //Confirm Button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                width: windowSize.width / 2 - 40,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () => userPreferences.changeUsername(username.text),
                                  child: const Text("Confirm"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Default Directory
                        ElevatedButton(
                          onPressed: () => FilesystemPicker.open(
                            context: context,
                            rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                            fsType: FilesystemType.folder,
                            folderIconColor: Theme.of(context).secondaryHeaderColor,
                          ).then((directory) => userPreferences.changeDefaultGameDirectory(directory ?? defaultDirectory)),
                          child: const Text("Default Game Directory"),
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Clear data
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red[200]!),
                          ),
                          onPressed: () => Widgets.showQuestion(context, title: "Clear Data", content: "Are you sure you want to erase all saved datas?").then(
                            (value) => value ? SaveDatas.clearData() : () {},
                          ),
                          child: const Text(
                            "Clear Data",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
