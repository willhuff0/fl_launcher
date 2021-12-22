import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_launcher/theme.dart';
import 'package:minecraft_launcher/ui/setup/setup.dart';

const homePath = 'C:\\Users\\Will\\home\\Minecraft\\fl_launcher';

void main() async {
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
