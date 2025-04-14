import 'dart:async';

import 'package:collection/collection.dart';
import 'package:sudoku_solver/src/logger/logger.dart';
import 'package:sudoku_solver/src/models/sudoku_cell_dto.dart';

typedef SudokuCellStateFactoryFunction = CellState Function({required Map<String, dynamic> params});

const int countOfSudokuSubgrids = 9;
const int countOfSudokuSibgridCells = 9;
const int emptyValue = 0;

const cellPossibleValueCompleteSet = {1, 2, 3, 4, 5, 6, 7, 8, 9};

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

  Future<void> cellValueChanged(CellState cell) async {
    // recalculate possible values for dependent cells
    calculatePossibleValuesForGivenCells((await _cellsDependentOnGiven(cell)).toList());

    _sudokuStateController.add(cell);
  }

  void cellPossibleValuesChanged(CellState cell) async {
    _sudokuStateController.add(cell);
  }

  void cellTestedValuesChanged(CellState cell) async {
    _sudokuStateController.add(cell);
  }

  void cellOriginValueChanged(CellState cell) async {
    _sudokuStateController.add(cell);
  }

  void calculatePossibleValues() async {
    final sudokuCells = cells.flattenedToList;

    for (var cell in sudokuCells) {
      if (cell.value != 0) continue;

      cell.possibleValues = await calculateCellPossibleValues(cell);
    }
  }

  void calculatePossibleValuesForGivenCells(List<CellState> cells) async {
    for (var cell in cells) {
      if (cell.value != 0) continue;

      cell.possibleValues = await calculateCellPossibleValues(cell);

      _sudokuStateController.add(cell);
    }
  }

  Future<Set<int>> calculateCellPossibleValues(CellState cell) async {
    final sudokuCells = cells.flattenedToList;

    final valuesOfCellsInSameRow = await _cellRowValues(cell, sudokuCells);

    final valuesOfCellsInSameColumn = await _cellColumnValues(cell, sudokuCells);

    final valuesOfCellsInSameSubgrid = await _cellSubgridValues(cell, sudokuCells);

    return Future(() => cellPossibleValueCompleteSet
        .difference(valuesOfCellsInSameRow.toSet())
        .difference(valuesOfCellsInSameColumn.toSet())
        .difference(valuesOfCellsInSameSubgrid.toSet()));
  }

  final _memCellRowValues = <CellState, Iterable<int>>{};
  Future<Iterable<int>> _cellRowValues(
    CellState cell,
    List<CellState> cells,
  ) async =>
      _memoizedCellValues(
        cell: cell,
        sudoku: cells,
        memoizedValues: _memCellRowValues,
        calcValues: (c, s) async => (await _cellRowCells(c, s)).map((c) => c.value),
      );

  final _memCellColumnValues = <CellState, Iterable<int>>{};
  Future<Iterable<int>> _cellColumnValues(
    CellState cell,
    List<CellState> cells,
  ) async =>
      _memoizedCellValues(
        cell: cell,
        sudoku: cells,
        memoizedValues: _memCellColumnValues,
        calcValues: (c, s) async => (await _cellColumnCells(c, s)).map((c) => c.value),
      );

  final _memCellSubgridValues = <CellState, Iterable<int>>{};
  Future<Iterable<int>> _cellSubgridValues(
    CellState cell,
    List<CellState> cells,
  ) async =>
      _memoizedCellValues(
        cell: cell,
        sudoku: cells,
        memoizedValues: _memCellSubgridValues,
        calcValues: (c, s) async => (await _cellSubgridCells(c, s)).map((c) => c.value),
      );

  Future<Iterable<int>> _memoizedCellValues({
    required CellState cell,
    required List<CellState> sudoku,
    required Map<CellState, Iterable<int>> memoizedValues,
    required Future<Iterable<int>> Function(CellState c, List<CellState> s) calcValues,
  }) async {
    Iterable<int>? result = memoizedValues[cell];
    if (result != null) {
      return result;
    }

    result = await calcValues(cell, sudoku);

    memoizedValues[cell] = result;

    return result;
  }

  // memoize result of _cellRowCells
  // _cellRowCells calculates all cells of a row, to which the given cell belongs
  final memCellRowCells = <CellState, Iterable<CellState>>{};
  Future<Iterable<CellState>> _cellRowCells(CellState cell, List<CellState> cells) async => memCellRowCells.putIfAbsent(
        cell,
        () => cells.where(
          (c) =>
              rowIndex(subgridIndex: c.coordinates.subgridIndex, subgridCellIndex: c.coordinates.subgridCellIndex) ==
              rowIndex(
                  subgridIndex: cell.coordinates.subgridIndex, subgridCellIndex: cell.coordinates.subgridCellIndex),
        ),
      );

  // memoize result of _cellColumnCells
  // _cellColumnCells calculates all cells of a column, to which the given cell belongs
  final memCellColumnCells = <CellState, Iterable<CellState>>{};
  Future<Iterable<CellState>> _cellColumnCells(CellState cell, List<CellState> cells) async =>
      memCellColumnCells.putIfAbsent(
        cell,
        () => cells.where(
          (c) =>
              columnIndex(subgridIndex: c.coordinates.subgridIndex, subgridCellIndex: c.coordinates.subgridCellIndex) ==
              columnIndex(
                  subgridIndex: cell.coordinates.subgridIndex, subgridCellIndex: cell.coordinates.subgridCellIndex),
        ),
      );

  // memoize result of _cellSubgridCells
  // _cellSubgridCells calculates all cells of a subgrid, to which the given cell belongs
  final memCellSubgridCells = <CellState, Iterable<CellState>>{};
  Future<Iterable<CellState>> _cellSubgridCells(CellState cell, List<CellState> cells) async =>
      memCellSubgridCells.putIfAbsent(
        cell,
        () => cells.where((c) => c.coordinates.subgridIndex == cell.coordinates.subgridIndex),
      );

  Future<Iterable<CellState>> _cellsDependentOnGiven(CellState cell) async {
    final sudokuCells = cells.flattenedToList;
    final r = await _cellRowCells(cell, sudokuCells);
    final c = await _cellColumnCells(cell, sudokuCells);
    final s = await _cellSubgridCells(cell, sudokuCells);
    return {...r, ...c, ...s};
  }

  // memoize result of rowIndex calculation
  final memRowIndex = List.generate(9, (_) => List<int?>.generate(9, (_) => null));

  int rowIndex({required int subgridIndex, required int subgridCellIndex}) =>
      memRowIndex[subgridIndex][subgridCellIndex] ??= (subgridCellIndex / 3).floor() + (subgridIndex / 3).floor() * 3;

  // memoize result of columnIndex calculation
  final memColIndex = List.generate(9, (_) => List<int?>.generate(9, (_) => null));
  int columnIndex({required int subgridIndex, required int subgridCellIndex}) =>
      memColIndex[subgridIndex][subgridCellIndex] ??= subgridCellIndex % 3 + (subgridIndex % 3) * 3;
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
  void clearCell(CellState cell) {
    logger.info(
        'ReactiveSudokuLoggableModel._clearCell(subgridIndex: ${cell.coordinates.subgridIndex}, subgridCellIndex: ${cell.coordinates.subgridCellIndex})');
    super._clearCell(cell);
  }

  @override
  void setCellOriginValue(SudokuCellDTO cellDto) {
    logger.info(
        'ReactiveSudokuLoggableModel._setCellOriginValue(subgridIndex: ${cellDto.subgridIndex}, subgridCellIndex: ${cellDto.subgridCellIndex}, value: ${cellDto.value})');
    super._setCellOriginValue(cellDto);
  }

  @override
  void loadData(List<SudokuCellDTO> cellDtos) {
    logger.info('ReactiveSudokuLoggableModel.loadData(cellDtos: $cellDtos)');
    super.loadData(cellDtos);
  }

  @override
  Future<void> cellValueChanged(CellState cell) async {
    logger.info(
        'ReactiveSudokuLoggableModel.stateChanged(subgridIndex: ${cell.coordinates.subgridIndex}, subgridCellIndex: ${cell.coordinates.subgridCellIndex})');
    super.cellValueChanged(cell);
  }

  @override
  void calculatePossibleValuesForGivenCells(List<CellState> cells) {
    logger.info('ReactiveSudokuLoggableModel.calculatePossibleValuesForGivenCells(cells: ${cells.length})');
    super.calculatePossibleValuesForGivenCells(cells);
  }

  @override
  Future<Set<int>> calculateCellPossibleValues(CellState cell) async {
    logger.info(
        'ReactiveSudokuLoggableModel.calculateCellPossibleValues(subgridIndex: ${cell.coordinates.subgridIndex}, subgridCellIndex: ${cell.coordinates.subgridCellIndex})');
    return super.calculateCellPossibleValues(cell);
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
    int value = emptyValue,
    int originValue = emptyValue,
  })  : _value = value,
        _originValue = originValue;

  set sudoku(ReactiveSudokuModel sudoku) => _sudoku = sudoku;

  set value(int value) {
    final cellHasNoOriginValue = _originValue == emptyValue;
    final newValueIsOneOfPossibleValues = value == emptyValue || _possibleValues.contains(value);
    if (cellHasNoOriginValue && newValueIsOneOfPossibleValues) {
      _value = value;
    }
    _sudoku?.cellValueChanged(this);
  }

  set originValue(int value) {
    if (_originValue == emptyValue) {
      _originValue = value;
    }
    _sudoku?.cellValueChanged(this);
  }

  set possibleValues(Set<int> possibleValues) {
    _possibleValues = possibleValues;
  }

  Set<int> get possibleValues => _possibleValues;

  set testedValues(Set<int> testedValues) {
    _testedValues = testedValues;
  }

  Set<int> get testedValues => _testedValues;

  void reset() {
    _value = emptyValue;
    _possibleValues = {};
    _testedValues = {};
    _sudoku?.cellValueChanged(this);
  }

  void clear() {
    _originValue = emptyValue;
    reset();
  }

  int get value => _originValue == emptyValue ? _value : _originValue;
}
