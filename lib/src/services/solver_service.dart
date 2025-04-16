import 'dart:async';

import 'package:collection/collection.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';

class SolverService {
  final moveHistory = <CellState>[];
  bool _stopSolving = false;
  bool isSolving = false;

  Future<void> stop() async => _stopSolving = !_stopSolving;
  bool get isStopped => _stopSolving;

  Future<void> solve(ReactiveSudokuModel sudoku) async {
    if (isSolving) return;

    isSolving = true;
    _stopSolving = false;
    while (!_stopSolving && _isNotSolved(sudoku)) {
      CellState? cellToFill = await findNextCellToFill(sudoku);
      while (cellToFill != null) {
        await doMove(cellToFill);
        await Future.delayed(const Duration(milliseconds: 100));
        cellToFill = await findNextCellToFill(sudoku);
      }
      if (_isSolved(sudoku)) {
        isSolving = false;
        return;
      }
      await changePath(sudoku);
      await Future.delayed(const Duration(milliseconds: 100));
    }
    isSolving = false;
  }

  bool _isNotSolved(ReactiveSudokuModel sudoku) {
    return sudoku.cells.flattened.any((c) => c.value == emptyValue);
  }

  bool _isSolved(ReactiveSudokuModel sudoku) => !_isNotSolved(sudoku);

  Future<CellState?> findNextCellToFill(ReactiveSudokuModel sudoku) async {
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

  Future<void> doMove(CellState? cellToFill) async {
    if (cellToFill == null) {
      return;
    }

    final untestedValues = cellToFill.possibleValues.difference(cellToFill.testedValues);
    final valueToTest = untestedValues.toList()[0];
    await cellToFill.setValue(valueToTest);
    cellToFill.testedValues.add(valueToTest);

    moveHistory.add(cellToFill);
  }

  Future<void> changePath(ReactiveSudokuModel sudoku) async {
    if (moveHistory.isEmpty) {
      return;
    }

    CellState latestMove = moveHistory.removeLast();
    while (latestMove.possibleValues.difference(latestMove.testedValues).isEmpty) {
      latestMove.testedValues = {};
      await latestMove.setValue(emptyValue);
      latestMove = moveHistory.removeLast();
    }

    await latestMove.setValue(emptyValue);
  }

  void undoMove(ReactiveSudokuModel sudoku) async {
    if (moveHistory.isEmpty) {
      return;
    }

    final lastModifiedCell = moveHistory.removeLast();

    lastModifiedCell.testedValues.remove(lastModifiedCell.value);
    await lastModifiedCell.setValue(emptyValue);
  }
}

class SolverServiceLoggable extends SolverService {
  final Logger logger;

  SolverServiceLoggable({required this.logger});

  @override
  Future<void> solve(ReactiveSudokuModel sudoku) async {
    logger.info('SolverService.solve()');
    super.solve(sudoku);
  }

  @override
  Future<void> doMove(CellState? cellToFill) async {
    logger.info('SolverService.doMove(): stopSolving: $_stopSolving');
    super.doMove(cellToFill);
    logger.info('SolverService move count: ${moveHistory.length}');
  }

  @override
  void undoMove(ReactiveSudokuModel sudoku) {
    logger.info('SolverService.undoMove()');
    super.undoMove(sudoku);
    logger.info('SolverService move count: ${moveHistory.length}');
  }

  @override
  Future<void> changePath(ReactiveSudokuModel sudoku) async {
    logger.info('SolverService.changePath()');
    super.changePath(sudoku);
    logger.info('SolverService move count: ${moveHistory.length}');
  }

  @override
  bool _isNotSolved(ReactiveSudokuModel sudoku) {
    logger.info('SolverService._isNotSolved()');
    final result = super._isNotSolved(sudoku);
    logger.info('SolverService._isNotSolved() result: $result');
    return result;
  }
}
