import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:protify/pages/homepage.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  final ScreenUtil screenUtil = ScreenUtil();
  WindowOptions windowOptions = WindowOptions(
    size: Size(screenUtil.screenWidth, screenUtil.screenHeight),
    center: true,
    backgroundColor: Colors.transparent,
    // titleBarStyle: TitleBarStyle.hidden,
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
      title: 'Protify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 78, 77, 77)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
