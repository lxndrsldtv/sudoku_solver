class AppSettingsModel {
  final gridSettings = SudokuGridSettingsModel();
  final cellSettings = SudokuCellSettingsModel();
  final sudokuSettings = SudokuSettingsModel();
}

class SudokuCellSettingsModel {
  bool displayCellImage = true;
}

class SudokuGridSettingsModel {
  double cellDividerSize = 1.0;
  double  subgridDividerSize = 8.0;
}

class SudokuSettingsModel {
  int sudokuSize = 9; // default is sudoku of 9x9
}