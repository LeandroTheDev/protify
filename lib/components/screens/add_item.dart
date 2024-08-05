import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/components/widgets/screen_builder/arguments_command_input.dart';
import 'package:protify/components/widgets/screen_builder/eac_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/game_name_input.dart';
import 'package:protify/components/widgets/screen_builder/launch_command_input.dart';
import 'package:protify/components/widgets/screen_builder/nvidia_shader_compile_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/pos_launch_command_input.dart';
import 'package:protify/components/widgets/screen_builder/prime_run_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/select_eac_runtime_button.dart';
import 'package:protify/components/widgets/screen_builder/select_game_button.dart';
import 'package:protify/components/widgets/screen_builder/select_prefix_button.dart';
import 'package:protify/components/widgets/screen_builder/select_launcher_button.dart';
import 'package:protify/components/widgets/screen_builder/select_runtime_button.dart';
import 'package:protify/components/widgets/screen_builder/select_shader_compile_button.dart';
import 'package:protify/components/widgets/screen_builder/steam_compatibility_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/steam_reaper_id_input.dart';
import 'package:protify/components/widgets/screen_builder/steam_wrapper_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/components/widgets/screen_builder/wine_compatibility_checkbox.dart';
import 'package:protify/data/save_datas.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool firstLoad = true;
  @override
  Widget build(BuildContext context) {
    if (firstLoad) ScreenBuilderProvider.resetProviderDatas(context);
    firstLoad = false;

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
                        'Adding a Game',
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
                    //Launch Command
                    const PosLaunchCommandInput(),
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
                    //Prime run
                    const NvidiaPrimeRunCheckbox(),
                    // Spacer
                    const SizedBox(height: 15),
                    // Easy Anti Cheat
                    const EacCheckbox(),
                    // Spacer
                    ScreenBuilderProvider.getListenProvider(context).datas["EnableEACRuntime"] != false ? const SizedBox(height: 15) : const SizedBox(),
                    //Select Runtime
                    const SelectEACRuntimeButton(),
                    // Spacer
                    const SizedBox(height: 15),
                    //Select Runtime
                    const SelectRuntimeButton(),
                    // Spacer
                    const SizedBox(height: 15),
                    //Reaper ID
                    ScreenBuilderProvider.getListenProvider(context).datas["SelectedRuntime"] != null ? const SteamReaperInputID() : const SizedBox(),
                    //Steam Wrapper
                    const SteamWrapperCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Confirmation Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          SaveDatas.readData("items", "user").then((stringItem) {
                            // Check if doesnt exist games
                            final items = jsonDecode(stringItem ?? "[]");
                            // Create default variables and build the data
                            ScreenBuilderProvider.readData(context, ScreenBuilderProvider.buildData(context));
                            final item = ScreenBuilderProvider.buildData(context);

                            // Add the new game
                            items.add(item);
                            // Save the game
                            SaveDatas.saveData("items", "user", jsonEncode(items));
                            Navigator.pop(context);
                            LibraryProvider.getProvider(context).changeScreenUpdate(true);
                            LibraryProvider.getProvider(context).updateScreen();
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
