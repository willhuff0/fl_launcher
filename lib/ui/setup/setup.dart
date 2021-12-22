import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import 'src/setup_landing.dart';
import 'src/setup_java.dart';

final _pageStreamController = StreamController<int>();
final _pageStream = _pageStreamController.stream;

void setupChangePage(int page) => _pageStreamController.add(page);

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late final PageController _pageController;
  late final StreamSubscription _pageStreamSubscription;

  @override
  void initState() {
    _pageController = PageController();
    _pageStreamSubscription = _pageStream.listen((index) => setState(() {
          _pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        }));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          SizedBox(
            height: 30,
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
            child: PageView(
              controller: _pageController,
              children: [
                SetupLanding(),
                SetupJava(),
                _SetupPage3(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupPage3 extends StatelessWidget {
  const _SetupPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
