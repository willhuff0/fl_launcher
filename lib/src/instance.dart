import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:fl_launcher/src/java.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

late Map<String, dynamic> versionManifest = () {
  http.get(Uri.parse('')).then((value) => versionManifest = jsonDecode(value.body));
  return <String, dynamic>{};
}();

Future<String> getVersion(String version) async {
  final url = (versionManifest['version'] as List).firstWhere((e) => e['id'] == version)['url'];
  return http.get(Uri.parse(url)).then((value) => value.body);
}

Future<Map<String, dynamic>> getVersionJson(String version) async {
  final url = (versionManifest['version'] as List).firstWhere((e) => e['id'] == version)['url'];
  return http.get(Uri.parse(url)).then((value) => jsonDecode(value.body));
}

bool parseRule(Map<String, dynamic> lib, String os) {
  final rules = lib['rules'] as List<Map<String, dynamic>>?;
  if (rules == null) return false;

  bool allowed = false;
  rules.forEach((rule) {
    if (rule['os'] != os) return;
    allowed = rule['action'] == 'allow';
  });

  return allowed;
}

String getOS() {
  if (Platform.isWindows) return 'windows';
  if (Platform.isLinux) return 'linux';
  if (Platform.isMacOS) return 'osx';
  return '';
}

abstract class Instance {
  final Java java;

  Instance({required this.java});

  Future prepare();

  Future launch();
}

class JVMOptions {
  int maxRam;
  int minRam;

  JVMOptions.standard()
      : maxRam = 2048,
        minRam = 1024;
}

class VanillaInstance extends Instance {
  final String version;
  final String root;
  final JVMOptions jvmOptions;

  VanillaInstance({required this.root, required this.version, required this.jvmOptions, required Java java}) : super(java: java);

  @override
  Future launch() async {
    final nativesPath = p.join(root, 'natives', version);

    final jvm = [
      '-XX:-UseAdaptiveSizePolicy',
      '-XX:-OmitStackTraceInFastThrow',
      '-Dfml.ignorePatchDiscrepancies=true',
      '-Dfml.ignoreInvalidMinecraftCertificates=true',
      '-Djava.library.path=$nativesPath',
      '-Xmx${jvmOptions.maxRam}M',
      '-Xms${jvmOptions.minRam}M',
      {
        "windows": "-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump",
        "osx": "-XstartOnFirstThread",
        "linux": "-Xss1M",
      }[getOS()],
    ];
  }

  @override
  Future prepare() async {
    print('Preparing $version...');
    final versionJsonString = await getVersion(version);
    final json = jsonDecode(versionJsonString);

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
      Future downloadAsset(String hash) async {
        final subhash = hash.substring(0, 2);
        final path = p.join(assetsPath, subhash, hash);
        final url = 'https://resources.download.minecraft.net/${subhash}/${hash}';
        await http.get(Uri.parse(url)).then((response) => File(path).create(recursive: true).then((file) => file.writeAsBytes(response.bodyBytes)));
      }

      assetindexes.forEach((key, value) => downloadFutures.add(downloadAsset(value['hash'])));
      await Future.wait(downloadFutures);
      print('> Done.');
    }

    // getJar
    {
      print('Preparing client...');
      final path = p.join(root, 'versions', version);
      final url = json['downloads']['client']['url'];
      await http.get(Uri.parse(url)).then((response) => File(p.join(path, '$version.jar')).create(recursive: true).then((file) => file.writeAsBytes(response.bodyBytes)));
      File(p.join(path, '$version.json')).create(recursive: true).then((file) => file.writeAsString(versionJsonString));
      print('> Done.');
    }

    // getLibraries
    {
      print('Cloning libraries...');

      final downloadFutures = <Future>[];

      final librariesPath = p.join(root, 'libraries');
      Future downloadLibrary(String url, String path) => http.get(Uri.parse(url)).then((response) => File(path).create(recursive: true).then((file) => file.writeAsBytes(response.bodyBytes)));

      (json['libraries'] as List<Map<String, dynamic>>).forEach((lib) {
        final downloads = lib['downloads'];
        if (downloads != null) {
          final artifact = downloads['artifact'];
          final path = p.join(librariesPath, artifact['path']);
          final url = artifact['url'];
          downloadFutures.add(downloadLibrary(url, path));
        } else {
          print('> Error: not implimentet, ${lib['name']} has no artifact.');
        }
      });

      await Future.wait(downloadFutures);
      print('> Done.');
    }

    // getNatives
    {
      print('> Pulling library natives...');
      final os = getOS();

      final downloadFutures = <Future>[];

      final nativesPath = p.join(root, 'natives', json['id']);

      void extractNative(Uint8List bytes) {
        final archive = ZipDecoder().decodeBytes(bytes);
        extractArchiveToDisk(archive, nativesPath);
      }

      Future downloadNative(String path, String url) async {
        final bytes = await http.get(Uri.parse(url)).then((response) => response.bodyBytes);

        try {
          await compute(extractNative, bytes);
        } catch (e) {
          print('> Failed to extract native: $url');
        }
      }

      (json['libraries'] as List<Map<String, dynamic>>).forEach((lib) {
        final downloads = lib['downloads'];
        if (downloads == null) return;
        final classifiers = downloads['classifiers'];
        if (classifiers == null || !parseRule(lib, os)) return;

        final native = os == 'osx' ? classifiers['natives-osx'] ?? classifiers['natives-macos'] : classifiers['natives-$os'];
        if (native == null) return;

        final name = (native['path'] as String).split('/').last;
        final path = p.join(nativesPath, name);
        final url = native['url'];

        downloadFutures.add(downloadNative(path, url));
      });

      await Future.wait(downloadFutures);
      print('> Done.');
    }

    print('Done.');
  }
}
