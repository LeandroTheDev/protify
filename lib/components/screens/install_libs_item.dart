import 'package:flutter/material.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/models/launcher.dart';
import 'package:protify/components/widgets/screen_builder/arguments_command_input.dart';
import 'package:protify/components/widgets/screen_builder/launch_command_input.dart';
import 'package:protify/components/widgets/screen_builder/nvidia_shader_compile_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/select_game_button.dart';
import 'package:protify/components/widgets/screen_builder/select_prefix_button.dart';
import 'package:protify/components/widgets/screen_builder/select_launcher_button.dart';
import 'package:protify/components/widgets/screen_builder/select_runtime_button.dart';
import 'package:protify/components/widgets/screen_builder/steam_compatibility_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/steam_reaper_input.dart';
import 'package:protify/components/widgets/screen_builder/steam_wrapper_checkbox.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';

class InstallLibsScreen extends StatefulWidget {
  const InstallLibsScreen({super.key});

  @override
  State<InstallLibsScreen> createState() => _InstallLibsScreenState();
}

class _InstallLibsScreenState extends State<InstallLibsScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);

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
                          'Library ${provider.datas["ItemName"] ?? "Unknown"}',
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
                            title: "Library Installation",
                            content: "Allows you to install and execute .exe into your prefix, like the vcruntimes,drivers, etc using proton or native wine",
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
                    //Steam Compatibility
                    const SteamCompatibilityCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Shader Compile
                    const NvidiaShaderCompileCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Reaper ID
                    const SteamReaperInput(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Select Runtime
                    const SelectRuntimeButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Steam Wrapper
                    const SteamWrapperCheckbox(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Installation Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          LauncherModel.launchItem(context, ScreenBuilderProvider.buildData(context));
                        },
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
