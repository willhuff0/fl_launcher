import 'package:flutter/material.dart';
import 'package:minecraft_launcher/src/java.dart';
import 'package:minecraft_launcher/ui/setup/setup.dart';

class SetupJava extends StatefulWidget {
  const SetupJava({Key? key}) : super(key: key);

  @override
  State<SetupJava> createState() => _SetupJavaState();
}

class _SetupJavaState extends State<SetupJava> {
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
                                            child: Align(alignment: Alignment.bottomCenter, child: LinearProgressIndicator(value: e.progress <= 0.0 ? null : e.progress)),
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
                          ? () => setupChangePage(2)
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
