import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:fl_launcher/theme.dart';
import 'package:fl_launcher/ui/home.dart';
import 'package:fl_launcher/ui/setup/setup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
late String homePath;

void main() async {
  prefs = await SharedPreferences.getInstance();
  final home = prefs.getString('home');
  if (home == null)
    prefs.remove('setup_home');
  else
    homePath = home;

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

void refreshApp() => _refreshAppController.add(null);

final _refreshAppController = StreamController();
final _refreshAppStream = _refreshAppController.stream;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _refreshAppStream.listen((event) => setState(() {}));
    getApplicationSupportDirectory().then((value) => print(value));
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupHome = !prefs.containsKey('setup_home');
    final setupJava = !prefs.containsKey('setup_java');
    return MaterialApp(home: setupHome || setupJava ? SetupPage(setupHome: setupHome, setupJava: setupJava) : Home(), theme: themeData, debugShowCheckedModeBanner: false);
  }
}
