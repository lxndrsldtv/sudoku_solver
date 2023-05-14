import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/models/sudoku_model.dart';
import 'package:sudoku_solver/services/sudoku_solver_service.dart';

import 'test_data.dart';

void main() {
  test(
      'For empty cell could be possible to calculate the set of numbers, '
      'which could be in that cell basing on sudoku rules', () async {
    final sudoku = SudokuModel(
        cells: sudokuHard_1.mapToSudokuCellModelList());

    final cell = sudoku.cells[3];
    final possibleValues = SudokuSolverService.getPossibleValuesForCell(
        sudoku: sudoku, cell: cell);
    // possibleValues.forEach(print);
    expect(possibleValues, {1, 4, 6, 7, 8, 9});
  });

  test(
      'For all empty cells in sudoku can be calculated the values, '
      'which are potential values for the cell', () async {
    final sudoku = SudokuModel(
        cells: sudokuHard_1.mapToSudokuCellModelList());

    final sudokuWithEmptyCellsFilledWithPossibleValues =
        SudokuSolverService.fillCellsWithPossibleValues(sudoku);

    for (var cell in sudokuWithEmptyCellsFilledWithPossibleValues.cells) {
      print('${cell.row}:${cell.column} ${cell.value} ${cell.possibleValues}');
    }
  });

  // test('Any correct sudoku can be solved with backtrack', () async {
  //   final sudoku = SudokuModel(
  //       cells: SudokuUtilsService.constructSudokuCellList(sudokuHard));
  //
  //   final solvedSudoku = SudokuModel(cells: []);
  //   // SudokuSolverService(solvedSudoku: solvedSudoku).backTrack(sudoku: sudoku);
  //   SudokuSolverService.backTrack(sudoku: sudoku);
  //
  //   for (final cell in solvedSudoku.cells) {
  //     print(cell.value);
  //   }
  // });

  test('Each call of backTrackStep must provide partially solved sudoku',
      () async {
    final sudoku = SudokuModel(
        cells: sudokuHard.mapToSudokuCellModelList());

    final stack = Queue<int>();

    print('\n--- sudoku initial --------------------------------------\n');
    print(sudoku.cells.foldIndexed(
        '',
        /* print list as table 9x9 */
        (index, previousValue, element) =>
            '$previousValue ${element.value == 0 ? '.' : element.value} ${(index + 1) % 9 == 0 ? '\n' : ''}'));
    print('\n--- stack initial --------------------------------------\n');
    print(
        stack.fold('', (previousValue, element) => '$previousValue $element'));

    var result = {'sudoku': sudoku, 'stack': stack};
    while ((result['sudoku'] as SudokuModel)
            .cells
            .firstWhereOrNull((c) => c.value == 0) !=
        null) {
      result = await SudokuSolverService.backTrackStep(arg: result);
    }

    print('\n--- done --------------------------------------\n');
    print((result['sudoku'] as SudokuModel).cells.foldIndexed(
        '',
        /* print list as table 9x9 */
        (index, previousValue, element) =>
            '$previousValue ${element.value == 0 ? '.' : element.value} ${(index + 1) % 9 == 0 ? '\n' : ''}'));
    print((result['stack'] as Queue<int>)
        .fold('', (previousValue, element) => '$previousValue $element'));
  });

  // test('Method solve, have to send partially solved sudoku to strem', () async {
  //   final sudoku = SudokuModel(
  //       cells:   SudokuUtilsService.constructSudokuCellList(sudokuHard));
  //
  //   final controller = StreamController<SudokuModel>();
  //
  //   SudokuSolverService.solve(sudoku: sudoku, logTo: controller.sink);
  //
  //   await for (final s in controller.stream) {
  //     print(s.cells.foldIndexed(
  //         '',
  //         /* print list as table 9x9 */
  //         (i, p, c) =>
  //             '$p ${c.value == 0 ? '.' : c.value} ${(i + 1) % 9 == 0 ? '\n' : ''}'));
  //   }
  // });

  test('groupListBy must group list elements by key', () async {
    final lst = [1, 2, 3, 2, 3, 5];
    final glt = lst
        .groupListsBy((v) => v)
        .values
        .where((value) => value.length == 1)
        .flattened;
    print('$lst : $glt');
  });

  test('Some Sudoku can have singleton cells', () async {
    final sudoku = SudokuModel(
      cells: sudokuSimple.mapToSudokuCellModelList(),
    );
    print('\n--- sudoku initial --------------------------------------\n');
    print(sudoku.cells.foldIndexed(
        '',
        /* print list as table 9x9 */
        (index, previousValue, element) =>
            '$previousValue ${element.value == 0 ? '.' : element.value} ${(index + 1) % 9 == 0 ? '\n' : ''}'));

    final sudokuWithFilledPossibleValues =
        SudokuSolverService.fillCellsWithPossibleValues(sudoku);
    final subGridS11Cells = sudokuWithFilledPossibleValues.cells
        .where((cell) => cell.subgrid == 'S11');
    final singletonCells =
        SudokuSolverService.findSingletonCells(subGridS11Cells.toList());

    singletonCells.toList().forEach((cell) => print(
        '${cell.row}:${cell.column}:${cell.value}:${cell.possibleValues}'));
  });

}
