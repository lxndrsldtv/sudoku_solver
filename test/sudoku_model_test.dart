import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/models/sudoku_model.dart';

void main() {
  test(
      'List of SudokuCells must be received from correct List<int> '
      'using extension function', () async {
    final cells = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]
        .mapToSudokuCellModelList();
    expect(cells.length, 16);
  });

  test(
      'Mapping list of int to list of SudokuCellModels must throw exception, '
      'if incoming list is not correct', () async {
    expect([1, 2, 3, 4, 1].mapToSudokuCellModelList,
        throwsAssertionError);
  });
}
