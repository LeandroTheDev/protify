import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/components/widgets/screen_builder/arguments_command_input.dart';
import 'package:protify/components/widgets/screen_builder/game_name_input.dart';
import 'package:protify/components/widgets/screen_builder/launch_command_input.dart';
import 'package:protify/components/widgets/screen_builder/nvidia_shader_compile_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/prime_run.dart';
import 'package:protify/components/widgets/screen_builder/select_game_button.dart';
import 'package:protify/components/widgets/screen_builder/select_prefix_button.dart';
import 'package:protify/components/widgets/screen_builder/select_launcher_button.dart';
import 'package:protify/components/widgets/screen_builder/select_runtime_button.dart';
import 'package:protify/components/widgets/screen_builder/select_shader_compile_button.dart';
import 'package:protify/components/widgets/screen_builder/steam_compatibility_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/steam_reaper_input.dart';
import 'package:protify/components/widgets/screen_builder/steam_wrapper_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/components/widgets/screen_builder/wine_compatibility_checkbox.dart';
import 'package:protify/data/save_datas.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);
    final LibraryProvider libraryProvider = LibraryProvider.getProvider(context);

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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Editing ${provider.datas["ItemName"] ?? "Unknown"}',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    //Spacer
                    const SizedBox(height: 15),
                    //Game Input
                    const GameNameInput(),
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
                    //Arguments Command
                    const ArgumentsCommandInput(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Select Game
                    const SelectGameButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Select Prefix
                    const SelectPrefixButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Wine Compatibility
                    const WineCompatibilityCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Steam Compatibility
                    const SteamCompatibilityCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Shader Compile
                    const NvidiaShaderCompileCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Shader Compile
                    const SelectShaderCompileButton(),
                    //Spacer
                    ScreenBuilderProvider.getListenProvider(context).datas["EnableNvidiaCompile"] == true ? const SizedBox(height: 15) : const SizedBox(),
                    //Reaper ID
                    const SteamReaperInput(),
                    //Prime run
                    const NvidiaPrimeRunCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Spacer
                    ScreenBuilderProvider.getListenProvider(context).datas["SelectedRuntime"] != null ? const SizedBox(height: 15) : const SizedBox(),
                    //Select Runtime
                    const SelectRuntimeButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Steam Wrapper
                    const SteamWrapperCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Confirmation Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          SaveDatas.readData("items", "string").then((stringItems) {
                            // Check if doesnt exist items
                            final items = jsonDecode(stringItems ?? "[]");
                            // Edit new game
                            items[libraryProvider.itemIndex] = ScreenBuilderProvider.buildData(context);
                            // Save the game
                            SaveDatas.saveData("items", jsonEncode(items));
                            libraryProvider.changeItemSelected(items[libraryProvider.itemIndex]);
                            libraryProvider.changeItems(items);
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Confirm"),
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
