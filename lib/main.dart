import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(App());

  doWhenWindowReady(() {
    appWindow.minSize = Size(600, 450);
    appWindow.size = Size(800, 600);
    appWindow.alignment = Alignment.center;
    appWindow.title = 'FLLauncher';
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home(), debugShowCheckedModeBanner: false);
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
