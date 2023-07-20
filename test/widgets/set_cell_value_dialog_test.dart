import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/models/sudoku_cell_model.dart';
import 'package:sudoku_solver/widgets/set_cell_value_dialog.dart';

void main() async {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group(
    'CellInfoWidget',
    (() {
      testWidgets('Test label text', (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: SetCellValueDialog(
          cellModel: SudokuCellModel(
              index: 0, row: 'R1', column: 'C1', subgrid: 'S01', value: 1),
        )));

        final finderByText1 = find.text('5');
        expect(finderByText1, findsOneWidget);

        final finderByText2 = find.text('Cell value:');
        expect(finderByText2, findsOneWidget);

        final finderByText3 = find.text('Clear cell');
        expect(finderByText3, findsOneWidget);

        // print(finderByType);
      });
    }),
  );
}
