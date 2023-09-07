import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/models/sudoku_model.dart';
import 'package:sudoku_solver/services/sudoku_solver_service.dart';

import './test_data.dart';

void main() {
  test(
      'For empty cell could be possible to calculate the set of numbers, '
      'which could be in that cell basing on sudoku rules', () async {
    final sudoku = SudokuModel(cells: sudokuHard_1.mapToSudokuCellModelList());

    final cell = sudoku.cells[3];
    final possibleValues = SudokuSolverService.getPossibleValuesForCell(
        sudoku: sudoku, cell: cell);
    expect(possibleValues, {1, 4, 6, 7, 8, 9});
  });

  test(
      'For all empty cells in sudoku can be calculated the values, '
      'which are potential values for the cell', () async {
    final sudoku = SudokuModel(cells: sudokuHard_1.mapToSudokuCellModelList());

    final sudokuWithEmptyCellsFilledWithPossibleValues =
        SudokuSolverService.fillCellsWithPossibleValues(sudoku);

    for (var cell in sudokuWithEmptyCellsFilledWithPossibleValues.cells) {
      print('${cell.row}:${cell.column} ${cell.value} ${cell.possibleValues}');
    }
  });

  test('Some Sudoku can have singleton cells', () async {
    final sudoku = SudokuModel(
      cells: sudokuSimple.mapToSudokuCellModelList(),
    );
    // print('\n--- sudoku initial --------------------------------------\n');
    // print(sudoku.cells.foldIndexed(
    //     '',
    //     /* print list as table 9x9 */
    //     (index, previousValue, element) =>
    //         '$previousValue ${element.value == 0 ? '.' : element.value} ${(index + 1) % 9 == 0 ? '\n' : ''}'));

    final sudokuWithFilledPossibleValues =
        SudokuSolverService.fillCellsWithPossibleValues(sudoku);
    final subGridS11Cells = sudokuWithFilledPossibleValues.cells
        .where((cell) => cell.subgrid == 'S11');
    final singletonCells =
        SudokuSolverService.findSingletonCells(subGridS11Cells.toList());

    // singletonCells.toList().forEach((cell) => print(
    //     '${cell.row}:${cell.column}:${cell.value}:${cell.possibleValues}'));

    expect(singletonCells.length, 2);
  });

  test('fillSingletonCells generate stream of cells, which are singletons',
      () async {
    final sudoku = SudokuModel(cells: sudokuSimple.mapToSudokuCellModelList());
    // print('\n--- sudoku initial -------------------------------------\n');
    // print(sudoku.cells.foldIndexed(
    //     '',
    //     /* print list as table 9x9 */
    //     (index, previousValue, element) =>
    //         '$previousValue ${element.value == 0 ? '.' : element.value} ${(index + 1) % 9 == 0 ? '\n' : ''}'));

    await for (final cell
        in SudokuSolverService.fillSingletonCells(sudoku: sudoku)) {
      // print('cell.index = ${cell.index}');
      sudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
    }

    // print('\n--- sudoku singletons filled ----------------------------\n');
    // print(sudoku.cells.foldIndexed(
    //     '',
    //     /* print list as table 9x9 */
    //     (index, previousValue, element) =>
    //         '$previousValue ${element.value == 0 ? '.' : element.value} ${(index + 1) % 9 == 0 ? '\n' : ''}'));

    expect(sudoku.isSolved(), true);
  });
}
