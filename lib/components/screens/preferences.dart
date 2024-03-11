import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/pages/homepage.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool loaded = false;
  TextEditingController username = TextEditingController();
  TextEditingController startWindowHeight = TextEditingController();
  TextEditingController startWindowWidth = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final UserPreferences userPreferences = Provider.of<UserPreferences>(context, listen: false);
    final windowSize = MediaQuery.of(context).size;

    if (!loaded) {
      loaded = true;
      username.text = userPreferences.username;
      startWindowHeight.text = userPreferences.startWindowHeight.toString();
      startWindowWidth.text = userPreferences.startWindowWidth.toString();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Back Button
          IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          //Preferences
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: windowSize.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Spacer
                        const SizedBox(height: 5),
                        //Username
                        Column(
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
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                                  ),
                                ),
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
                              ),
                            ),
                            //Spacer
                            const SizedBox(height: 10),
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
                        //Protify Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeProtifyDirectory(directory) : () {}),
                              child: const Text("Protify Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Protify Directory",
                                content: "Where the protify launcher is located",
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Default Proton Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeDefaultProtonDirectory(directory) : () {}),
                              child: const Text("Default Proton Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Proton Directory",
                                content: "Where the protify will try to find the list of protons available",
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Default Install Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeDefaultGameInstallDirectory(directory) : () {}),
                              child: const Text("Default Install Search Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Search Install Directory",
                                content: "The main folder for finding games install in install game page",
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Default Game Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeDefaultGameDirectory(directory) : () {}),
                              child: const Text("Default Game Search Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Search Game Directory",
                                content: "The main folder for finding games in add game page",
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Default Prefix Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeDefaultPrefixDirectory(directory) : () {}),
                              child: const Text("Default Prefix Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Default Prefix Directory",
                                content: "Default prefixes will be stored in this folder",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        //Default Runtime Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeDefaultPrefixDirectory(directory) : () {}),
                              child: const Text("Default Runtime Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Default Runtime Directory",
                                content: "Default Runtimes will be stored in this folder",
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Wineprefix Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeDefaultPrefixDirectory(directory) : () {}),
                              child: const Text("Wineprefix Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Wineprefix Directory",
                                content: "This is a special folder just for Wine, actually this is not used",
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Steam Compatibility Directory
                        Row(
                          children: [
                            //Button
                            ElevatedButton(
                              onPressed: () => FilesystemPicker.open(
                                context: context,
                                rootDirectory: Platform.isWindows ? Directory("\\") : Directory("/"),
                                fsType: FilesystemType.folder,
                                folderIconColor: Theme.of(context).secondaryHeaderColor,
                              ).then((directory) => directory != null ? userPreferences.changeSteamCompatibilityDirectory(directory) : () {}),
                              child: const Text("Steam Compatibility Directory"),
                            ),
                            //Info Button
                            IconButton(
                              icon: const Icon(Icons.info),
                              color: Theme.of(context).secondaryHeaderColor,
                              onPressed: () => DialogsModel.showAlert(
                                context,
                                title: "Steam Compatibility Directory",
                                content: "Change the steam installation folder if is not located in default location \"~/.local/share/Steam\"",
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Start Window Height
                        Column(
                          children: [
                            //Input
                            SizedBox(
                              height: 48,
                              width: windowSize.width / 4,
                              child: TextField(
                                controller: startWindowHeight,
                                decoration: InputDecoration(
                                  labelText: 'Start Window Height',
                                  labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                                  ),
                                ),
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),
                            //Spacer
                            const SizedBox(height: 10),
                            //Confirm Button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                width: windowSize.width / 4 - 20,
                                height: 20,
                                child: ElevatedButton(
                                  onPressed: () => userPreferences.changeStartWindowHeight(double.parse(startWindowHeight.text)),
                                  child: const Text("Confirm"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Start Window Height
                        Column(
                          children: [
                            //Input
                            SizedBox(
                              height: 48,
                              width: windowSize.width / 4,
                              child: TextField(
                                controller: startWindowWidth,
                                decoration: InputDecoration(
                                  labelText: 'Start Window Width',
                                  labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                                  ),
                                ),
                                style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 14),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),
                            //Spacer
                            const SizedBox(height: 10),
                            //Confirm Button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                width: windowSize.width / 4 - 20,
                                height: 20,
                                child: ElevatedButton(
                                  onPressed: () => userPreferences.changeStartWindowWidth(double.parse(startWindowWidth.text)),
                                  child: const Text("Confirm"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //Spacer
                        const SizedBox(height: 30),
                        //Clear Section
                        FittedBox(
                          child: Row(
                            children: [
                              //Clear Data
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red[200]!),
                                ),
                                onPressed: () => DialogsModel.showQuestion(context, title: "Clear Data", content: "Are you sure you want to erase all saved datas?").then(
                                  //Clear data and reload data
                                  (value) => value
                                      //Clearing data
                                      ? SaveDatas.clearData().then(
                                          //Reloading data
                                          (_) => UserPreferences.loadPreference(context).then(
                                            //Reseting HomePage
                                            (value) {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                            },
                                          ),
                                        )
                                      : () {},
                                ),
                                child: const Text(
                                  "Clear Data",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              //Spacer
                              const SizedBox(width: 5),
                              //Reset Preferences
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red[200]!),
                                ),
                                onPressed: () => DialogsModel.showQuestion(context, title: "Reset Preferences", content: "Are you sure you want to reset your preferences?").then(
                                  //Clear data and reload data
                                  (value) => value
                                      //Clearing data
                                      ? SaveDatas.clearPreferences().then(
                                          //Reloading data
                                          (_) => UserPreferences.loadPreference(context).then(
                                            //Reseting HomePage
                                            (value) {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                            },
                                          ),
                                        )
                                      : () {},
                                ),
                                child: const Text(
                                  "Reset Preferences",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              //Spacer
                              const SizedBox(width: 5),
                              //Reset Preferences
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red[200]!),
                                ),
                                onPressed: () => DialogsModel.showQuestion(context, title: "Clear Games", content: "Are you sure you want to remove all games from your library?").then(
                                  //Clear games and reload launcher
                                  (value) => value
                                      //Clearing data
                                      ? SaveDatas.clearGames().then(
                                          //Reloading data
                                          (_) => {
                                            Navigator.pop(context),
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())),
                                          },
                                        )
                                      : () {},
                                ),
                                child: const Text(
                                  "Clear Games",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
