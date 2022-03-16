import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minecraft_launcher/src/preferences.dart';
import 'package:minecraft_launcher/ui/setup/setup.dart';
import 'package:path_provider/path_provider.dart';

class SetupHomePath extends StatefulWidget {
  const SetupHomePath({Key? key}) : super(key: key);

  @override
  State<SetupHomePath> createState() => _SetupHomePathState();
}

class _SetupHomePathState extends State<SetupHomePath> {
  late TextEditingController _textEditingController;

  bool valid = true;
  bool locked = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    getApplicationSupportDirectory().then((value) => setState(() => _textEditingController.text = value.path));
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 36.0, top: 8.0),
          child: Text('Set Home Path', style: TextStyle(color: Colors.grey, fontSize: 18.0)),
        ),
        SizedBox(height: 24.0),
        Padding(
          padding: EdgeInsets.all(48.0),
          child: TextField(
            controller: _textEditingController,
            autofocus: true,
            enabled: !locked,
            onEditingComplete: () async {
              final directory = Directory(_textEditingController.text);
              valid = true;
              if (await directory.exists() && !await directory.list().isEmpty) valid = false;
              setState(() {});
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              suffixIcon: valid ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.cancel, color: Colors.red),
            ),
          ),
        ),
        Expanded(child: SizedBox()),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 48.0, right: 48.0),
            child: TextButton(
              child: Text('Next'),
              onPressed: valid
                  ? () async {
                      setState(() => locked = true);
                      final path = _textEditingController.text;
                      final directory = Directory(path);
                      try {
                        await directory.create(recursive: true);
                        prefs.setString('home_path', path);
                        homePath = path;
                        setupNextPage();
                      } catch (e) {
                        setState(() {
                          valid = false;
                          locked = false;
                        });
                      }
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
