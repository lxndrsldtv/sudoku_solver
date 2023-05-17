import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/models/sudoku_cell_model.dart';
import 'package:sudoku_solver/widgets/cell_info_widget.dart';

import './cell_info_widget_test_data.dart';

void main() async {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group(
    'CellInfoWidget ',
    (() {
      testWidgets('Test displaying cell with no value and no image',
          (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: CellInfoWidget(
          cell: SudokuCellModel(
              index: 0, row: 'R1', column: 'C1', subgrid: 'S01', value: 0),
        )));

        expect(find.byKey(const Key('Cell value:')), findsOneWidget);
        expect(find.byKey(const Key('')), findsOneWidget);
        expect(find.byKey(const Key('Cell image:')), findsOneWidget);
        expect(find.byKey(const Key('Image')), findsNothing);
        expect(find.byKey(const Key('EmptyImage')), findsOneWidget);
      });

      testWidgets('Test displaying cell with value and no image',
          (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: CellInfoWidget(
          cell: SudokuCellModel(
              index: 0, row: 'R1', column: 'C1', subgrid: 'S01', value: 1),
        )));

        expect(find.byKey(const Key('Cell value:')), findsOneWidget);
        expect(find.byKey(const Key('1')), findsOneWidget);
        expect(find.byKey(const Key('Cell image:')), findsOneWidget);
        expect(find.byKey(const Key('Image')), findsNothing);
        expect(find.byKey(const Key('EmptyImage')), findsOneWidget);
      });

      testWidgets('Test displaying cell with image and no value',
          (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: CellInfoWidget(
                cell: SudokuCellModel(
          index: 0,
          row: 'R1',
          column: 'C1',
          subgrid: 'S01',
          value: 0,
          image: cellImage,
        ))));

        expect(find.byKey(const Key('Cell value:')), findsOneWidget);
        expect(find.byKey(const Key('')), findsOneWidget);
        expect(find.byKey(const Key('Cell image:')), findsOneWidget);
        expect(find.byKey(const Key('Image')), findsOneWidget);
        expect(find.byKey(const Key('EmptyImage')), findsNothing);
      });

      testWidgets('Test displaying cell with value and image', (tester) async {
        await tester.pumpWidget(MaterialApp(
            home: CellInfoWidget(
                cell: SudokuCellModel(
          index: 0,
          row: 'R1',
          column: 'C1',
          subgrid: 'S01',
          value: 7,
          image: cellImage,
        ))));

        expect(find.byKey(const Key('Cell value:')), findsOneWidget);
        expect(find.byKey(const Key('7')), findsOneWidget);
        expect(find.byKey(const Key('Cell image:')), findsOneWidget);
        expect(find.byKey(const Key('Image')), findsOneWidget);
        expect(find.byKey(const Key('EmptyImage')), findsNothing);
      });
    }),
  );
}
