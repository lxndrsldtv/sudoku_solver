import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/src/services/solver_service.dart';

void main() {
  group('rowIndex ', () {
    test('For cell 0 of subgrid 0 rowIndex is 0', () async {
      expect(SolverService().rowIndex(subgridCellIndex: 0, subgridIndex: 0), 0);
    });
    test('For cell 1 of subgrid 4 rowIndex is 3', () async {
      expect(SolverService().rowIndex(subgridCellIndex: 1, subgridIndex: 4), 3);
    });
    test('For cell 8 of subgrid 8 rowIndex is 8', () async {
      expect(SolverService().rowIndex(subgridCellIndex: 8, subgridIndex: 8), 8);
    });
  });
  group('columnIndex ', () {
    test('For cell 0 of subgrid 0 columnndex is 0', () async {
      expect(SolverService().columnIndex(subgridCellIndex: 0, subgridIndex: 0), 0);
    });
    test('For cell 1 of subgrid 4 columnIndex is 4', () async {
      expect(SolverService().columnIndex(subgridCellIndex: 1, subgridIndex: 4), 4);
    });
    test('For cell 8 of subgrid 8 columnIndex is 8', () async {
      expect(SolverService().columnIndex(subgridCellIndex: 8, subgridIndex: 8), 8);
    });
  });
}
