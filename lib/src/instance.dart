import 'dart:convert';
import 'dart:io';

import 'package:fl_launcher/src/java.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

late Map<String, dynamic> versionManifest = () {
  http.get(Uri.parse('')).then((value) => versionManifest = jsonDecode(value.body));
  return <String, dynamic>{};
}();

Future<Map<String, dynamic>> getVersionJson(String version) async {
  final url = (versionManifest['version'] as List).firstWhere((e) => e['id'] == version)['url'];
  return http.get(Uri.parse(url)).then((value) => jsonDecode(value.body));
}

abstract class Instance {
  final Java java;

  Instance({required this.java});

  Future prepare();

  Future launch();
}

class VanillaInstance extends Instance {
  final String version;

  VanillaInstance({required this.version, required Java java}) : super(java: java);

  @override
  Future launch() async {
    // TODO: implement launch
  }

  @override
  Future prepare() async {
    print('Preparing $version');
    final json = await getVersionJson(version);

    // getAssets
    print('Fetching assets...');
    final path = p.join('root', 'assets', 'indexes');
    await Directory(path).create();

    final assetIndexPath = p.join(path, '${json['assetIndex']['id']}.json');
    final assetIndex = await http.get(Uri.parse(json['assetIndex']['url'])).then((value) => value.body);
    await File(assetIndexPath).writeAsString(assetIndex);
    print('> Got assetIndex.json');
    //
  }
}
