import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class SudokuImage {
  static final logger = Logger('SudokuImage');
  final Image image;
  final Uint8List encodedBmpImage;
  final List<SudokuCellImage> _sudokuCellImages =
      List<SudokuCellImage>.empty(growable: true);

  SudokuImage._internal(this.image, this.encodedBmpImage);

  static Future<SudokuImage?> create(Image image) async {
    if (image.data == null) return null;

    final sudokuImage = SudokuImage._internal(image, encodeBmp(image));

    try {
      await for (final cellImage
          in ImageProcessService.decompose(sudokuImage: sudokuImage)) {
        sudokuImage._sudokuCellImages.add(cellImage);
      }
    } catch (e) {
      logger.shout('Error: $e');
      return null;
    }

    return sudokuImage;
  }

  List<SudokuCellImage> get sudokuCellImages => _sudokuCellImages;
}

class SudokuCellImage {
  SudokuCellImage({required this.image, required this.encodedBmpImage});

  final Image image;
  final Uint8List encodedBmpImage;
}

class ImageProcessService {
  static final logger = Logger('ImageProcessService');

  ///
  ///
  static Future<Image?> read(XFile imageFile) async {
    return await decodeImageFile(imageFile.path);
  }

  ///
  /// returns Stream of CellImage(s) cut from SudokuImage, the number of cells
  /// is defined by parameters [rows] and [columns], defaults are related to
  /// most usual Sudoku of size 9x9.
  /// The [margin] defines the indents from calculated cell borders to exclude
  /// unnecessary parts of picture, like, for example, the lines between cells
  static Stream<SudokuCellImage> decompose(
      {required SudokuImage sudokuImage,
      int columns = 9,
      int rows = 9,
      int margin = 5}) async* {
    final movingWorkAreaWidth =
        (sudokuImage.image.width / columns).round();
    final movingWorkAreaHeight =
        (sudokuImage.image.height / rows).round();

    final doubleMargin = margin * 2;
    final cellImageHeight = movingWorkAreaHeight - doubleMargin;
    final cellImageWidth = movingWorkAreaWidth - doubleMargin;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        final cellImage = copyCrop(sudokuImage.image,
            x: movingWorkAreaWidth * j + margin,
            y: movingWorkAreaHeight * i + margin,
            width: cellImageWidth,
            height: cellImageHeight);
        yield SudokuCellImage(
            image: _adjust(image: cellImage), encodedBmpImage: encodeBmp(cellImage));
      }
    }
  }

  ///
  ///
  ///
  static Stream<int> convert(List<SudokuCellImage> cellImages) async* {
    for (final cellImage in cellImages) {
      yield await _recognize(cellImage: cellImage);
    }
  }

  static Future<int> _recognize({required SudokuCellImage cellImage}) async {
    // final imageFile = await _create(image: _adjust(image: cellImage.image));
    final imageFile = await _create(image: cellImage.image);
    if (imageFile == null) return 0;
    final cellValue = await _process(imageFile: imageFile);
    await _delete(file: imageFile);
    return cellValue;
  }

  static Future<XFile?> _create({required Image image}) async {
    const imageFileName = 'tmp.bmp';
    final imageFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/$imageFileName';
    final successEncoding = await encodeBmpFile(imageFilePath, image);
    if (!successEncoding) {
      return null;
    }
    return XFile(imageFilePath);
  }

  static Future<void> _delete({required XFile file}) async {
    try {
      await File(file.path).delete();
    } catch (e) {
      logger.shout('Error deleting file. $file', e);
    }
  }

  static Future<int> _process({required XFile imageFile}) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final recognizedText = await TextRecognizer().processImage(inputImage);
    return int.tryParse(recognizedText.text) ?? 0;
  }

  static Image _adjust({required Image image}) {
    return adjustColor(
      image,
      contrast: 100.0,
      saturation: 0.0,
      brightness: 100.0,
      exposure: 0.5,
    );
  }
}
