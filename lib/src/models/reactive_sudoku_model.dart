import 'dart:async';

import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/models/sudoku_cell_dto.dart';

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

  void loadData(List<SudokuCellDto> cellDtos) {
    cells.forEach(_forEachCellOfSubgrid(_clearCell));

    cellDtos.forEach(_setCellOriginValue);
  }

  void _setCellOriginValue(SudokuCellDto cellDto) {
    cells[cellDto.subgridIndex][cellDto.subgridCellIndex].state.originValue = cellDto.value;
  }

  void Function(List<ReactiveSudokuCellModel>) _forEachCellOfSubgrid(
      void Function(
        ReactiveSudokuCellModel cell,
      ) action) {
    return (subgrid) => subgrid.forEach(action);
  }

  void _clearCell(ReactiveSudokuCellModel cell) => cell.state.clear();
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

  @override
  void _clearCell(ReactiveSudokuCellModel cell) {
    logger.info(
        'ReactiveSudokuLoggableModel._clearCell(subgridIndex: ${cell.state.coordinates.subgridIndex}, subgridCellIndex: ${cell.state.coordinates.subgridCellIndex})');
    super._clearCell(cell);
  }

  @override
  void _setCellOriginValue(SudokuCellDto cellDto) {
    logger.info(
        'ReactiveSudokuLoggableModel._setCellOriginValue(subgridIndex: ${cellDto.subgridIndex}, subgridCellIndex: ${cellDto.subgridCellIndex}, value: ${cellDto.value})');
    super._setCellOriginValue(cellDto);
  }

  @override
  void loadData(List<SudokuCellDto> cellDtos) {
    logger.info('ReactiveSudokuLoggableModel.loadData(cellDtos: $cellDtos)');
    super.loadData(cellDtos);
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
  ReactiveSudokuCellModel? _cell;

  int _value;
  int _originValue;
  final CellCoordinates coordinates;

  CellState({
    required this.coordinates,
    int value = valueOfEmptyCell,
    int originValue = originValueOfEmptyCell,
  })  : _value = value,
        _originValue = originValue;

  set cell(ReactiveSudokuCellModel cell) => _cell = cell;

  set value(int value) {
    _value = value;
    _cell?.stateChanged();
  }

  set originValue(int value) {
    _originValue = value;
    _cell?.stateChanged();
  }

  void reset() {
    _value = valueOfEmptyCell;
    _cell?.stateChanged();
  }

  void clear() {
    _value = valueOfEmptyCell;
    _originValue = originValueOfEmptyCell;
    _cell?.stateChanged();
  }

  int get value => _originValue == valueOfEmptyCell ? _value : _originValue;
}

class ReactiveSudokuCellModel {
  CellState state;
  final StreamController<CellState> _controller;

  ReactiveSudokuCellModel({required int subgridIndex, required int subgridCellIndex})
      : state = CellState(coordinates: CellCoordinates(subgridIndex: subgridIndex, subgridCellIndex: subgridCellIndex)),
        _controller = StreamController<CellState>();

  Stream<CellState> stateStream() {
    state.cell = this;
    _controller.add(state);
    return _controller.stream;
  }

  void stateChanged() => _controller.add(state);
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
}
