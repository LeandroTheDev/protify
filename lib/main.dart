import 'package:flutter/material.dart';
import 'package:protify/pages/homepage.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    minimumSize: Size(126, 126),
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const Protify());
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
        primaryColor: Color.fromARGB(255, 116, 116, 116),
        secondaryHeaderColor: Color.fromARGB(255, 209, 209, 209),
        colorScheme: ColorScheme.fromSeed(
          primary: Color.fromARGB(255, 117, 117, 117),
          secondary: Color.fromARGB(255, 209, 209, 209),
          tertiary: Color.fromARGB(255, 65, 61, 61),
          seedColor: Color.fromARGB(255, 209, 209, 209),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 95, 95, 95),
      ),
      home: HomePage(),
    );
  }
}
