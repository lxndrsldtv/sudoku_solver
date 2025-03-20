import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart';
import 'package:logging/logging.dart';

class SudokuImageProvider {
  final logger = Logger('ImageProvider');

  Future<Image?> getImage() async {
    try {
      final result =
          await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false, withReadStream: true);

      if (result == null) {
        logger.shout('No image selected');
        return null;
      }

      if (result.files.isEmpty) {
        logger.shout('File list is empty.');
        return null;
      }

      final fileReadStream = result.files.first.readStream;
      if (fileReadStream == null) {
        logger.shout('File readStream is null.');
        return null;
      }

      late final Uint8List imageBytes;
      // fileReadStream.listen((content) {
      //   imageBytes = Uint8List.fromList(content);
      // });
      await for (final content in fileReadStream) {
        imageBytes = Uint8List.fromList(content);
      }
      if (imageBytes.isEmpty) {
        logger.shout('Image bytes are empty.');
        return null;
      }

      return decodeImage(imageBytes);
    } on Exception catch (e) {
      logger.shout('Error: $e');
      return null;
    }
  }
}
