import 'package:flutter/material.dart';
import 'package:protify/components/widgets/library/library_provider.dart';
import 'package:protify/components/widgets/screen_builder/screen_builder_provider.dart';
import 'package:protify/data/user_preferences.dart';
import 'package:protify/pages/homepage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    //Declaring the Provider
    ChangeNotifierProvider(create: (_) => UserPreferences()),
    ChangeNotifierProvider(create: (_) => ScreenBuilderProvider()),
    ChangeNotifierProvider(create: (_) => LibraryProvider()),
  ], child: const Protify()));
}

class Protify extends StatelessWidget {
  const Protify({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Load Preferences
    UserPreferences.loadPreference(context);

    // Initializing the GUI
    return MaterialApp(
      // Remove awful banner while debugging
      debugShowCheckedModeBanner: false,
      title: 'Protify',
      // Setting default theme colors
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
      },
      home: const HomePage(),
    );
  }
}
