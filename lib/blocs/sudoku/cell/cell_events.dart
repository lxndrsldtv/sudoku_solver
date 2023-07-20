import 'package:sudoku_solver/models/sudoku_cell_model.dart';

abstract class CellEvent {}

class CellReplaceWithRequested extends CellEvent {
  final SudokuCellModel newCell;

  CellReplaceWithRequested({required this.newCell});
}