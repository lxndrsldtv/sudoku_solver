import 'dart:typed_data';

import 'package:camera/camera.dart';

import '../models/sudoku_cell_model.dart';
import '../models/sudoku_model.dart';

abstract class SudokuState {
  SudokuState({required this.sudoku});

  SudokuState.fromState({required SudokuState state}) : sudoku = state.sudoku;

  final SudokuModel sudoku;
}

class SudokuInitial extends SudokuState {
  SudokuInitial({SudokuModel? sudokuModel})
      : super(sudoku: sudokuModel ?? SudokuModel.empty());
}

class SudokuCellReplaced extends SudokuState {
  SudokuCellReplaced({required SudokuState state, required this.changedCell})
      : super.fromState(state: state);

  factory SudokuCellReplaced.replaceAtWithCopyWith({
    required SudokuState state,
    required int index,
    String? row,
    String? column,
    String? subgrid,
    int? value,
    Uint8List? image,
    Set<int>? possibleValues,
    Set<int>? testedValues,
  }) {
    final newCell = state.sudoku.cells[index].copyWith(
      row: row,
      column: column,
      subgrid: subgrid,
      value: value,
      image: image,
      possibleValues: possibleValues,
      testedValues: testedValues,
    );
    return SudokuCellReplaced.replaceCellAt(
        state: state, index: index, cell: newCell);
  }

  factory SudokuCellReplaced.replaceCellAt({
    required SudokuState state,
    required int index,
    required SudokuCellModel cell,
  }) {
    final newSudokuCells = List<SudokuCellModel>.from(state.sudoku.cells);
    newSudokuCells.replaceRange(index, index + 1, [cell]);
    final newSudoku = SudokuModel(cells: newSudokuCells);
    return SudokuCellReplaced(
      state: SudokuInitial(sudokuModel: newSudoku),
      changedCell: cell,
    );
  }

  final SudokuCellModel changedCell;
}

class SudokuImageSelectionSucceed extends SudokuState {
  SudokuImageSelectionSucceed(
      {required SudokuState state, required this.imageFile})
      : super.fromState(state: state);

  final XFile imageFile;
}

class SudokuImageDividingSucceed extends SudokuState {
  SudokuImageDividingSucceed(
      {required SudokuState state, required this.cellImages})
      : super.fromState(state: state);

  List<Uint8List> cellImages;
}

class SudokuCellValuesRecognitionInProgress extends SudokuState {
  SudokuCellValuesRecognitionInProgress({required SudokuState state})
      : super.fromState(state: state);
}

class SudokuCellValuesRecognitionFinished extends SudokuState {
  SudokuCellValuesRecognitionFinished(
      {required SudokuState state, required this.cellImages})
      : super.fromState(state: state);

  List<Uint8List> cellImages;
}

class SudokuCellRepositioning extends SudokuState {
  SudokuCellRepositioning({required this.previousState})
      : super.fromState(state: previousState);

  final SudokuState previousState;
}

class SudokuSolvingInProgress extends SudokuState {
  SudokuSolvingInProgress({required this.previousState})
      : super.fromState(state: previousState);

  final SudokuState previousState;
}

class SudokuSolvingInProgressSettingsOpened extends SudokuState {
  SudokuSolvingInProgressSettingsOpened({required this.previousState})
      : super.fromState(state: previousState);

  final SudokuState previousState;
}
