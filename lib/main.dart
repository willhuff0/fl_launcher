import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_launcher/src/preferences.dart';
import 'package:minecraft_launcher/theme.dart';
import 'package:minecraft_launcher/ui/home.dart';
import 'package:minecraft_launcher/ui/setup/setup.dart';

void main() async {
  await initPreferences();

  runApp(App());

  doWhenWindowReady(() {
    appWindow.minSize = Size(800, 600);
    appWindow.size = Size(800, 600);
    appWindow.maxSize = Size(800, 600);
    appWindow.alignment = Alignment.center;
    appWindow.title = 'flLauncher';
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SetupPage(), theme: themeData, debugShowCheckedModeBanner: false);
  }
}
