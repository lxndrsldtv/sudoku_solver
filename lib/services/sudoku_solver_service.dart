import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../models/sudoku_model.dart';
import '../models/sudoku_cell_model.dart';

class SudokuSolverService with ChangeNotifier {
  static final logger = Logger('SudokuSolverService');

  // SudokuModel solvedSudoku;

  // SudokuSolverService({required this.solvedSudoku});

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
        (p, c) => c.value == 0 ? p.followedBy(c.possibleValues).toList() : p);

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
            cell.possibleValues.intersection(subGridSingletonValues).isNotEmpty)
        .map((c) =>
            // SudokuCellModel(
            //       index: c.index,
            //       row: c.row,
            //       column: c.column,
            //       subgrid: c.subgrid,
            //       value: c.possibleValues
            //           .intersection(
            //             subGridSingletonValues,
            //           )
            //           .first, // c.value,
            //       // possibleValues: c.possibleValues.intersection(
            //       //   subGridSingletonValues,
            //       // ),
            //     );
            c.copyWith(
                value: c.possibleValues
                    .intersection(subGridSingletonValues)
                    .first));

    return subGridSingletonCells.toSet();
  }

  static SudokuModel fillCellsWithValuesStep(SudokuModel sudoku) {
    logger.info('\n--- sudoku input --------------------------------------');
    logger.info(sudoku.cells.foldIndexed(
        '\n',
        /* print list as table 9x9 */
        (index, previousValue, element) =>
            '$previousValue ${element.value == 0 ? '.' : element.value} '
            '${(index + 1) % sudoku.size.columns == 0 ? '\n' : ''}'));

    var partSolvedSudoku =
        SudokuModel(cells: List<SudokuCellModel>.from(sudoku.cells));

    partSolvedSudoku =
        SudokuSolverService.fillCellsWithPossibleValues(partSolvedSudoku);

    final sudokuSingletonCells = partSolvedSudoku.cells
        .groupListsBy((cell) => cell.subgrid)
        .values
        .map((e) => SudokuSolverService.findSingletonCells(e))
        .flattened;

    logger.info('found ${sudokuSingletonCells.length} singleton cells');

    for (final cell in sudokuSingletonCells) {
      partSolvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
    }

    logger.info('\n--- sudoku output --------------------------------------');
    logger.info(partSolvedSudoku.cells.foldIndexed(
        '\n',
        /* print list as table 9x9 */
        (index, previousValue, element) =>
            '$previousValue ${element.value == 0 ? '.' : element.value} '
            '${(index + 1) % partSolvedSudoku.size.columns == 0 ? '\n' : ''}'));

    return partSolvedSudoku;
  }

  // /// start from first cell (R1C1) index 0
  // ///
  // /// take cell at given index
  // /// for filled cell increment index and call self (recursion)
  // /// for empty cell calculate set of possible values
  // ///   when set of possible is not empty
  // ///     add assigned value to list of tested values
  // ///     push cell to stack of processed cells
  // ///     increment index and call self (recursion)
  // ///   when set of possible values is empty
  // ///     take cell from top of stack
  // ///     clear assigned value
  // ///     define minimal value of possible to assign, exclude tested values
  // ///     when min value exists
  // ///       assign min value to cell
  // ///       call self with incremented cell index (recurse)
  // ///     when no min values, i.e. all values are tested
  // ///       clear possible to assign values
  // ///       clear tested values
  // ///       pop cell from stack
  // ///       when stack is empty
  // ///         return (stop execution)
  // ///       when stack is not empty
  // ///         call self with index of cell on top of stack
  // /// when sudoku rules allow
  // // static SudokuModel backTrack({required SudokuModel sudoku, int index = 0}) {
  // // static SudokuModel backTrack({required SudokuModel sudoku}) {
  // // Future<SudokuModel> backTrack({required SudokuModel sudoku}) async {
  // // static Stream<SudokuModel> backTrack({required SudokuModel sudoku}) async* {
  // static Stream<SudokuModel> backTrack({required SudokuModel sudoku}) async* {
  //   // make copy of input value
  //   final solvedSudoku = SudokuModel(
  //       // solvedSudoku = SudokuModel(
  //       cells: sudoku.cells
  //           .map((c) => SudokuCellModel(
  //               index: c.index,
  //               row: c.row,
  //               column: c.column,
  //               subgrid: c.subgrid,
  //               value: c.value))
  //           .toList());
  //
  //   final Queue<SudokuCellModel> processedCells = Queue<SudokuCellModel>();
  //
  //   var index = 0;
  //
  //   while (index < solvedSudoku.cells.length) {
  //     var cell = solvedSudoku.cells[index];
  //
  //     // print('index: $index');
  //     // print(
  //     //     '1: ${cell.index}, ${cell.value}, ${cell.row}, ${cell.column}, ${cell.testedValues}');
  //
  //     if (cell.value == 0) {
  //       final cellPossibleValues =
  //           getPossibleValuesForCell(sudoku: solvedSudoku, cell: cell);
  //       final untestedValues = cellPossibleValues.difference(cell.testedValues);
  //       // print('1.1: $cellPossibleValues, ${cell.testedValues}, $untestedValues');
  //       if (untestedValues.isNotEmpty) {
  //         final cellValue = untestedValues.min;
  //         cell = SudokuCellModel(
  //           index: cell.index,
  //           row: cell.row,
  //           column: cell.column,
  //           subgrid: cell.subgrid,
  //           value: cellValue,
  //           testedValues: cell.testedValues.union({cellValue}),
  //         );
  //         // cell.testedValues.add(cellValue);
  //         // print(
  //         //     '2: ${cell.index}, ${cell.value}, ${cell.row}, ${cell.column}, ${cell.testedValues}');
  //         processedCells.addFirst(cell);
  //         solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
  //         // notifyListeners();
  //         yield solvedSudoku;
  //
  //         // sleep(const Duration(milliseconds: 500));
  //
  //         index++;
  //       } else {
  //         cell = SudokuCellModel(
  //           index: cell.index,
  //           row: cell.row,
  //           column: cell.column,
  //           subgrid: cell.subgrid,
  //           value: 0,
  //         );
  //         // cell.testedValues.add(cellValue);
  //         // print(
  //         //     '3: ${cell.index}, ${cell.value}, ${cell.row}, ${cell.column}, ${cell.testedValues}');
  //         solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
  //         // notifyListeners();
  //         yield solvedSudoku;
  //
  //         if (processedCells.isNotEmpty) {
  //           cell = processedCells.removeFirst();
  //           cell = SudokuCellModel(
  //             index: cell.index,
  //             row: cell.row,
  //             column: cell.column,
  //             subgrid: cell.subgrid,
  //             value: 0,
  //             testedValues: cell.testedValues,
  //           );
  //           // print(
  //           //     '4: ${cell.index}, ${cell.value}, ${cell.row}, ${cell.column}, ${cell.testedValues}');
  //           solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
  //           // notifyListeners();
  //           yield solvedSudoku;
  //
  //           index = cell.index;
  //         } else {
  //           // return solvedSudoku;
  //           yield solvedSudoku;
  //         }
  //       }
  //     } else {
  //       index++;
  //       // print('sleep');
  //       // sleep(const Duration(milliseconds: 100));
  //     }
  //   }
  //
  //   // return solvedSudoku;
  // }

  /// {
  ///   'sudoku': SudokuModel,
  ///   'stack': Queue<SudokuCellModel> i.e. Stack
  /// }
  static Future<Map<String, Object>> backTrackStep(
      {required Map<String, Object> arg}) async {
    // static Map<String, Object> backTrackStep({required Map<String, Object> arg}) {
    // make copy of input parameter values to not modify them
    final solvedSudoku = SudokuModel(
        cells:
            List<SudokuCellModel>.from((arg['sudoku']! as SudokuModel).cells));

    final processedCells = Queue<int>.from(arg['stack'] as Queue<int>);

    var index = processedCells.isNotEmpty ? processedCells.first + 1 : 0;

    if (index > solvedSudoku.cells.length) {
      return {'sudoku': solvedSudoku, 'stack': processedCells};
    }

    var cell = solvedSudoku.cells
        .firstWhereOrNull((cell) => cell.value == 0 && cell.index >= index);

    if (cell == null) {
      return {'sudoku': solvedSudoku, 'stack': processedCells};
    }

    final cellPossibleValues =
        getPossibleValuesForCell(sudoku: solvedSudoku, cell: cell);

    final untestedValues = cellPossibleValues.difference(cell.testedValues);

    if (untestedValues.isNotEmpty) {
      final cellValue = untestedValues.min;
      // cell = SudokuCellModel(
      //   index: cell.index,
      //   row: cell.row,
      //   column: cell.column,
      //   subgrid: cell.subgrid,
      //   value: cellValue,
      //   testedValues: cell.testedValues.union({cellValue}),
      // );
      cell = cell.copyWith(
          value: cellValue,
          possibleValues: {},
          testedValues: cell.testedValues.union({cellValue}));
      solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
      processedCells.addFirst(cell.index);
    } else {
      // cell = SudokuCellModel(
      //   index: cell.index,
      //   row: cell.row,
      //   column: cell.column,
      //   subgrid: cell.subgrid,
      //   value: 0,
      // );
      cell = cell.copyWith(value: 0, possibleValues: {}, testedValues: {});
      solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
      if (processedCells.isNotEmpty) {
        cell = solvedSudoku.cells[processedCells.removeFirst()];
        // cell = SudokuCellModel(
        //   index: cell.index,
        //   row: cell.row,
        //   column: cell.column,
        //   subgrid: cell.subgrid,
        //   value: 0,
        //   testedValues: cell.testedValues,
        // );
        cell = cell.copyWith(value: 0, possibleValues: {});
        solvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
      }
    }
    return {'sudoku': solvedSudoku, 'stack': processedCells};
  }

  static Stream<SudokuModel> solveSudoku({required SudokuModel sudoku}) async* {
    var inputOutput = {'sudoku': sudoku, 'stack': Queue<int>()};

    // logger.info('\n--- sudoku initial --------------------------------------');
    // logger.info(sudoku.cells.foldIndexed(
    //     '\n',
    //     /* print list as table 9x9 */
    //         (index, previousValue, element) =>
    //     '$previousValue ${element.value == 0 ? '.' : element.value} ${(index + 1) % 9 == 0 ? '\n' : ''}'));

    while ((inputOutput['sudoku']! as SudokuModel)
            .cells
            .firstWhereOrNull((c) => c.value == 0) !=
        null) {
      inputOutput = await backTrackStep(arg: inputOutput);
      // SudokuSolverService.logger.info('solveSudoku: 1');
      yield (inputOutput['sudoku'] as SudokuModel);
      await Future.delayed(const Duration(microseconds: 1));
    }

    yield (inputOutput['sudoku'] as SudokuModel);
  }
}
