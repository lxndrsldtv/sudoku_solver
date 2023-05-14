import 'dart:typed_data';

class SudokuCellModel {
  SudokuCellModel({
    required this.index,
    required this.row,
    required this.column,
    required this.subgrid,
    required this.value,
    this.image,
    this.possibleValues = const {},
    this.testedValues = const {},
  });

  final int index;
  final String row;
  final String column;
  final String subgrid;
  final int value;
  final Uint8List? image;
  final Set<int> possibleValues;
  final Set<int> testedValues;

  SudokuCellModel copyWith(
      {int? index,
      String? row,
      String? column,
      String? subgrid,
      int? value,
      Uint8List? image,
      Set<int>? possibleValues,
      Set<int>? testedValues}) {
    return SudokuCellModel(
        index: index ?? this.index,
        row: row ?? this.row,
        column: column ?? this.column,
        subgrid: subgrid ?? this.subgrid,
        value: value ?? this.value,
        image: image ?? this.image,
        possibleValues: possibleValues ?? this.possibleValues,
        testedValues: testedValues ?? this.testedValues);
  }
}
