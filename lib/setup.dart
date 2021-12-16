import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:minecraft_launcher/main.dart';
import 'package:mouse_parallax/mouse_parallax.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

final _pageStreamController = StreamController<int>();
final _pageStream = _pageStreamController.stream;

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
                _SetupLanding(),
                _SetupJava(),
                _SetupPage3(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupLanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ParallaxStack(
          resetOnExit: false,
          layers: [
            ParallaxLayer(
              yRotation: 0.3,
              xRotation: 0.3,
              xOffset: 60,
              yOffset: 60,
              child: Center(
                child: Material(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(width: 275, height: 150),
                ),
              ),
            ),
            ParallaxLayer(
              yRotation: 0.4,
              xRotation: 0.4,
              xOffset: 20,
              yOffset: 20,
              child: Center(
                child: Material(
                  color: Colors.grey.shade900.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('fl_launcher', style: TextStyle(fontSize: 36)),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 48.0,
          right: 48.0,
          child: TextButton(
            child: Text('Next'),
            onPressed: () => _pageStreamController.add(1),
          ),
        ),
      ],
    );
  }
}

class _SetupJava extends StatefulWidget {
  const _SetupJava({Key? key}) : super(key: key);

  @override
  State<_SetupJava> createState() => _SetupJavaState();
}

class _SetupJavaState extends State<_SetupJava> {
  bool installing = false;
  int numDone = 0;
  int numTotal = 0;

  void install() {
    numTotal = javaVersions.length;
    setState(() => installing = true);
    for (var e in javaVersions) {
      e.install((progress, isDone) => setState(() {
            if (isDone) numDone++;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 36.0, top: 8.0),
          child: Text('Java Setup', style: TextStyle(color: Colors.grey, fontSize: 18.0)),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: javaVersions
                      .map<Widget>((e) => AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            opacity: e.progress == 1.0 ? 0.5 : 1.0,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Material(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(4.0),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  curve: Curves.easeInOut,
                                  height: installing && e.progress != 1.0 ? 120 : 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(e.displayName, style: TextStyle(fontSize: 18.0, color: Colors.grey[200])),
                                        Text(e.description, style: TextStyle(color: Colors.grey[300])),
                                        SizedBox(height: 4.0),
                                        Text(e.url, style: TextStyle(color: Colors.grey[500])),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 150),
                                            curve: Curves.easeInOut,
                                            height: installing && e.progress != 1.0 ? 20.0 : 0.0,
                                            child: Align(alignment: Alignment.bottomCenter, child: LinearProgressIndicator(value: e.progress == 0.0 ? null : e.progress)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Positioned(
                bottom: 48.0,
                right: 48.0,
                child: TextButton(
                  child: Text(installing
                      ? numDone == numTotal
                          ? 'Next'
                          : 'Working'
                      : 'Install'),
                  onPressed: installing
                      ? numDone == numTotal
                          ? () => _pageStreamController.add(2)
                          : null
                      : () => install(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SetupPage3 extends StatelessWidget {
  const _SetupPage3({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

final javaVersions = [
  JavaVersion(version: 8, jre: true, displayName: 'Java 8', description: 'For Minecraft 1.16 and below'),
  JavaVersion(version: 17, jre: false, displayName: 'Java 17', description: 'For Minecraft 1.17 and above'),
];

class JavaVersion {
  final int version;
  final bool jre;
  final String displayName;
  final String description;

  JavaVersion({required this.version, required this.jre, required this.displayName, required this.description});

  String get _platform => Platform.isWindows
      ? 'windows'
      : Platform.isMacOS
          ? 'macos'
          : Platform.isLinux
              ? 'linux'
              : throw Exception('This platform is not supported!');
  String get url => 'https://api.adoptium.net/v3/binary/latest/$version/ga/$_platform/x64/${jre ? 'jre' : 'jdk'}/hotspot/normal/eclipse';

  double progress = 0.0;
  Future install(Function(double progress, bool isDone) onProgress) async {
    final client = http.Client();
    http.StreamedResponse response = await client.send(http.Request('GET', Uri.parse(url)));

    final file = await File(path.joinAll([homePath, 'java', 'java-$version', 'downloading.zip'])).create(recursive: true);

    final length = response.contentLength!;
    int received = 0;
    final sink = file.openWrite();

    await response.stream.map((s) {
      received += s.length;
      progress = received / length;
      onProgress(progress, false);
      return s;
    }).pipe(sink);

    progress = 1.0;
    onProgress(progress, true);
  }
}
