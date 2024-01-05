import 'package:flutter/material.dart';
import 'package:protify/pages/homepage.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(
          primary: const Color.fromARGB(255, 172, 172, 172),
          seedColor: const Color.fromARGB(255, 189, 189, 189),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 95, 95, 95),
      ),
      home: HomePage(),
    );
  }
}
