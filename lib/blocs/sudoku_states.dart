import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:sudoku_solver/models/app_settings_model.dart';
import 'package:sudoku_solver/models/sudoku_cell_model.dart';
import 'package:sudoku_solver/models/sudoku_model.dart';

// abstract
class SudokuState {
  SudokuState({required this.sudoku, required this.settings});

  SudokuState.fromState({required SudokuState state})
      : sudoku = state.sudoku,
        settings = state.settings;

  final SudokuModel sudoku;
  final AppSettingsModel settings;
}

class SudokuInitial extends SudokuState {
  SudokuInitial()
      : super(sudoku: SudokuModel.empty(), settings: AppSettingsModel());
// final SudokuModel sudoku;
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
      state: SudokuState(
        sudoku: newSudoku,
        settings: state.settings,
      ),
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
  SudokuCellValuesRecognitionInProgress(
      // {required SudokuState state, required this.cellImages})
      {required SudokuState state})
      : super.fromState(state: state);

  // List<Uint8List> cellImages;
}

class SudokuCellValuesRecognitionFinished extends SudokuState {
  SudokuCellValuesRecognitionFinished(
      {required SudokuState state, required this.cellImages})
      : super.fromState(state: state);

  List<Uint8List> cellImages;
}

class SudokuSettingsOpened extends SudokuState {
  SudokuSettingsOpened({required this.previousState})
      : super.fromState(state: previousState);

  final SudokuState previousState;
}

class SudokuSettingsChngd extends SudokuState {
  SudokuSettingsChngd({required this.previousState})
      : super.fromState(state: previousState);

  final SudokuState previousState;
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
