import 'dart:typed_data';

import 'package:sudoku_solver/services/image_process_service.dart';

import '../models/sudoku_cell_model.dart';
import '../models/sudoku_model.dart';

abstract class SudokuState {
  SudokuState({required this.sudokuModel, this.sudokuImage});

  SudokuState.fromState({required SudokuState state})
      : sudokuModel = state.sudokuModel,
        sudokuImage = state.sudokuImage;

  final SudokuModel sudokuModel;
  SudokuImage? sudokuImage;
}

class SudokuInitial extends SudokuState {
  SudokuInitial({SudokuModel? sudokuModel, super.sudokuImage}) : super(sudokuModel: sudokuModel ?? SudokuModel.empty());
}

class SudokuCellReplaced extends SudokuState {
  SudokuCellReplaced({required super.state, required this.changedCell}) : super.fromState();

  factory SudokuCellReplaced.replaceCellAtIndexWith({
    required SudokuState state,
    required int index,
    String? row,
    String? column,
    String? subgrid,
    int? value,
    Set<int>? possibleValues,
    Set<int>? testedValues,
  }) {
    final newCell = state.sudokuModel.cells[index].copyWith(
      row: row,
      column: column,
      subgrid: subgrid,
      value: value,
      possibleValues: possibleValues,
      testedValues: testedValues,
    );
    return SudokuCellReplaced.replaceCellAt(state: state, index: index, cell: newCell);
  }

  factory SudokuCellReplaced.replaceCellAt({
    required SudokuState state,
    required int index,
    required SudokuCellModel cell,
  }) {
    final newSudokuCells = List<SudokuCellModel>.from(state.sudokuModel.cells);
    newSudokuCells.replaceRange(index, index + 1, [cell]);
    final newSudoku = SudokuModel(cells: newSudokuCells);
    return SudokuCellReplaced(
      state: SudokuInitial(sudokuModel: newSudoku, sudokuImage: state.sudokuImage),
      changedCell: cell,
    );
  }

  final SudokuCellModel changedCell;
}

class SudokuImageSelectionStarted extends SudokuState {
  SudokuImageSelectionStarted({
    // required this.imagePathProvider,
    required super.state,
  }) : super.fromState();

  // final ImagePathProvider imagePathProvider;
}

class SudokuImageSelectionInProgress extends SudokuState {
  SudokuImageSelectionInProgress({required super.sudokuModel});
}

class SudokuImageSelectionSucceed extends SudokuState {
  SudokuImageSelectionSucceed({required super.state}) : super.fromState();
}

class SudokuCellsWithImages extends SudokuState {
  SudokuCellsWithImages({required super.state}) : super.fromState();
}

class SudokuCellValuesRecognitionInProgress extends SudokuState {
  SudokuCellValuesRecognitionInProgress({required super.state}) : super.fromState();
}

class SudokuCellValuesRecognitionFinished extends SudokuState {
  SudokuCellValuesRecognitionFinished({required super.state, required this.cellImages}) : super.fromState();

  List<Uint8List> cellImages;
}

class SudokuCellRepositioning extends SudokuState {
  SudokuCellRepositioning({required this.previousState}) : super.fromState(state: previousState);

  final SudokuState previousState;
}

class SudokuSolvingInProgress extends SudokuState {
  SudokuSolvingInProgress({required this.previousState}) : super.fromState(state: previousState);

  final SudokuState previousState;
}
