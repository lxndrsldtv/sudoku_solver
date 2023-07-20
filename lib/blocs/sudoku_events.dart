import '../models/sudoku_model.dart';

abstract class SudokuEvent {}

// class SudokuInitializeWithRequested extends SudokuEvent {
//   SudokuInitializeWithRequested({required this.sudokuModel});
//
//   final SudokuModel sudokuModel;
// }

class SudokuStarted extends SudokuEvent {}

class SudokuImageSelected extends SudokuEvent {}

class SudokuImageDivided extends SudokuEvent {}

class SudokuImageProcessRequested extends SudokuEvent {}

class SudokuCellValueRecognitionRequested extends SudokuEvent {}

class SudokuCellPressed extends SudokuEvent {}

class SudokuReplaceCellValueRequested extends SudokuEvent {
  SudokuReplaceCellValueRequested({required this.index, required this.value});

  final int index;
  final int value;
}

class SudokuChangeCellValueActionCancelled extends SudokuEvent {}

class SudokuSelectImagePressed extends SudokuEvent {}

class SudokuCalculatePressed extends SudokuEvent {}

class SudokuCellRepositioningRequested extends SudokuEvent {}

class SudokuImageRecognitionInCellAtIndexRequested extends SudokuEvent {
  final int cellIndex;

  SudokuImageRecognitionInCellAtIndexRequested({required this.cellIndex});
}

class SudokuFindSingletonsRequested extends SudokuEvent {}

class SudokuSolvingStarted extends SudokuEvent {}

class SudokuSolvingFinished extends SudokuEvent {}