import 'package:collection/collection.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';

const cellPossibleValueCompleteSet = {1, 2, 3, 4, 5, 6, 7, 8, 9};

class SolverService {
  final Logger? logger;

  SolverService({this.logger});

  void calculatePossibleValues(ReactiveSudokuModel sudoku) async {
    final sudokuCells = sudoku.cells.flattenedToList;

    for (var cell in sudokuCells) {
      if (cell.value != 0) continue;

      logger?.info('Calculating possible values for cell: ${cell.coordinates}');

      final valuesOfCellsInSameRow = await _cellRowValues(cell, sudokuCells);
      logger?.info('Values of cells in same row: $valuesOfCellsInSameRow');

      final valuesOfCellsInSameColumn = await _cellColumnValues(cell, sudokuCells);
      logger?.info('Values of cells in same column: $valuesOfCellsInSameColumn');

      final valuesOfCellsInSameSubgrid = await _cellSubgridValues(cell, sudokuCells);
      logger?.info('Values of cells in same subgrid: $valuesOfCellsInSameSubgrid');

      cell.possibleValues = await Future(() => cellPossibleValueCompleteSet
          .difference(valuesOfCellsInSameRow.toSet())
          .difference(valuesOfCellsInSameColumn.toSet())
          .difference(valuesOfCellsInSameSubgrid.toSet()));

      logger?.info('Possible values for cell: ${cell.coordinates}: ${cell.possibleValues}');
    }
  }

  Future<Iterable<int>> _cellRowValues(CellState cell, List<CellState> cells) async => cells
      .where((c) =>
          rowIndex(subgridIndex: c.coordinates.subgridIndex, subgridCellIndex: c.coordinates.subgridCellIndex) ==
          rowIndex(subgridIndex: cell.coordinates.subgridIndex, subgridCellIndex: cell.coordinates.subgridCellIndex))
      .map((c) => c.value);

  Future<Iterable<int>> _cellColumnValues(CellState cell, List<CellState> cells) async => cells
      .where((c) =>
          columnIndex(subgridIndex: c.coordinates.subgridIndex, subgridCellIndex: c.coordinates.subgridCellIndex) ==
          columnIndex(subgridIndex: cell.coordinates.subgridIndex, subgridCellIndex: cell.coordinates.subgridCellIndex))
      .map((c) => c.value);

  Future<Iterable<int>> _cellSubgridValues(CellState cell, List<CellState> cells) async =>
      cells.where((c) => c.coordinates.subgridIndex == cell.coordinates.subgridIndex).map((c) => c.value);

  final memRowIndex = List.generate(9, (_) => List<int?>.generate(9, (_) => null));
  int rowIndex({required int subgridIndex, required int subgridCellIndex}) =>
      memRowIndex[subgridIndex][subgridCellIndex] ??= (subgridCellIndex / 3).floor() + (subgridIndex / 3).floor() * 3;

  final memColIndex = List.generate(9, (_) => List<int?>.generate(9, (_) => null));
  int columnIndex({required int subgridIndex, required int subgridCellIndex}) =>
      memColIndex[subgridIndex][subgridCellIndex] ??= subgridCellIndex % 3 + (subgridIndex % 3) * 3;
}
