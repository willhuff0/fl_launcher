import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_launcher/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _animationController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() {
            _animationController.forward(from: 0.0);
          });
        }
      });

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150), value: 1);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 30,
            color: Colors.grey.shade900,
            child: Row(
              children: [
                Expanded(child: MoveWindow()),
                MinimizeWindowButton(),
                MaximizeWindowButton(),
                CloseWindowButton(),
              ],
            ),
          ),
          Container(
            height: 40,
            color: Colors.grey.shade900.withOpacity(0.5),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_rounded),
                            SizedBox(width: 8.0),
                            Text('Home'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.dns_rounded),
                            SizedBox(width: 8.0),
                            Text('Instances'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.public_rounded),
                            SizedBox(width: 8.0),
                            Text('Browse'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(child: Icon(Icons.settings_rounded), style: iconTextButtonStyle, onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, snapshot) => Transform.scale(
                scale: _animationController.value * 0.02 + 0.98,
                child: Opacity(
                  opacity: _animationController.value,
                  child: [
                    Scaffold(body: Text('Home')),
                    Scaffold(body: Text('Instances')),
                    Scaffold(body: Text('Browse')),
                  ][_tabController.index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
