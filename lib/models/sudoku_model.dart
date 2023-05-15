import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cross_file/cross_file.dart';

import 'sudoku_cell_model.dart';

class SudokuModel {
  final SudokuSize size;
  final List<SudokuCellModel> cells;
  final XFile? imageFile;

  SudokuModel(
      {required this.cells, this.size = const SudokuSize(), this.imageFile});

  SudokuModel.empty({this.size = const SudokuSize()})
      : cells = (List<int>.generate(size.cells, (index) => 0))
            .mapToSudokuCellModelList(),
        imageFile = null;

  SudokuModel copyWith(
      {SudokuSize? size, List<SudokuCellModel>? cells, XFile? image}) {
    return SudokuModel(
        size: size ?? this.size,
        cells: cells ?? this.cells,
        imageFile: image ?? imageFile);
  }

  bool isSolved() {
    return cells.fold(
      true,
      (prevValue, cell) =>
          prevValue &&
          cell.value >= 1 && // standard sudoku min cell values
          cell.value <= size.rows && // rows must be equal to columns,
          // so doesn't matter what to use
          _isCellValueUniqueForRowAndColumn(cell) &&
          _isCellValueUniqueForSubGrid(cell),
    );
  }

  bool _isCellValueUniqueForRowAndColumn(SudokuCellModel cell) {
    return cells
            .where((it) =>
                it.row == cell.row &&
                it.column == cell.column &&
                it.value == cell.value)
            .length ==
        1;
  }

  bool _isCellValueUniqueForSubGrid(SudokuCellModel cell) {
    return cells
            .where((it) => it.subgrid == cell.subgrid && it.value == cell.value)
            .length ==
        1;
  }
}

class SudokuSize {
  const SudokuSize({int size = 3})
      : rows = size * size,
        columns = size * size,
        cells = size * size * size * size;

  final int rows;
  final int columns;
  final int cells;
}

extension SudokuCellModelExt on List<int> {
  List<SudokuCellModel> mapToSudokuCellModelList() {
    final sudokuSize = sqrt(length);
    assert(0 == sudokuSize % 1);

    final subGridSize = sqrt(sudokuSize);
    assert(0 == subGridSize % 1);

    //supposed, that values go in direct order, from R1C1, R1C2, ... to R9C9, etc.
    getRowByIndex(int index, int sudokuSize) => 'R${index ~/ sudokuSize + 1}';

    getColumnByIndex(int index, int sudokuSize) =>
        'C${(index - (index ~/ sudokuSize) * sudokuSize) + 1}';

    String getSubGridRowByIndex(int index, int subGridSize, int sudokuSize) {
      final row = (index ~/ sudokuSize) ~/ subGridSize;
      final column =
          (index - (index ~/ sudokuSize) * sudokuSize) ~/ subGridSize;
      return 'S${row + 1}${column + 1}';
    }

    return mapIndexed((index, element) => SudokuCellModel(
          index: index,
          row: getRowByIndex(index, sudokuSize.truncate()),
          column: getColumnByIndex(index, sudokuSize.truncate()),
          subgrid: getSubGridRowByIndex(
              index, subGridSize.truncate(), sudokuSize.truncate()),
          value: element,
        )).toList();
  }
}
