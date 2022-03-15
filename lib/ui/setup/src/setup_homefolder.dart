import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fl_launcher/main.dart';
import 'package:fl_launcher/ui/setup/setup.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

class SetupHomefolder extends StatefulWidget {
  const SetupHomefolder({Key? key}) : super(key: key);

  @override
  State<SetupHomefolder> createState() => _SetupHomefolderState();
}

class _SetupHomefolderState extends State<SetupHomefolder> {
  String path = p.join(getUserHome(), 'fl_launcher');
  bool isValid = false;

  @override
  void initState() {
    setPath(path);
    super.initState();
  }

  Future setPath(String newPath) async {
    path = newPath;
    isValid = true;
    final dir = Directory(path);
    if (await dir.exists() && !(await Directory(path).list().isEmpty)) isValid = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 36.0, top: 8.0),
          child: Text('Setup home folder', style: TextStyle(color: Colors.grey, fontSize: 18.0)),
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.grey[800],
                        onTap: () => FilePicker.platform
                            .getDirectoryPath(
                              initialDirectory: path,
                              lockParentWindow: true,
                              dialogTitle: 'Pick home folder',
                            )
                            .then((value) => setPath(value ?? path)),
                        child: Row(
                          children: [
                            SizedBox(width: 14.0),
                            Expanded(
                              child: Text(path, style: TextStyle(color: Colors.grey[500])),
                            ),
                            Icon(Icons.folder, color: Colors.grey[500]),
                            SizedBox(width: 8.0),
                            TextButton(
                              child: Text('Reset'),
                              style: TextButton.styleFrom(primary: Colors.grey),
                              onPressed: () => setPath(p.join(getUserHome(), 'fl_launcher')),
                            ),
                            SizedBox(width: 8.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 48.0,
                right: 48.0,
                child: TextButton(
                  child: isValid ? Text('Next') : Text('Folder is not empty'),
                  onPressed: isValid
                      ? () {
                          homePath = path;
                          prefs.setString('home', homePath);
                          prefs.setBool('setup_home', true);
                          setupNextPage();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String getUserHome() => Platform.isWindows ? Platform.environment['UserProfile']! : Platform.environment['HOME']!;
