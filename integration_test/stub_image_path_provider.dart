import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sudoku_solver/services/image_path_provider.dart';

class StubImagePathProvider implements ImagePathProvider {
  @override
  Future<XFile> getFilePath() async {
    final imageData = await rootBundle.load('assets/images/sudoku.png');
    final imageBytes = imageData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final imageFile =
        await File('${tempDir.path}/sudoku.png').writeAsBytes(imageBytes);
    return XFile(imageFile.path);
  }
}
