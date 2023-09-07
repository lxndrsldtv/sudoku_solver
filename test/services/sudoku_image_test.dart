import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:sudoku_solver/services/image_process_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SudokuImage tests', () {
    setUp(() async {
      // PathProviderPlatform.instance =
    });

    test(
        'getter cellImages of class SudokuImage must return 81 cell images '
        'when called with default settings', () async {
      final image = await decodePngFile('./test/services/sudoku.png');
      assert(image != null, 'image must not be null');
      final sudokuImage = await SudokuImage.create(image!);

      final cellImages = sudokuImage!.sudokuCellImages;

      expect(cellImages.length, 81);
    });

    test('create returns null when parameter is Image.empty()', () async {
      expect(await SudokuImage.create(Image.empty()), null);
    });
  });
}
