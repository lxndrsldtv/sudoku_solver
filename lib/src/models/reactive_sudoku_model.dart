import 'dart:async';

import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/models/sudoku_cell_dto.dart';

typedef SudokuCellStateFactoryFunction = CellState Function({required Map<String, dynamic> params});

const int countOfSudokuSubgrids = 9;
const int countOfSudokuSibgridCells = 9;
const int valueOfEmptyCell = 0;
const int originValueOfEmptyCell = 0;

class ReactiveSudokuModel {
  final List<List<CellState>> cells;
  final StreamController<CellState> _sudokuStateController = StreamController<CellState>.broadcast();

  ReactiveSudokuModel({required SudokuCellStateFactoryFunction cellStateFactory})
      : cells = List<List<CellState>>.generate(
            countOfSudokuSubgrids,
            (subgrid) => List<CellState>.generate(
                  countOfSudokuSibgridCells,
                  (cell) => cellStateFactory(params: {'subgridIndex': subgrid, 'subgridCellIndex': cell}),
                )) {
    _init();
  }

  void _init() => cells.forEach(_forEachCellOfSubgrid(_setSudoku));

  void _setSudoku(CellState cell) => cell.sudoku = this;

  Stream<CellState> sudokuStateStream() => _sudokuStateController.stream;

  Stream<CellState> cellStateStream(int subgridIndex, int subgridCellIndex) {
    // to send current cell state to subscriber
    Future(() => _sudokuStateController.add(cells[subgridIndex][subgridCellIndex]));
    return _sudokuStateController.stream.where((state) =>
        state.coordinates.subgridIndex == subgridIndex && state.coordinates.subgridCellIndex == subgridCellIndex);
  }

  void loadData(List<SudokuCellDTO> cellDTOs) {
    cells.forEach(_forEachCellOfSubgrid(_clearCell));

    cellDTOs.forEach(_setCellOriginValue);
  }

  void _setCellOriginValue(SudokuCellDTO cellDto) {
    cells[cellDto.subgridIndex][cellDto.subgridCellIndex].originValue = cellDto.value;
    _sudokuStateController.add(cells[cellDto.subgridIndex][cellDto.subgridCellIndex]);
  }

  void Function(List<CellState>) _forEachCellOfSubgrid(void Function(CellState cell) action) =>
      (subgrid) => subgrid.forEach(action);

  void _clearCell(CellState cell) {
    cell.clear();
    _sudokuStateController.add(cell);
  }

  void stateChanged(CellState cell) => _sudokuStateController.add(cell);
}

class ReactiveSudokuLoggableModel extends ReactiveSudokuModel {
  final Logger logger;

  ReactiveSudokuLoggableModel({required super.cellStateFactory, required this.logger});

  @override
  Stream<CellState> cellStateStream(int subgridIndex, int subgridCellIndex) {
    logger.info(
        'ReactiveSudokuLoggableModel.subscribeToCellState(subgridIndex: $subgridIndex, subgridCellIndex: $subgridCellIndex)');

    final result = super.cellStateStream(subgridIndex, subgridCellIndex);

    return result;
  }

  @override
  void _clearCell(CellState cell) {
    logger.info(
        'ReactiveSudokuLoggableModel._clearCell(subgridIndex: ${cell.coordinates.subgridIndex}, subgridCellIndex: ${cell.coordinates.subgridCellIndex})');
    super._clearCell(cell);
  }

  @override
  void _setCellOriginValue(SudokuCellDTO cellDto) {
    logger.info(
        'ReactiveSudokuLoggableModel._setCellOriginValue(subgridIndex: ${cellDto.subgridIndex}, subgridCellIndex: ${cellDto.subgridCellIndex}, value: ${cellDto.value})');
    super._setCellOriginValue(cellDto);
  }

  @override
  void loadData(List<SudokuCellDTO> cellDtos) {
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
  ReactiveSudokuModel? _sudoku;

  int _value;
  int _originValue;
  Set<int> _possibleValues = {};
  Set<int> _testedValues = {};
  final CellCoordinates coordinates;

  CellState({
    required this.coordinates,
    int value = valueOfEmptyCell,
    int originValue = originValueOfEmptyCell,
  })  : _value = value,
        _originValue = originValue;

  set sudoku(ReactiveSudokuModel sudoku) => _sudoku = sudoku;

  set value(int value) {
    final cellHasNoOriginValue = _originValue == originValueOfEmptyCell;
    final newValueIsOneOfPossibleValues = value == valueOfEmptyCell || _possibleValues.contains(value);
    if (cellHasNoOriginValue && newValueIsOneOfPossibleValues) {
      _value = value;
    }
    _sudoku?.stateChanged(this);
  }

  set originValue(int value) {
    if (_originValue == originValueOfEmptyCell) {
      _originValue = value;
    }
    _sudoku?.stateChanged(this);
  }

  set possibleValues(Set<int> possibleValues) {
    _possibleValues = possibleValues;
    _sudoku?.stateChanged(this);
  }

  Set<int> get possibleValues => _possibleValues;

  set testedValues(Set<int> testedValues) {
    _testedValues = testedValues;
    _sudoku?.stateChanged(this);
  }

  Set<int> get testedValues => _testedValues;

  void reset() {
    _value = valueOfEmptyCell;
    _possibleValues = {};
    _testedValues = {};
    _sudoku?.stateChanged(this);
  }

  void clear() {
    _originValue = originValueOfEmptyCell;
    reset();
  }

  int get value => _originValue == valueOfEmptyCell ? _value : _originValue;
}
