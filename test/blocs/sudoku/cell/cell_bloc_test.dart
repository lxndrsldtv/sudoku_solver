import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/blocs/sudoku_bloc.dart';
import 'package:sudoku_solver/blocs/sudoku_events.dart';
import 'package:sudoku_solver/blocs/sudoku_states.dart';
import 'package:sudoku_solver/integration_testing/image_path_provider.dart';

void main() {
  group('CellBloc', () {
    // late CellBloc cellBloc;
    //
    // setUp(() {
    //   cellBloc = CellBloc();
    // });
    //
    // test('Initial state is empty sudoku', () {
    //   expect(cellBloc.state.sudoku.cells.every((cell) => cell.value == 0),
    //       isTrue);
    // });
    //
    // blocTest(
    //   'emits SudokuInitial when SudokuStarted is added',
    //   build: () => cellBloc,
    //   act: (bloc) => bloc.add(SudokuStarted()),
    //   expect: () => [isA<SudokuInitial>()],
    //   verify: (bloc) => expect(
    //       bloc.state.sudoku.cells.every((cell) => cell.value == 0), isTrue),
    // );
    //
    // blocTest(
    //   'emits ',
    //   build: () => cellBloc,
    //   act: (bloc) => bloc.add(SudokuCellReplaceW)
    // );
    //
    // // blocTest(
    // //   'emits SudokuSingletonsFound when SudokuFindSingletonsRequested is added',
    // //   build: () => cellBloc,
    // //   act: (bloc) => cellBloc.add(SudokuFindSingletonsRequested()),
    // //   expect: () => [isA<SudokuSingletonsFound>()],
    // //   verify: (bloc) => expect(bloc.state.singletonCells.length > 0, isTrue),
    // // );
  });
}
