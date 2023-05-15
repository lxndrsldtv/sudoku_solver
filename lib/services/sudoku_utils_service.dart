import 'dart:io';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_tools;
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class SudokuUtilsService {
  static final logger = Logger('SudokuUtilsService');

  // static List<SudokuCellModel> constructSudokuCellList(List<int> cellValues) {
  //   assert(cellValues.length == 81); // sudoku 9x9 cells => 81 cells in total
  //
  //   final squareSideSize = sqrt(cellValues.length);
  //
  //   //supposed, that values go in direct order, from R1C1, R1C2, ... to R9C9
  //   getRowByIndex(int index, int sudokuSize) => 'R${index ~/ sudokuSize + 1}';
  //
  //   getColumnByIndex(int index, int sudokuSize) =>
  //       'C${(index - (index ~/ sudokuSize) * sudokuSize) + 1}';
  //
  //   String getSubGridRowByIndex(int index, int subGridSize, int sudokuSize) {
  //     final row = (index ~/ sudokuSize) ~/ subGridSize;
  //     final column =
  //         (index - (index ~/ sudokuSize) * sudokuSize) ~/ subGridSize;
  //     return 'S${row + 1}${column + 1}';
  //   }
  //
  //   return cellValues
  //       .mapIndexed((index, element) => SudokuCellModel(
  //             index: index,
  //             // sudokuSize for sudoku 9x9 is 9
  //             row: getRowByIndex(index, 9),
  //             column: getColumnByIndex(index, 9),
  //             // subgrid size for subgrid 3x3 is 3
  //             subgrid: getSubGridRowByIndex(index, 3, 9),
  //             value: cellValues[index],
  //           ))
  //       .toList();
  // }

  static Future<List<Uint8List>> divideImage(
      {required String path, int numRows = 9, int numColumns = 9}) async {
    final image = await image_tools.decodeImageFile(path);
    final images = <Uint8List>[];

    final cropPictHeight = ((image?.height ?? 0) / numRows).round();
    final cropPictWidth = ((image?.width ?? 0) / numColumns).round();

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numColumns; j++) {
        final cropPict = image_tools.copyCrop(image!,
            x: cropPictWidth * j + 5,
            y: cropPictHeight * i + 5,
            width: cropPictWidth - 10,
            height: cropPictHeight - 10);
        images.add(image_tools.encodeBmp(cropPict));
      }
    }

    return images;
  }

  static Stream<List<int>> recognizeCellValues(
      List<int> cellValues, List<Uint8List> cellImages) async* {
    // @TODO replace FOR with MAP

    var index = 0;
    const imageFileName = 'tmp.bmp';
    final imageFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/$imageFileName';

    final recognizer = TextRecognizer();

    final copyCellValues = List<int>.from(cellValues);

    for (final cellImage in cellImages) {
      final img = image_tools.decodeBmp(cellImage);
      if (null == img) {
        logger.shout('Error decoding BMP image. Index = $index');
        continue;
      }

      final successEncoding =
          await image_tools.encodeBmpFile(imageFilePath, img);
      if (!successEncoding) {
        logger.shout('Error encoding BMP file. Index = $index');
        continue;
      }

      final inputImage = InputImage.fromFilePath(imageFilePath);
      final recognizedText = await recognizer.processImage(inputImage);
      final value = int.tryParse(recognizedText.text) ?? 0;
      if (value != 0 && copyCellValues[index] == 0) {
        copyCellValues.replaceRange(index, index + 1, [value]);
        yield copyCellValues;
      }
      index++;

      try {
        File(imageFilePath).deleteSync();
      } catch (e) {
        logger.shout('Error deleting BMP file. Index = $index', e);
      }
    }
  }

  static Future<int> recognizeCellValue(Uint8List cellImage) async {
    final img = image_tools.decodeBmp(cellImage);

    if (null == img) {
      logger.shout('Error decoding BMP image.');
      return 0;
    }

    const imageFileName = 'tmp.bmp';
    final imageFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/$imageFileName';

    final successEncoding = await image_tools.encodeBmpFile(imageFilePath, img);
    if (!successEncoding) {
      logger.shout('Error encoding BMP file.');
      return 0;
    }

    final inputImage = InputImage.fromFilePath(imageFilePath);
    final recognizedText = await TextRecognizer().processImage(inputImage);
    final value = int.tryParse(recognizedText.text) ?? 0;

    try {
      File(imageFilePath).deleteSync();
    } catch (e) {
      logger.shout('Error deleting BMP file.', e);
    }

    return value;
  }
}
