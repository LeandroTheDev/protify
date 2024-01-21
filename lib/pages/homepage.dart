import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:protify/data/user_preferences.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool alreadyRendered = false;
  // Dummy Data
  final games = [
    {
      "Title": "Minecraft",
      "Image": "",
      "LaunchCommand": "java",
      "LaunchDirectory": "/home/Bobs/Games/Minecraft/sklauncher.java",
      "PrefixFolder": null,
      "ProtonDirectory": null,
      "Ignore": ["javaInstall"],
    },
    {
      "Title": "The Enchanted Cave 2",
      "Image": "",
      "LaunchCommand": "proton",
      "LaunchDirectory":
          "/home/Bobs/User/Games/The Enchanted Cave 2/Enchanted Cave 2.exe",
      "PrefixFolder": null,
      "ProtonDirectory":
          "/home/Bobs/User/Templates/protify-release/protons/Proton 8.0/",
      "Ignore": ["javaInstall"],
    }
  ];
  @override
  Widget build(BuildContext context) {
    int getGridGamesCrossAxisCount(windowSize, gameCount) {
      if (windowSize.width <= 200) {
        return 2;
      } else if (windowSize.width <= 400) {
        return 4;
      } else if (windowSize.width <= 600) {
        return 6;
      } else if (windowSize.width <= 800) {
        return 8;
      } else {
        return 10;
      }
    }

    checkPrefixExistence(int index) {
      String currentDirectory = Directory.current.path;
      // Prefixes Folder
      currentDirectory = join(currentDirectory, "prefixes");
      // Check if not exist
      if (!Directory(currentDirectory).existsSync()) {
        // Create
        Directory(currentDirectory).createSync();
      }

      // Game Prefix Folder
      currentDirectory =
          join(currentDirectory, games[index]["Title"] as String);
      // Check if not exist
      if (!Directory(currentDirectory).existsSync()) {
        // Create
        Directory(currentDirectory).createSync();
      }
    }

    startGame(int index) async {
      // Creating the prefix folder if not exist
      checkPrefixExistence(index);

      //Command Variables
      const String steamCompatibility =
          "export STEAM_COMPAT_CLIENT_INSTALL_PATH=\"~/.local/share/Steam\"";
      final String protonDirectory = games[index]["ProtonDirectory"] as String;
      final String protonWineDirectory =
          "$current/protons/Proton 8.0/dist/bin/wine64";
      final String protonExecutable = "$current/protons/Proton 8.0/proton";
      final String gameDirectory = games[index]["LaunchDirectory"] as String;

      final String command =
          '$steamCompatibility && STEAM_COMPAT_DATA_PATH="$protonDirectory" "$protonWineDirectory" "$protonExecutable" waitforexitandrun "$gameDirectory"';

      try {
        var process = await Process.start('/bin/bash', ['-c', command]);

        // Redirecionar a saída padrão e a saída de erro para o console do Dart
        process.stdout.transform(utf8.decoder).listen((data) {
          print('[Info]: $data');
        });

        process.stderr.transform(utf8.decoder).listen((data) {
          print('[Error]: $data');
        });

        var exitCode = await process.exitCode;
        print('Command Finished: $exitCode');
      } catch (e) {
        print('Error: $e');
      }
    }

    UserPreferences.getUserGames();

    final windowSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  getGridGamesCrossAxisCount(windowSize, games.length),
              crossAxisSpacing: 0, // Horizontal Spacing
              childAspectRatio: 0.5,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => startGame(index),
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        games[index]["Title"].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
