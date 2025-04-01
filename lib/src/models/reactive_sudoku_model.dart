import 'dart:async';

import 'package:sudoku_solver/src/logger/logger.dart';

typedef SudokuCellModelFactoryFunction = ReactiveSudokuCellModel Function({required Map<String, dynamic> params});

const int countOfSudokuSubgrids = 9;
const int countOfSudokuSibgridCells = 9;
const int valueOfEmptyCell = 0;
const int originValueOfEmptyCell = 0;

class ReactiveSudokuModel {
  final List<List<ReactiveSudokuCellModel>> cells;

  ReactiveSudokuModel({required SudokuCellModelFactoryFunction cellFactory})
      : cells = List<List<ReactiveSudokuCellModel>>.generate(
            countOfSudokuSubgrids,
            (subgrid) => List<ReactiveSudokuCellModel>.generate(
                  countOfSudokuSibgridCells,
                  (cell) => cellFactory(params: {'subgridIndex': subgrid, 'subgridCellIndex': cell}),
                ));

  Stream<CellState> cellStateStream(int subgridIndex, int subgridCellIndex) =>
      cells[subgridIndex][subgridCellIndex].stateStream();
}

class ReactiveSudokuLoggableModel extends ReactiveSudokuModel {
  final Logger logger;

  ReactiveSudokuLoggableModel({required super.cellFactory, required this.logger});

  @override
  Stream<CellState> cellStateStream(int subgridIndex, int subgridCellIndex) {
    logger.info(
        'ReactiveSudokuLoggableModel.subscribeToCellState(subgridIndex: $subgridIndex, subgridCellIndex: $subgridCellIndex)');

    final result = super.cellStateStream(subgridIndex, subgridCellIndex);

    return result;
  }
}

class CellCoordinates {
  final int subgridIndex;
  final int subgridCellIndex;

  CellCoordinates({required this.subgridIndex, required this.subgridCellIndex});

  @override
  String toString() => '$subgridIndex:$subgridCellIndex';
}

class CellState {
  final int value;
  final int originValue;
  final CellCoordinates coordinates;

  const CellState({
    required this.coordinates,
    this.value = valueOfEmptyCell,
    this.originValue = originValueOfEmptyCell,
  });

  CellState copyWith({required int value}) => CellState(coordinates: coordinates, value: value);
}

class ReactiveSudokuCellModel {
  CellState state;
  final StreamController<CellState> _controller;

  ReactiveSudokuCellModel({required int subgridIndex, required int subgridCellIndex})
      : state = CellState(coordinates: CellCoordinates(subgridIndex: subgridIndex, subgridCellIndex: subgridCellIndex)),
        _controller = StreamController<CellState>();

  Stream<CellState> stateStream() {
    _controller.add(state);
    return _controller.stream;
  }

  set value(int value) {
    state = state.copyWith(value: value);
    _controller.add(state);
  }

  void reset() {
    state = CellState(
      coordinates: state.coordinates,
      value: valueOfEmptyCell,
      originValue: state.originValue,
    );
    _controller.add(state);
  }
}

class ReactiveSudokuCellLoggableModel extends ReactiveSudokuCellModel {
  final Logger logger;

  ReactiveSudokuCellLoggableModel({
    required super.subgridIndex,
    required super.subgridCellIndex,
    required this.logger,
  });

  @override
  Stream<CellState> stateStream() {
    logger.info('ReactiveSudokuCellLoggableModel.subscribeToState(): ${state.coordinates.toString()}');
    return super.stateStream();
  }

  @override
  set value(int value) {
    logger.info('ReactiveSudokuCellLoggable.setState($value): ${state.coordinates.toString()}');
    super.value = value;
  }
}
