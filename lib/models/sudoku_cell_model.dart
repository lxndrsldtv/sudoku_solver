class SudokuCellModel {
  SudokuCellModel({
    required this.index,
    required this.row,
    required this.column,
    required this.subgrid,
    required this.value,
    this.possibleValues = const {},
    this.testedValues = const {},
  });

  final int index;
  final String row;
  final String column;
  final String subgrid;
  final int value;
  final Set<int> possibleValues;
  final Set<int> testedValues;

  SudokuCellModel copyWith(
      {int? index,
      String? row,
      String? column,
      String? subgrid,
      int? value,
      Set<int>? possibleValues,
      Set<int>? testedValues}) {
    return SudokuCellModel(
        index: index ?? this.index,
        row: row ?? this.row,
        column: column ?? this.column,
        subgrid: subgrid ?? this.subgrid,
        value: value ?? this.value,
        possibleValues: possibleValues ?? this.possibleValues,
        testedValues: testedValues ?? this.testedValues);
  }
}
