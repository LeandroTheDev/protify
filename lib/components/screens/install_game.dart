// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';
// import 'dart:io';

// import 'package:filesystem_picker/filesystem_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:protify/components/models.dart';
// import 'package:protify/components/widgets/dialogs.dart';
// import 'package:protify/data/user_preferences.dart';
// import 'package:provider/provider.dart';

// class InstallGameScreen extends StatefulWidget {
//   const InstallGameScreen({super.key});

//   @override
//   State<InstallGameScreen> createState() => _InstallGameScreenState();
// }

// class _InstallGameScreenState extends State<InstallGameScreen> {
//   TextEditingController gameArguments = TextEditingController();
//   String gameDirectory = "";
//   String gameProton = "none";
//   bool gameSteamCompatibility = false;
//   bool gameProtonScript = false;
//   @override
//   Widget build(BuildContext context) {
//     final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
//     return Padding(
//       padding: const EdgeInsets.only(
//         left: 8.0,
//         right: 8.0,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           //Back Button
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: Theme.of(context).secondaryHeaderColor,
//             ),
//           ),
//           //Select Library
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //Spacer
//                   const SizedBox(height: 5),
//                   //Screen Title
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       //Title
//                       Text(
//                         'Game Installation',
//                         style: TextStyle(
//                           color: Theme.of(context).secondaryHeaderColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                       //Info Button
//                       IconButton(
//                         icon: const Icon(Icons.info),
//                         color: Theme.of(context).secondaryHeaderColor,
//                         onPressed: () => DialogsModel.showAlert(
//                           context,
//                           title: "Game Installation",
//                           content: "Allows you to install .exe/.iso into your default game search directory, a directory will be created in C:\\ named Game Search Directory, select the installer to install there and the game will be installed on Game Search Directory correctly",
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 35),
//                   //Select Installer
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //Installer Directory
//                       Text(gameDirectory == "" ? "No Installer Selected" : basename(gameDirectory), style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
//                       //Spacer
//                       const SizedBox(height: 5),
//                       //Button
//                       ElevatedButton(
//                         onPressed: () => FilesystemPicker.open(
//                           context: context,
//                           rootDirectory: Directory(preferences.defaultGameInstallDirectory),
//                           fsType: FilesystemType.file,
//                           folderIconColor: Theme.of(context).secondaryHeaderColor,
//                         ).then((directory) => setState(() => gameDirectory = directory ?? "")),
//                         child: const Text("Select Installer"),
//                       ),
//                     ],
//                   ),
//                   //Spacer
//                   const SizedBox(height: 35),
//                   //Select Proton
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //Selected Proton
//                       Text(
//                         gameProton == "none" ? "Wine" : gameProton,
//                         style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
//                       ),
//                       //Spacer
//                       const SizedBox(height: 5),
//                       //Select Proton Button
//                       ElevatedButton(
//                         onPressed: () => DialogsModel.selectProton(context, showWine: true, hideProton: true).then(
//                           (selectedProton) => setState(() => gameProton = selectedProton),
//                         ),
//                         child: const Text("Select Proton/Wine"),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 35),
//                   //Installer Arguments
//                   SizedBox(
//                     height: 60,
//                     child: TextField(
//                       controller: gameArguments,
//                       decoration: InputDecoration(
//                         labelText: 'Installer Arguments',
//                         labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary), // Cor da borda inferior quando o campo não está focado
//                         ),
//                       ),
//                       style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 20),
//                     ),
//                   ),
//                   const SizedBox(height: 35),
//                   //Steam Compatibility
//                   FittedBox(
//                     child: Row(
//                       children: [
//                         //Checkbox
//                         Checkbox(
//                           value: gameSteamCompatibility,
//                           onChanged: (value) => setState(() => gameSteamCompatibility = value!),
//                           //Fill Color
//                           fillColor: MaterialStateProperty.resolveWith(
//                             (states) {
//                               if (states.contains(MaterialState.selected)) {
//                                 return Theme.of(context).colorScheme.secondary;
//                               }
//                               return null;
//                             },
//                           ),
//                           //Check Color
//                           checkColor: Theme.of(context).colorScheme.tertiary,
//                           //Border Color
//                           side: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 2.0),
//                         ),
//                         //Text
//                         Text("Enable Steam Compatibility", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
//                         //Info Button
//                         IconButton(
//                           icon: const Icon(Icons.info),
//                           color: Theme.of(context).secondaryHeaderColor,
//                           onPressed: () => DialogsModel.showAlert(
//                             context,
//                             title: "Steam Compatibility",
//                             content: "Enables steam compatibility making the game open with STEAM_COMPAT_CLIENT_INSTALL_PATH to use the official protons",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   //Python Script
//                   FittedBox(
//                     child: Row(
//                       children: [
//                         //Checkbox
//                         Checkbox(
//                           value: gameProtonScript,
//                           onChanged: (value) => setState(() => gameProtonScript = value!),
//                           //Fill Color
//                           fillColor: MaterialStateProperty.resolveWith(
//                             (states) {
//                               if (states.contains(MaterialState.selected)) {
//                                 return Theme.of(context).colorScheme.secondary;
//                               }
//                               return null;
//                             },
//                           ),
//                           //Check Color
//                           checkColor: Theme.of(context).colorScheme.tertiary,
//                           //Border Color
//                           side: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 2.0),
//                         ),
//                         //Text
//                         Text("Enable Proton Script", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
//                         //Info Button
//                         IconButton(
//                           icon: const Icon(Icons.info),
//                           color: Theme.of(context).secondaryHeaderColor,
//                           onPressed: () => DialogsModel.showAlert(
//                             context,
//                             title: "Python Script",
//                             content: "Start the proton with the python script",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   //Confirmation Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         proceedToInstallation(gamePrefixDirectory) {
//                           Models.startGame(context: context, game: {
//                             //gameProton == "none": "none"
//                             //gameProton == "Wine": "wine"
//                             //everthing else return the directory to the proton folder
//                             "ProtonDirectory": gameProton == "none"
//                                 ? null
//                                 : gameProton == "Wine"
//                                     ? "wine"
//                                     : join(preferences.defaultProtonDirectory, gameProton),
//                             "EnableSteamCompatibility": gameSteamCompatibility,
//                             "EnableProtonScript": gameProtonScript,
//                             "PrefixFolder": gamePrefixDirectory,
//                             "LaunchDirectory": gameDirectory,
//                             "ArgumentsCommand": gameArguments.text,
//                             "CreateGameShortcut": join(gamePrefixDirectory, "pfx", "drive_c", "Games Search Directory"),
//                           });
//                         }

