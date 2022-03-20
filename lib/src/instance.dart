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

  final root = '';

  @override
  Future prepare() async {
    print('Preparing $version');
    final json = await getVersionJson(version);

    // getAssets
    {
      print('Fetching assets...');
      final path = p.join(root, 'assets', 'indexes');
      await Directory(path).create();

      final assetIndexPath = p.join(path, '${json['assetIndex']['id']}.json');
      final assetIndex = await http.get(Uri.parse(json['assetIndex']['url'])).then((value) => value.body);
      await File(assetIndexPath).writeAsString(assetIndex);
      final assetindexes = jsonDecode(assetIndex)['objects'] as Map<String, dynamic>;
      print('> Got assetIndex.json');
      print('> Downloading ${assetindexes.length} assets');

      final downloadFutures = <Future>[];

      final assetsPath = p.join(root, 'assets', 'objects');
      Future downloadFile(String hash) async {
        final subhash = hash.substring(0, 2);
        final path = p.join(assetsPath, subhash, hash);
        final url = 'https://resources.download.minecraft.net/${subhash}/${hash}';
        await http.get(Uri.parse(url)).then((response) => File(path).create(recursive: true).then((file) => file.writeAsBytes(response.bodyBytes)));
      }

      assetindexes.forEach((key, value) => downloadFutures.add(downloadFile(value['hash'])));
      await Future.wait(downloadFutures);
      print('> Done.');
    }
    //

    // getJar
    {
      final path = p.join(root, 'versions', version);
      await http.get(Uri.parse(url)).then((response) => File(path).create(recursive: true).then((file) => file.writeAsBytes(response.bodyBytes)));
    }
    //
  }
}
