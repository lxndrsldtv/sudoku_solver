// import 'package:collection/collection.dart';
import 'package:collection/collection.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';

class SolverService {
  final moveHistory = <CellState>[];

  void solve(ReactiveSudokuModel sudoku) {}

  CellState? findNextCellToFill(ReactiveSudokuModel sudoku) {
    final cells = sudoku.cells.flattened.where((c) => c.value == 0).toList();
    if (cells.isEmpty) {
      return null;
    }
    final firstCellWithMinCountPossibleValues = cells.fold<CellState>(
        cells[0],
        (r, c) =>
            r.possibleValues.difference(r.testedValues).length <= c.possibleValues.difference(c.testedValues).length
                ? r
                : c);
    final untestedValues =
        firstCellWithMinCountPossibleValues.possibleValues.difference(firstCellWithMinCountPossibleValues.testedValues);

    if (untestedValues.isEmpty) {
      return null;
    }
    return firstCellWithMinCountPossibleValues;
  }

  void doMove(ReactiveSudokuModel sudoku) {
    // final cells = sudoku.cells.flattened.where((c) => c.value == 0).toList();
    // final firstCellWithMinCountPossibleValues = cells.fold<CellState>(
    //     cells[0],
    //     (r, c) =>
    //         r.possibleValues.difference(r.testedValues).length <= c.possibleValues.difference(c.testedValues).length
    //             ? r
    //             : c);

    // final untestedValues =
    //     firstCellWithMinCountPossibleValues.possibleValues.difference(firstCellWithMinCountPossibleValues.testedValues);

    // if (untestedValues.isEmpty) {
    //   return;
    // }

    final cellToFill = findNextCellToFill(sudoku);

    if (cellToFill == null) {
      return;
    }

    final untestedValues = cellToFill.possibleValues.difference(cellToFill.testedValues);
    final valueToTest = untestedValues.toList()[0];
    cellToFill.value = valueToTest;
    cellToFill.testedValues.add(valueToTest);
    // firstCellWithMinPossibleValues.possibleValues.remove(firstCellWithMinPossibleValues.possibleValues.toList()[0]);

    moveHistory.add(cellToFill);
  }

  void undoMove(ReactiveSudokuModel sudoku) {
    if (moveHistory.isEmpty) {
      return;
    }

    final lastModifiedCell = moveHistory.removeLast();

    lastModifiedCell.testedValues.remove(lastModifiedCell.value);
    lastModifiedCell.value = emptyValue;

    // // no more variants for this cell
    // if (lastModifiedCell.possibleValues.difference(lastModifiedCell.testedValues).isEmpty) {
    //   lastModifiedCell.possibleValues = {};
    //   lastModifiedCell.testedValues = {};
    // }
  }
}

class SolverServiceLoggable extends SolverService {
  final Logger logger;

  SolverServiceLoggable({required this.logger});

  @override
  void solve(ReactiveSudokuModel sudoku) {
    logger.info('SolverService.solve()');
  }

  @override
  void doMove(ReactiveSudokuModel sudoku) {
    logger.info('SolverService.doMove()');
    super.doMove(sudoku);
    logger.info('SolverService move count: ${moveHistory.length}');
  }

  @override
  void undoMove(ReactiveSudokuModel sudoku) {
    logger.info('SolverService.undoMove()');
    super.undoMove(sudoku);
    logger.info('SolverService move count: ${moveHistory.length}');
  }
}