//                         final gamePrefixDirectory = join(preferences.protifyDirectory, "data", "temp_prefix");
//                         //.iso files
//                         if (gameDirectory.endsWith(".iso")) {
//                           try {
//                             final Directory prefixDirectory = Directory(gamePrefixDirectory);
//                             try {
//                               //Remove old prefix
//                               prefixDirectory.deleteSync(recursive: true);
//                             } catch (_) {}
//                             //Create new prefix
//                             prefixDirectory.createSync();
//                             final Directory mountDirectory = Directory(join(preferences.protifyDirectory, "data", "temp_mount"));
//                             // Checking if prefix folder exist
//                             if (!mountDirectory.existsSync()) {
//                               // Se o diretório de montagem não existir, crie-o
//                               mountDirectory.createSync(recursive: true);
//                             }
//                             //If exist then umount previous iso iso
//                             else {
//                               final umount = await Process.start('/bin/bash', ['-c', 'sudo -S umount "${mountDirectory.path}"']);
//                               umount.stderr.transform(utf8.decoder).listen((data) async {
//                                 if (data.contains("[sudo] password for ")) {
//                                   final password = await DialogsModel.typeInput(context, title: "Sudo Password for umount");
//                                   umount.stdin.writeln(password);
//                                 }
//                               });
//                               int exitCode = await umount.exitCode;
//                               //Error treatment
//                               //0 means ok, 32 means nothing mounted
//                               if (exitCode != 0 && exitCode != 32) {
//                                 DialogsModel.showAlert(context, title: "Error", content: "Cannot umount old iso, error code: $exitCode");
//                                 return;
//                               }
//                             }
//                             //Mount iso
//                             final mount = await Process.start('/bin/bash', ['-c', 'sudo -S mount -o loop "$gameDirectory" "${mountDirectory.path}"']);
//                             mount.stderr.transform(utf8.decoder).listen((data) async {
//                               if (data.contains("[sudo] password for ")) {
//                                 final password = await DialogsModel.typeInput(context, title: "Sudo Password for mount iso");
//                                 mount.stdin.writeln(password);
//                               }
//                             });
//                             int exitCode = await mount.exitCode;
//                             //Error treatment
//                             //0 means ok
//                             if (exitCode != 0) {
//                               DialogsModel.showAlert(context, title: "Error", content: "Cannot mount iso, error code: $exitCode");
//                               return;
//                             }
//                             //Inform the user what he need to do
//                             await DialogsModel.showAlert(context, title: "Select Installer", content: "The iso sucessfully mounted, select the .exe installer now");
//                             //Get installer directory
//                             gameDirectory = await FilesystemPicker.open(
//                                   context: context,
//                                   rootDirectory: mountDirectory,
//                                   fsType: FilesystemType.file,
//                                   folderIconColor: Theme.of(context).secondaryHeaderColor,
//                                 ) ??
//                                 "";
//                             if (gameDirectory == "") {
//                               return;
//                             }
//                             proceedToInstallation(gamePrefixDirectory);
//                           } catch (error) {
//                             DialogsModel.showAlert(context, title: "Error", content: "Cannot create prefix directory reason: $error");
//                             return;
//                           }
//                         }
//                         //.exe files
//                         else {
//                           try {
//                             final Directory prefixDirectory = Directory(gamePrefixDirectory);
//                             try {
//                               //Remove old prefix
//                               prefixDirectory.deleteSync(recursive: true);
//                             } catch (_) {}
//                             //Create new prefix
//                             prefixDirectory.createSync();
//                             proceedToInstallation(gamePrefixDirectory);
//                           } catch (error) {
//                             DialogsModel.showAlert(context, title: "Error", content: "Cannot create prefix directory reason: $error");
//                             return;
//                           }
//                         }
//                       },
//                       child: const Text("Confirm"),
//                     ),
//                   ),
//                   //Spacer
//                   const SizedBox(height: 25),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
