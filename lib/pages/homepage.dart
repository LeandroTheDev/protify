import 'package:flutter/material.dart';
// import 'package:protify/linux_messages/xorg_screen_resolution.dart';
import 'package:window_manager/window_manager.dart';

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
      "Image": "/home/.local/protify/images/minecraft.png",
      "LaunchCommand": "java",
      "LaunchDirectory": "/home/Bobs/Games/Minecraft/sklauncher.java",
      "Ignore": ["javaInstall"],
    },
    {
      "Title": "Minecraft",
      "Image": "/home/.local/protify/images/minecraft.png",
      "LaunchCommand": "java",
      "LaunchDirectory": "/home/Bobs/Games/Minecraft/sklauncher.java",
      "Ignore": ["javaInstall"],
    }
  ];
  @override
  Widget build(BuildContext context) {
    setWindowConfiguration(Size size) {
      WindowOptions windowOptions = WindowOptions(
        size: size,
        center: true,
        backgroundColor: Colors.transparent,
        minimumSize: const Size(126, 126),
        titleBarStyle: TitleBarStyle.normal,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

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
    // XorgResolution().getScreenResolution().then((value) {

    // });
    final windowSize = MediaQuery.of(context).size;
    if (!alreadyRendered) {
      alreadyRendered = true;
      setWindowConfiguration(const Size(860.0, 480.0));
    }
    return Scaffold(
      body: Stack(
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getGridGamesCrossAxisCount(windowSize, games.length),
              crossAxisSpacing: 0, // Horizontal Spacing
              childAspectRatio: 0.5,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
