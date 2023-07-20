import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sudoku_solver/integration_testing/main.dart' as sudoku_app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sudoku application end-to-end test', () {
    testWidgets(
        'tap on "Select Image" button, wait for cell values recognition, '
        'correct wrongly recognized cell values, then tap on "Solve" button, '
        'wait, till sudoku will be solved, i.e all cells will have values',
        (tester) async {
      sudoku_app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('select_image_btn')));
      await tester.pumpAndSettle();

      // wait of handling image, i.e. cutting it to cell images
      // then wait, till cell values will be recognized
      bool lastCellIsNotRecognized = true;
      do {
        await tester.pumpAndSettle();
        var cell80Finder = find.byKey(const Key('cell_text_80'));
        if (cell80Finder.evaluate().isNotEmpty) {
          var cell80Element = cell80Finder.evaluate().first;
          var cell80Data = (cell80Element.widget as Text).data ?? '';
          lastCellIsNotRecognized = cell80Data != '3';
        }
      } while (lastCellIsNotRecognized);

      // set correct values to wrongly recognized cells
      // the process seems to be determined, with same initial image,
      // so the wrongly recognized cells are the same from run to run
      // tap on each founded cell to pop SetCellValueDialog

      Future<void> setCellValue(
          {required int cellIndex, required int newValue}) async {
        await tester.tap(find.byKey(Key('ci$cellIndex')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(Key('bpb$newValue')));
        await tester.pumpAndSettle();
      }

      await setCellValue(cellIndex: 3, newValue: 5);
      await setCellValue(cellIndex: 8, newValue: 6);
      await setCellValue(cellIndex: 26, newValue: 5);
      await setCellValue(cellIndex: 30, newValue: 6);
      await setCellValue(cellIndex: 32, newValue: 1);
      await setCellValue(cellIndex: 33, newValue: 5);
      await setCellValue(cellIndex: 36, newValue: 5);
      await setCellValue(cellIndex: 50, newValue: 5);
      await setCellValue(cellIndex: 52, newValue: 6);
      await setCellValue(cellIndex: 57, newValue: 3);
      await setCellValue(cellIndex: 58, newValue: 6);
      await setCellValue(cellIndex: 77, newValue: 9);
      await setCellValue(cellIndex: 78, newValue: 6);

      await tester.tap(find.byKey(const Key('solve_btn')));
      await tester.pumpAndSettle();

      // wait, till sudoku will be solved, i.e. all cells will have values
      bool sudokuIsNotSolved = true;
      do {
        await tester.pumpAndSettle();
        var cell79Finder = find.byKey(const Key('cell_text_79'));
        if (cell79Finder.evaluate().isNotEmpty) {
          var cell79Element = cell79Finder.evaluate().first;
          var cell79Data = (cell79Element.widget as Text).data ?? '';
          sudokuIsNotSolved = cell79Data == '';
        }
      } while (sudokuIsNotSolved);
    });
  });
}