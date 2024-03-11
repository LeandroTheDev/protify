import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/components/models/dialogs.dart';
import 'package:protify/components/widgets/screen_builder/select_dll_button.dart';
import 'package:protify/components/widgets/screen_builder/select_dll_installation_button.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/debug/logs.dart';

class InstallDllScreen extends StatefulWidget {
  const InstallDllScreen({super.key});

  @override
  State<InstallDllScreen> createState() => _InstallDllScreenState();
}

class _InstallDllScreenState extends State<InstallDllScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenBuilderProvider provider = ScreenBuilderProvider.getProvider(context);

    void confirm(BuildContext context) async {
      try {
        // Error Treatment
        if (provider.datas["SelectedDll"] == null) {
          DialogsModel.showAlert(
            context,
            title: "Invalid Dll",
            content: "You cannot install a dll into prefix without a dll",
          );
          return;
        }
        // Get dll as File
        File dllFile = File(provider.datas["SelectedDll"]);
        // Get Dll Bytes
        List<int> bytes = await dllFile.readAsBytes();

        // Getting installation Path
        String installationPath = join(provider.datas["SelectedDllInstallation"] ?? join(provider.datas["SelectedPrefix"], "pfx", "drive_c", "windows"), dllFile.uri.pathSegments.last);

        // Declaring Installation File
        File installationFile = File(installationPath);
        // Writing Bytes into Installation File
        await installationFile.writeAsBytes(bytes);
        // ignore: use_build_context_synchronously
        DialogsModel.showAlert(context, title: "Sucess", content: "Sucess installing dll in: $installationPath");
      } catch (error) {
        // ignore: use_build_context_synchronously
        DialogsModel.showAlert(context, title: "Fail", content: "Cannot install dll into prefix: $error");
      }
    }

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
                          'Dll ${provider.datas["ItemName"] ?? "Unknown"}',
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
                            title: "Dll Installation",
                            content: "Easily install a dll in the game prefix by selecting the dll",
                          ),
                        ),
                      ],
                    ),
                    //Spacer
                    const SizedBox(height: 15),
                    //Select Dll
                    const SelectDllButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Select Dll Installation
                    const SelectDllInstallationButton(),
                    //Spacer
                    const SizedBox(height: 15),
                    //Installation Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          DebugLogs.print("Starting Dll Installation");
                          confirm(context);
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
