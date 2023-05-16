abstract class SudokuEvent {}

class SudokuStarted extends SudokuEvent {}

class SudokuImageSelected extends SudokuEvent {}

class SudokuImageDivided extends SudokuEvent {}

class SudokuImageProcessRequested extends SudokuEvent {}

class SudokuCellValueRecognitionRequested extends SudokuEvent {}

class SudokuCellPressed extends SudokuEvent {}

class SudokuCellValueSelected extends SudokuEvent {
  SudokuCellValueSelected({required this.index, required this.value});

  final int index;
  final int value;
}

class SudokuChangeCellValueActionCancelled extends SudokuEvent {}

class SudokuSelectImagePressed extends SudokuEvent {}

class SudokuCalculatePressed extends SudokuEvent {}

// class SudokuSettingsPressed extends SudokuEvent {}

// class SudokuSettingsChanged extends SudokuEvent {}
//
// class SudokuSettingClosed extends SudokuEvent {}

// class SudokuImageInCellSwitched extends SudokuEvent {}

class SudokuCellRepositioningRequested extends SudokuEvent {}