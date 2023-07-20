import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/blocs/sudoku_bloc.dart';
import 'package:sudoku_solver/blocs/sudoku_events.dart';
import 'package:sudoku_solver/blocs/sudoku_states.dart';
import 'package:sudoku_solver/integration_testing/image_path_provider.dart';

void main() {
  group('SudokuBloc', () {
    late SudokuBloc sudokuBloc;

    setUp(() {
      sudokuBloc = SudokuBloc(imagePathProvider: StubImagePathProvider());
    });

    test('Initial state is empty sudoku', () {
      expect(sudokuBloc.state.sudoku.cells.every((cell) => cell.value == 0),
          isTrue);
    });

    blocTest(
      'emits SudokuInitial when SudokuStarted is added',
      build: () => sudokuBloc,
      act: (bloc) => bloc.add(SudokuStarted()),
      expect: () => [isA<SudokuInitial>()],
      verify: (bloc) => expect(
          bloc.state.sudoku.cells.every((cell) => cell.value == 0), isTrue),
    );

    // blocTest(
    //   'emits SudokuSolvingInProgress when SudokuSolvingStarted is added',
    //   build: () => sudokuBloc,
    //   act: (bloc) => bloc.add(SudokuSolvingStarted()),
    //   expect: () => [isA<SudokuSolvingInProgress>()],
    // );

    // blocTest(
    //   'emits SudokuSingletonsFound when SudokuFindSingletonsRequested is added',
    //   build: () => sudokuBloc,
    //   act: (bloc) => sudokuBloc.add(SudokuFindSingletonsRequested()),
    //   expect: () => [isA<SudokuSingletonsFound>()],
    //   verify: (bloc) => expect(bloc.state.singletonCells.length > 0, isTrue),
    // );
  });
}
