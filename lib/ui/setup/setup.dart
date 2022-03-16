import 'dart:async';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_launcher/src/java.dart';
import 'package:minecraft_launcher/ui/setup/src/setup_homePath.dart';

import 'src/setup_landing.dart';
import 'src/setup_java.dart';

final _pageStreamController = StreamController<int>();
final _pageStream = _pageStreamController.stream;

int currentPage = 0;
void setupChangePage(int page) => _pageStreamController.add(page);
void setupNextPage() => _pageStreamController.add(currentPage + 1);
void setupPreviousPage() => _pageStreamController.add(currentPage - 1);

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late final PageController _pageController;
  late final StreamSubscription _pageStreamSubscription;

  final pages = [
    SetupLanding(),
    SetupHomePath(),
    if (!isJavaReady()) SetupJava(),
    _SetupPage3(),
  ];

  @override
  void initState() {
    _pageController = PageController();
    _pageStreamSubscription = _pageStream.listen((index) => setState(() {
          currentPage = index;
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
                // if (currentPage > 1)
                //   WindowButton(
                //     padding: EdgeInsets.zero,
                //     iconBuilder: (context) => Icon(Icons.arrow_back, color: context.iconColor, size: 18.0),
                //     onPressed: () => setupPreviousPage(),
                //   ),
                Expanded(child: MoveWindow()),
                MinimizeWindowButton(),
                CloseWindowButton(),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: pages,
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
