import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:sudoku_solver/models/sudoku_cell_model.dart';

import './cell_events.dart';
import './cell_states.dart';

class CellBloc extends Bloc<CellEvent, CellState> {
  final logger = Logger('CellBloc');

  CellBloc({required SudokuCellModel cellModel})
      : super(CellInitialised(cellModel: cellModel)) {
    on<CellReplaceWithRequested>(_onCellReplaceWithRequested);
  }

  void _onCellReplaceWithRequested(
      CellReplaceWithRequested event, Emitter<CellState> emit) {
    logger.info('Received event: $event');

    emit(state);
    logger.info('Emitted state: $state');
  }
}
