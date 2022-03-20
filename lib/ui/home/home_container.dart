import 'package:animations/animations.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fl_launcher/ui/home/pages/browse.dart';
import 'package:fl_launcher/ui/home/pages/home.dart';
import 'package:fl_launcher/ui/home/pages/instances.dart';
import 'package:flutter/material.dart';

import 'pages/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var lastPage = 0;
  var page = 0;

  final pages = [
    HomePage(key: Key('home')),
    InstancesPage(key: Key('instance')),
    BrowsePage(key: Key('browse')),
    SettingsPage(key: Key('settings')),
  ];

  @override
  void initState() {
    appWindow.maxSize = Size(double.maxFinite, double.maxFinite);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reverse = page < lastPage;
    lastPage = page;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          SizedBox(
            height: 30.0,
            child: Row(
              children: [
                Expanded(child: MoveWindow()),
                MinimizeWindowButton(),
                MaximizeWindowButton(),
                CloseWindowButton(),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  NavigationRail(
                    elevation: 1.0,
                    backgroundColor: Colors.grey[900],
                    selectedIndex: page,
                    onDestinationSelected: (value) => setState(() => page = value),
                    labelType: NavigationRailLabelType.selected,
                    destinations: [
                      NavigationRailDestination(icon: Icon(Icons.home_rounded), label: Text('Home')),
                      NavigationRailDestination(icon: Icon(Icons.dns_rounded), label: Text('Instances')),
                      NavigationRailDestination(icon: Icon(Icons.public_rounded), label: Text('Browse')),
                      NavigationRailDestination(icon: Icon(Icons.settings_rounded), label: Text('Settings')),
                    ],
                    leading: Center(child: Text('fl', style: TextStyle(fontSize: 18.0))),
                    groupAlignment: 1,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: PageTransitionSwitcher(
                        reverse: reverse,
                        transitionBuilder: (child, primaryAnimation, secondaryAnimation) => SharedAxisTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.vertical,
                          fillColor: Colors.grey[900],
                          child: child,
                        ),
                        child: pages[page],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
