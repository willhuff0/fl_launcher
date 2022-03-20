import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:fl_launcher/main.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

final javaVersions = [
  Java(version: 8, jre: true, displayName: 'Java 8', description: 'For Minecraft 1.16 and below'),
  Java(version: 17, jre: true, displayName: 'Java 17', description: 'For Minecraft 1.17 and above'),
];

class Java {
  final int version;
  final bool jre;
  final String displayName;
  final String description;

  Java({required this.version, required this.jre, required this.displayName, required this.description});

  static final javaHome = p.join(homePath, 'java');
  static String getExecutable(int version) => p.join(javaHome, 'java-$version', 'bin', 'java.exe');

  String get _platform => Platform.isWindows
      ? 'windows'
      : Platform.isMacOS
          ? 'mac'
          : Platform.isLinux
              ? 'linux'
              : throw Exception('This platform is not supported!');
  String get url => 'https://api.adoptium.net/v3/binary/latest/$version/ga/$_platform/x64/${jre ? 'jre' : 'jdk'}/hotspot/normal/eclipse';

  late String out;
  late bool isZip;
  double progress = 0.0;
  Future install(Function(double progress, bool isDone) onProgress) async {
    final client = http.Client();
    http.StreamedResponse response = await client.send(http.Request('GET', Uri.parse(url)));

    out = p.join(javaHome, 'java-$version');
    final outDir = Directory(out);
    if (await outDir.exists()) await outDir.delete(recursive: true);

    final disposition = response.headers['content-disposition']!.split('.').last;
    isZip = disposition == 'zip';
    final extension = isZip ? '.zip' : '.tar.gz';

    final length = response.contentLength!;
    int received = 0;
    final outFile = await File('$out$extension').create(recursive: true);

    await response.stream.map((s) {
      received += s.length;
      progress = received / length;
      if (progress != 1.0) onProgress(progress, false);
      return s;
    }).pipe(outFile.openWrite());

    client.close();
    progress = -1.0;
    onProgress(progress, false);

    final archiveFuture = compute(extract, await outFile.readAsBytes());
    await archiveFuture;
    await outFile.delete();

    progress = 1.0;
    onProgress(progress, true);
  }

  // void extract(InputFileStream input) {
  //   final archive = isZip ? ZipDecoder().decodeBuffer(input) : TarDecoder().decodeBytes(GZipDecoder().decodeBuffer(input));
  //   extractArchiveToDisk(archive, out);
  // }

  void extract(List<int> data) {
    final outTemp = '$out-temp';
    final archive = isZip ? ZipDecoder().decodeBytes(data) : TarDecoder().decodeBytes(GZipDecoder().decodeBytes(data));
    extractArchiveToDisk(archive, outTemp);
    Directory(outTemp)
      ..listSync().firstWhere((element) => element is Directory).renameSync(out)
      ..deleteSync(recursive: true);
  }

  void extractZip(List<int> data) {
    final archive = ZipDecoder().decodeBytes(data);
    for (var file in archive) {
      final path = p.join(out, p.joinAll(p.split(file.name).skip(1)));
      if (file.isFile) {
        final data = file.content as List<int>;
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(path).createSync(recursive: true);
      }
    }
  }

  void extractTar(List<int> data) {
    final archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(data));
    for (var file in archive) {
      final path = p.join(out, p.joinAll(p.split(file.name).skip(1)));
      if (file.isFile) {
        final data = file.content as List<int>;
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(path).createSync(recursive: true);
      }
    }
  }
}
