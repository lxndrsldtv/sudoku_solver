import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/src/models/reactive_sudoku_model.dart';

final sut = ReactiveSudokuModel(
    cellStateFactory: ({required Map<String, dynamic> params}) => CellState(
          coordinates: CellCoordinates(
            subgridIndex: params['subgridIndex'] as int,
            subgridCellIndex: params['subgridCellIndex'] as int,
          ),
        ));

void main() {
  group('rowIndex ', () {
    test('For cell 0 of subgrid 0 rowIndex is 0', () async {
      expect(sut.rowIndex(subgridCellIndex: 0, subgridIndex: 0), 0);
    });
    test('For cell 1 of subgrid 4 rowIndex is 3', () async {
      expect(sut.rowIndex(subgridCellIndex: 1, subgridIndex: 4), 3);
    });
    test('For cell 8 of subgrid 8 rowIndex is 8', () async {
      expect(sut.rowIndex(subgridCellIndex: 8, subgridIndex: 8), 8);
    });
  });
  group('columnIndex ', () {
    test('For cell 0 of subgrid 0 columnndex is 0', () async {
      expect(sut.columnIndex(subgridCellIndex: 0, subgridIndex: 0), 0);
    });
    test('For cell 1 of subgrid 4 columnIndex is 4', () async {
      expect(sut.columnIndex(subgridCellIndex: 1, subgridIndex: 4), 4);
    });
    test('For cell 8 of subgrid 8 columnIndex is 8', () async {
      expect(sut.columnIndex(subgridCellIndex: 8, subgridIndex: 8), 8);
    });
  });
}
