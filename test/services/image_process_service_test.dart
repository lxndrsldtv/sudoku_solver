import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:sudoku_solver/services/image_process_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageProcessService tests', () {
    setUp(() async {
      // PathProviderPlatform.instance =
    });

    test('decomposition must return 81 cell images with default settings',
        () async {
      final image = await decodePngFile('./test/services/sudoku.png');
      assert(image != null, 'image must not be null');
      final sudokuImage = await SudokuImage.create(image!);

      int cellImageCounter = 0;
      await for (SudokuCellImage _
          in ImageProcessService.decompose(sudokuImage: sudokuImage!)) {
        cellImageCounter++;
      }

      expect(cellImageCounter, 81);
    });
  });
}
