import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/models/library.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';
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
    final LibraryProvider libraryProvider = LibraryProvider.getProvider(context);
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
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Game").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Protify Directory Canceled");
                              return;
                            }
                            userPreferences.changeProtifyDirectory(directory);
                          }),
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
                    //Default Launcher Directory
                    Row(
                      children: [
                        //Button
                        ElevatedButton(
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Launcher").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Launcher Directory Canceled");
                              return;
                            }
                            userPreferences.changeDefaultProtonDirectory(directory);
                          }),
                          child: const Text("Default Launcher Directory"),
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
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Install Directory").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Install Directory Canceled");
                              return;
                            }
                            userPreferences.changeDefaultGameInstallDirectory(directory);
                          }),
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
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Game").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Game Directory Canceled");
                              return;
                            }
                            userPreferences.changeDefaultGameDirectory(directory);
                          }),
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
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Game").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Prefix Directory Canceled");
                              return;
                            }
                            userPreferences.changeDefaultPrefixDirectory(directory);
                          }),
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
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Game").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Runtime Directory Canceled");
                              return;
                            }
                            userPreferences.changeDefaultRuntimeDirectory(directory);
                          }),
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
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Wineprefix Directory").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Wineprefix Directory Canceled");
                              return;
                            }
                            userPreferences.changeDefaultWineprefixDirectory(directory);
                          }),
                          child: const Text("Wineprefix Directory"),
                        ),
                        //Info Button
                        IconButton(
                          icon: const Icon(Icons.info),
                          color: Theme.of(context).secondaryHeaderColor,
                          onPressed: () => DialogsModel.showAlert(
                            context,
                            title: "Wineprefix Directory",
                            content: "In some cases the proton should use the wine folder for some reason, so setting this when this happens the wine folder will be created here and not in home folder.",
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
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Steam Compatibility Directory").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Steam Compatibility Directory Canceled");
                              return;
                            }
                            userPreferences.changeSteamCompatibilityDirectory(directory);
                          }),
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
                    //Shader Compile Directory
                    Row(
                      children: [
                        //Button
                        ElevatedButton(
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Default Shader Compile Directory").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] Shader Compile Directory Canceled");
                              return;
                            }
                            userPreferences.changeSteamCompatibilityDirectory(directory);
                          }),
                          child: const Text("Default Shader Compile Directory"),
                        ),
                        //Info Button
                        IconButton(
                          icon: const Icon(Icons.info),
                          color: Theme.of(context).secondaryHeaderColor,
                          onPressed: () => DialogsModel.showAlert(
                            context,
                            title: "Shader Compile Directory",
                            content: "Default Compilations from Shaders will be stored in this folder",
                          ),
                        ),
                      ],
                    ),
                    //Spacer
                    const SizedBox(height: 30),
                    //EAC Runtime Directory
                    Row(
                      children: [
                        //Button
                        ElevatedButton(
                          onPressed: () => FilePicker.platform.getDirectoryPath(dialogTitle: "Select the Default EAC Runtime Directory").then((directory) {
                            if (directory == null) {
                              DebugLogs.print("[Protify] EAC Runtime Directory Canceled");
                              return;
                            }
                            userPreferences.changeSteamCompatibilityDirectory(directory);
                          }),
                          child: const Text("Default EAC Runtime Directory"),
                        ),
                        //Info Button
                        IconButton(
                          icon: const Icon(Icons.info),
                          color: Theme.of(context).secondaryHeaderColor,
                          onPressed: () => DialogsModel.showAlert(
                            context,
                            title: "EAC Runtime Directory",
                            content: "Default EAC Runtime directory for using with Easy Anti Cheat compatibility.",
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
                    //Default Category
                    Row(
                      children: [
                        //Button
                        ElevatedButton(
                          onPressed: () => LibraryModel.selectCategory(context, categories: libraryProvider.itemsCategories, disableNew: true).then(
                            // Update the Category
                            (category) => userPreferences.changeDefaultCategory(category),
                          ),
                          child: const Text("Change Default Category"),
                        ),
                        //Info Button
                        IconButton(
                          icon: const Icon(Icons.info),
                          color: Theme.of(context).secondaryHeaderColor,
                          onPressed: () => DialogsModel.showAlert(
                            context,
                            title: "Default Category",
                            content: "The default category to show up when opening the protify",
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
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.red[200]!),
                            ),
                            onPressed: () => DialogsModel.showQuestion(context, title: "Clear Data", content: "Are you sure you want to erase all saved datas?").then(
                              //Clear data and reload data
                              (value) => value
                                  //Clearing preferences
                                  ? SaveDatas.removeData("preferences").then(
                                      // Cleaning items
                                      (_) => SaveDatas.removeData("items").then(
                                        //Reloading data
                                        (_) => UserPreferences.loadPreference(context).then(
                                          //Reseting HomePage
                                          (value) {
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                            LibraryProvider.getProvider(context).changeScreenUpdate(true);
                                            LibraryProvider.getProvider(context).updateScreen();
                                          },
                                        ),
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
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.red[200]!),
                            ),
                            onPressed: () => DialogsModel.showQuestion(context, title: "Reset Preferences", content: "Are you sure you want to reset your preferences?").then(
                              //Clear data and reload data
                              (value) => value
                                  //Clearing data
                                  ? SaveDatas.removeData("preferences").then(
                                      //Reloading data
                                      (_) => UserPreferences.loadPreference(context).then(
                                        //Reseting HomePage
                                        (value) {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                          LibraryProvider.getProvider(context).changeScreenUpdate(true);
                                          LibraryProvider.getProvider(context).updateScreen();
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
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.red[200]!),
                            ),
                            onPressed: () => DialogsModel.showQuestion(context, title: "Clear Items", content: "Are you sure you want to remove all items from your library?").then(
                              //Clear games and reload launcher
                              (value) => value
                                  //Clearing data
                                  ? SaveDatas.removeData("items").then(
                                      //Reloading data
                                      (_) {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                        LibraryProvider.getProvider(context).changeScreenUpdate(true);
                                        LibraryProvider.getProvider(context).updateScreen();
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
