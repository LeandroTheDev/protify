import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/models/launcher.dart';
import 'package:protify/components/widgets/screen_builder/arguments_command_input.dart';
import 'package:protify/components/widgets/screen_builder/launch_command_input.dart';
import 'package:protify/components/widgets/screen_builder/legacy_wineproton_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/pos_launch_command_input.dart';
import 'package:protify/components/widgets/screen_builder/select_installation_game_button.dart';
import 'package:protify/components/widgets/screen_builder/select_launcher_button.dart';
import 'package:protify/components/widgets/screen_builder/select_prefix_button.dart';
import 'package:protify/components/widgets/screen_builder/steam_compatibility_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/debug/logs.dart';
import 'package:provider/provider.dart';

class InstallItemScreen extends StatefulWidget {
  const InstallItemScreen({super.key});

  @override
  State<InstallItemScreen> createState() => _InstallGameScreenState();
}

class _InstallGameScreenState extends State<InstallItemScreen> {
  bool firstLoad = true;
  installItem(BuildContext context) async {
    final UserPreferences preferences = Provider.of<UserPreferences>(context, listen: false);
    final item = ScreenBuilderProvider.buildData(context);
    bool isTemporaryDirectory = false;

    // Validation Game Select
    if (item["SelectedItem"] == null) {
      DialogsModel.showAlert(
        context,
        title: "Nothing Select",
        content: "Consider selecting something to install...",
      );
      return;
    }
    // Validation Launcher Select
    else if (item["SelectedLauncher"] == null) {
      DialogsModel.showAlert(
        context,
        title: "Nothing Select",
        content: "Consider selecting a launcher to install something...",
      );
      return;
    }

    // Default prefix directory if not selected
    if (item["SelectedPrefix"] == null) {
      item["SelectedPrefix"] = join(preferences.protifyDirectory, "data", "temp_prefix");
      isTemporaryDirectory = true;
    }

    proceedToInstallation() {
      item["CreateItemShortcut"] = join(item["SelectedPrefix"], "pfx", "drive_c", "Games Search Directory");
      LauncherModel.launchItem(context, item);
    }

    //.iso files
    if (item["SelectedItem"].endsWith(".iso")) {
      try {
        final Directory prefixDirectory = Directory(item["SelectedPrefix"]);
        // Only deletes if is temporary directory
        if (isTemporaryDirectory) {
          try {
            //Remove old prefix
            await prefixDirectory.delete(recursive: true);
          } catch (_) {}
        }
        //Create new prefix
        prefixDirectory.createSync();
        final Directory mountDirectory = Directory(join(preferences.protifyDirectory, "data", "temp_mount"));
        // Checking if prefix folder exist
        if (!mountDirectory.existsSync()) {
          // If the mount directory does not exist create it
          mountDirectory.createSync(recursive: true);
        }
        //If exist then umount previous iso iso
        else {
          final umount = await Process.start('/bin/bash', ['-c', 'sudo -S umount "${mountDirectory.path}"']);
          umount.stderr.transform(utf8.decoder).listen((data) async {
            if (data.contains("[sudo] password for ")) {
              final password = await DialogsModel.typeInput(context, title: "Sudo Password for umount");
              umount.stdin.writeln(password);
            }
          });
          int exitCode = await umount.exitCode;
          //Error treatment
          //0 means ok, 32 means nothing mounted
          if (exitCode != 0 && exitCode != 32) {
            DialogsModel.showAlert(context, title: "Error", content: "Cannot umount old iso, error code: $exitCode");
            return;
          }
        }
        //Mount iso
        final mount = await Process.start('/bin/bash', ['-c', 'sudo -S mount -o loop "${item["SelectedItem"]}" "${mountDirectory.path}"']);
        mount.stderr.transform(utf8.decoder).listen((data) async {
          if (data.contains("[sudo] password for ")) {
            final password = await DialogsModel.typeInput(context, title: "Sudo Password for mount iso");
            mount.stdin.writeln(password);
          }
        });
        int exitCode = await mount.exitCode;
        //Error treatment
        //0 means ok
        if (exitCode != 0) {
          DialogsModel.showAlert(context, title: "Error", content: "Cannot mount iso, error code: $exitCode");
          return;
        }
        //Inform the user what he need to do
        await DialogsModel.showAlert(context, title: "Select Installer", content: "The iso sucessfully mounted, select the .exe installer now");
        //Get installer directory
        item["SelectedItem"] = await FilePicker.platform
            .pickFiles(
          allowMultiple: false,
          dialogTitle: "Select the Game",
          initialDirectory: "${mountDirectory.path}/", // The "/" is necessary so the user enter directly in the folder and not only select it
        )
            .then((file) {
          if (file == null) {
            DebugLogs.print("[Protify] Installation Canceled");
            return null;
          } else if (file.files.isEmpty) {
            DebugLogs.print("[Protify] Installation error: Empty files");
            return null;
          }
          return file.files[0].path;
        });
        // If not installer directory select dont proceed
        if (item["SelectedItem"] == null)
          return;
        // If selected proceed
        else
          proceedToInstallation();
      } catch (error) {
        DialogsModel.showAlert(context, title: "Error", content: "Cannot create prefix directory reason: $error");
        return;
      }
    }
    //.exe/.msi files
    else {
      try {
        final Directory prefixDirectory = Directory(item["SelectedPrefix"]);
        if (isTemporaryDirectory) {
          try {
            //Remove old prefix
            await prefixDirectory.delete(recursive: true);
          } catch (_) {}
        }
        //Create new prefix
        prefixDirectory.createSync();
        proceedToInstallation();
      } catch (error) {
        DialogsModel.showAlert(context, title: "Error", content: "Cannot create prefix directory reason: $error");
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
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
            //Items
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
                          'Installation Process',
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
                          onPressed: () => DialogsModel.showAlert(
                            context,
                            title: "Installation",
                            content: "Allows you to install games or programs using proton/wine in a separated temporary prefix or a selected one, also the folder Default Game Directory will be created in C: folder using the symbolic link in the preference: Default Install Search Directory",
                          ),
                        ),
                      ],
                    ),
                    //Spacer
                    const SizedBox(height: 15),
                    //Proton
                    const SelectLauncherButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Launch Command
                    const LaunchCommandInput(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Launch Command
                    const PosLaunchCommandInput(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Arguments Command
                    const ArgumentsCommandInput(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Select Game
                    const SelectInstallationGameButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Select Prefix
                    const SelectPrefixButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Steam Compatibility
                    const LegacyWineProtonCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Steam Compatibility
                    const SteamCompatibilityCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Installation Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => installItem(context),
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
      ),
    );
  }
}
