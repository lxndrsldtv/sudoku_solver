import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/blocs/sudoku_bloc.dart';
import 'package:sudoku_solver/blocs/sudoku_events.dart';
import 'package:sudoku_solver/blocs/sudoku_states.dart';

void main() {
  group('SudokuBloc', () {
    late SudokuBloc sudokuBloc;

    setUp(() {
      // sudokuBloc = SudokuBloc(imagePathProvider: StubImagePathProvider());
      sudokuBloc = SudokuBloc();
    });

    test('Initial state is empty sudoku', () {
      expect(sudokuBloc.state.sudokuModel.cells.every((cell) => cell.value == 0), isTrue);
    });

    blocTest(
      'emits SudokuInitial when SudokuStarted is added',
      build: () => sudokuBloc,
      act: (bloc) => bloc.add(SudokuStarted()),
      expect: () => [isA<SudokuInitial>()],
      verify: (bloc) => expect(bloc.state.sudokuModel.cells.every((cell) => cell.value == 0), isTrue),
    );
  });
}
