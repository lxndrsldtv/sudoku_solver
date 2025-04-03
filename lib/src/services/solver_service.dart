import 'package:collection/collection.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';

const cellPossibleValueCompleteSet = {1, 2, 3, 4, 5, 6, 7, 8, 9};

class SolverService {
  void calculatePossibleValues(ReactiveSudokuModel sudoku) async {
    final sudokuCells = sudoku.cells.flattenedToList;

    for (var cell in sudokuCells) {
      final valuesOfCellsInSameRow = await _cellRowValues(cell, sudokuCells);
      final valuesOfCellsInSameColumn = await _cellColumnValues(cell, sudokuCells);
      final valuesOfCellsInSameSubgrid = await _cellSubgridValues(cell, sudokuCells);

      cell.state.possibleValues = await Future(() => cellPossibleValueCompleteSet
          .difference(valuesOfCellsInSameRow.toSet())
          .difference(valuesOfCellsInSameColumn.toSet())
          .difference(valuesOfCellsInSameSubgrid.toSet()));
    }
  }

  Future<Iterable<int>> _cellRowValues(ReactiveSudokuCellModel cell, List<ReactiveSudokuCellModel> cells) async => cells
      .where((c) =>
          columnIndex(
              subgridIndex: c.state.coordinates.subgridIndex, subgridCellIndex: c.state.coordinates.subgridCellIndex) ==
          columnIndex(
              subgridIndex: cell.state.coordinates.subgridIndex,
              subgridCellIndex: cell.state.coordinates.subgridCellIndex))
      .map((c) => c.state.value);

  Future<Iterable<int>> _cellColumnValues(ReactiveSudokuCellModel cell, List<ReactiveSudokuCellModel> cells) async =>
      cells
          .where((c) =>
              columnIndex(
                  subgridIndex: c.state.coordinates.subgridIndex,
                  subgridCellIndex: c.state.coordinates.subgridCellIndex) ==
              columnIndex(
                  subgridIndex: cell.state.coordinates.subgridIndex,
                  subgridCellIndex: cell.state.coordinates.subgridCellIndex))
          .map((c) => c.state.value);

  Future<Iterable<int>> _cellSubgridValues(ReactiveSudokuCellModel cell, List<ReactiveSudokuCellModel> cells) async =>
      cells
          .where((c) => c.state.coordinates.subgridIndex == cell.state.coordinates.subgridIndex)
          .map((c) => c.state.value);

  final memRowIndex = List.generate(9, (_) => List<int?>.generate(9, (_) => null));
  int rowIndex({required int subgridIndex, required int subgridCellIndex}) =>
      memRowIndex[subgridIndex][subgridCellIndex] ??= (subgridCellIndex / 3).floor() + (subgridIndex / 3).floor() * 3;

  final memColIndex = List.generate(9, (_) => List<int?>.generate(9, (_) => null));
  int columnIndex({required int subgridIndex, required int subgridCellIndex}) =>
      memColIndex[subgridIndex][subgridCellIndex] ??= subgridCellIndex % 3 + (subgridIndex % 3) * 3;
}
