class AppSettingsModel {
  final gridSettings = SudokuGridSettingModel();
  final cellSettings = SudokuCellSettingsModel();
}

class SudokuCellSettingsModel {
  bool displayCellImage = true;
}

class SudokuGridSettingModel {
  double cellDividerSize = 1.0;
  double  subgridDividerSize = 8.0;
  // double cellDividerSize = 0.0;
  // double  subgridDividerSize = 0.0;
}