import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../models/sudoku_cell_model.dart';
import '../models/sudoku_model.dart';

class SudokuSolverService {
  static final logger = Logger('SudokuSolverService');

  static Set<int> getPossibleValuesForCell({
    required SudokuModel sudoku,
    required SudokuCellModel cell,
  }) {
    assert(cell.value == 0);

    final rowValues =
    sudoku.cells.where((c) => c.row == cell.row).map((c) => c.value);

    final columnValues =
    sudoku.cells.where((c) => c.column == cell.column).map((c) => c.value);

    final subgridValues = sudoku.cells
        .where((c) => c.subgrid == cell.subgrid)
        .map((c) => c.value);

    return {1, 2, 3, 4, 5, 6, 7, 8, 9}.difference(rowValues
        .toSet()
        .union(columnValues.toSet())
        .union(subgridValues.toSet()));
  }

  static SudokuModel fillCellsWithPossibleValues(SudokuModel sudoku) {
    return SudokuModel(
        cells: sudoku.cells
            .map((c) =>
            c.copyWith(
              possibleValues: c.value == 0
                  ? getPossibleValuesForCell(sudoku: sudoku, cell: c)
                  : {},
            ))
            .toList());
  }

  static Set<SudokuCellModel> findSingletonCells(
      List<SudokuCellModel> subGridCells) {
    assert(subGridCells.length == 9); // subgrid size is 3x3, i. e. 9 cells
    // todo assert, that all cells belong to same subgrid
    //  assert(subGridCells.every((cell) => false))
    // empty cells of subGridCells must have filled possibleValues attribute
    assert(subGridCells
        .where((c) => c.value == 0)
        .every((c) => c.possibleValues.isNotEmpty));

    // join possibleValues of all cells to single list
    final possibleValuesOfAllEmptyCells = subGridCells.fold<List<int>>([],
            (p, c) =>
        c.value == 0
            ? p.followedBy(c.possibleValues).toList()
            : p);

    // subGridSingletonValue is the possible value,
    // which encountered exactly in single cell of subgrid
    final subGridSingletonValues = possibleValuesOfAllEmptyCells
        .groupListsBy((v) => v)
        .values
        .where((value) => value.length == 1)
        .flattened
        .toSet();

    // filter cells of subgrid, which contain singleton values in its possible
    // values lists, create and return new cells with single values in the list
    // of possible values
    final subGridSingletonCells = subGridCells
        .where((cell) =>
    cell.possibleValues
        .intersection(subGridSingletonValues)
        .isNotEmpty)
        .map((c) =>
        c.copyWith(
            value:
            c.possibleValues
                .intersection(subGridSingletonValues)
                .first));

    return subGridSingletonCells.toSet();
  }


  static Stream<SudokuCellModel> process({required SudokuModel sudoku}) async* {
    var solvedSudoku = sudoku;

    await for (final cell in fillSingletonCells(sudoku: solvedSudoku)) {
      solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
      yield (cell);
    }

    var processedCells = Queue<int>();

    var sudokuContainsEmptyCells =
        solvedSudoku.cells.firstWhereOrNull((c) => c.value == 0) != null;

    while (sudokuContainsEmptyCells) {
      var index = processedCells.isNotEmpty ? processedCells.first + 1 : 0;

      final allCellsAreProcessed = index > solvedSudoku.cells.length;
      if (allCellsAreProcessed) break;

      var cell = solvedSudoku.cells // get next empty cell
          .firstWhereOrNull((cell) => cell.value == 0 && cell.index >= index);

      final nextEmptyCellNotFound = null == cell;
      if (nextEmptyCellNotFound) break;

      final cellPossibleValues =
      getPossibleValuesForCell(sudoku: solvedSudoku, cell: cell);

      final untestedValues = cellPossibleValues.difference(cell.testedValues);

      final notAllPossibleValuesAreTested = untestedValues.isNotEmpty;
      if (notAllPossibleValuesAreTested) {
        cell = cell.copyWith(
            value: untestedValues.min,
            possibleValues: {},
            testedValues: cell.testedValues.union({untestedValues.min}));
        processedCells.addFirst(cell.index);
      } else {
        cell = cell.copyWith(value: 0, possibleValues: {}, testedValues: {});
        solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
        yield (cell);
        if (processedCells.isNotEmpty) {
          // get last processed cell by index from stack, i.e. do step back
          cell = solvedSudoku.cells[processedCells.removeFirst()];
          cell = cell.copyWith(value: 0, possibleValues: {});
        }
      }
      solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
      yield (cell);
      sudokuContainsEmptyCells =
          solvedSudoku.cells.firstWhereOrNull((c) => c.value == 0) != null;
    }
  }

  static Stream<SudokuCellModel> fillSingletonCells(
      {required SudokuModel sudoku}) async* {
    var partSolvedSudoku = sudoku;
    var singletonCellsExist = false;
    do {
      partSolvedSudoku = fillCellsWithPossibleValues(partSolvedSudoku);

      final sudokuSingletonCells = partSolvedSudoku.cells
          .groupListsBy((cell) => cell.subgrid)
          .values
          .map((e) => SudokuSolverService.findSingletonCells(e))
          .flattened;

      singletonCellsExist = sudokuSingletonCells.isNotEmpty;

      for (final cell in sudokuSingletonCells) {
        partSolvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
        yield (cell);
      }
    } while (singletonCellsExist);
  }
}
