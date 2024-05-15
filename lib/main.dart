import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:protify/components/models/connection.dart';
import 'package:protify/components/models/download.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/save_datas.dart';
import 'package:protify/data/system.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/pages/homepage.dart';
import 'package:protify/pages/store.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = jsonDecode(await SaveDatas.readData('preferences', 'string') ?? "{}");
  await windowManager.ensureInitialized();
  //Declaring the Window Options
  WindowOptions windowOptions = WindowOptions(
    size: Size(preferences["StartWindowWidth"] ?? 800.0, preferences["StartWindowHeight"] ?? 600.0),
    center: true,
    backgroundColor: Colors.transparent,
    minimumSize: const Size(226, 226),
    titleBarStyle: TitleBarStyle.normal,
  );
  //Updating Window Option
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MultiProvider(providers: [
    //Declaring the Provider
    ChangeNotifierProvider(create: (_) => UserPreferences()),
    ChangeNotifierProvider(create: (_) => ProtifySystem()),
    ChangeNotifierProvider(create: (_) => ConnectionModel()),
    ChangeNotifierProvider(create: (_) => ScreenBuilderProvider()),
    ChangeNotifierProvider(create: (_) => LibraryProvider()),
    ChangeNotifierProvider(create: (_) => DownloadModel()),
  ], child: const Protify()));
}

class Protify extends StatelessWidget {
  const Protify({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Protify',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 116, 116, 116),
        secondaryHeaderColor: const Color.fromARGB(255, 209, 209, 209),
        colorScheme: ColorScheme.fromSeed(
          primary: const Color.fromARGB(255, 117, 117, 117),
          secondary: const Color.fromARGB(255, 209, 209, 209),
          tertiary: const Color.fromARGB(255, 65, 61, 61),
          seedColor: const Color.fromARGB(255, 209, 209, 209),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 95, 95, 95),
      ),
      routes: {
        "home": (context) => const HomePage(),
        "store": (context) => const StorePage(),
      },
      home: const HomePage(),
    );
  }
}
