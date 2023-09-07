import 'package:sudoku_solver/models/sudoku_cell_model.dart';

abstract class CellState {
  final SudokuCellModel cellModel;

  CellState({required this.cellModel});
}

class CellInitialised extends CellState {
  CellInitialised({required super.cellModel});
}
