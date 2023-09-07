import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:sudoku_solver/services/image_process_service.dart';

import './sudoku_events.dart';
import './sudoku_states.dart';
import '../services/image_path_provider.dart';
import '../services/sudoku_solver_service.dart';

class SudokuBloc extends Bloc<SudokuEvent, SudokuState> {
  final logger = Logger('SudokuBloc');

  final ImagePathProvider _imagePathProvider;
  bool stopProcessing = false;

  SudokuBloc({required imagePathProvider})
      : _imagePathProvider = imagePathProvider,
        super(SudokuInitial()) {
    on<SudokuStarted>(_onStarted);
    on<SudokuSelectImagePressed>(_onSelectImagePressed);
    on<SudokuReplaceCellValueRequested>(_onReplaceCellValueRequested);
    on<SudokuImageRenderingDone>(_onSudokuImageRenderingDone);
    on<SudokuCellsRepositioningDone>(_onSudokuCellsRepositioningDone);
    on<SudokuCalculatePressed>(_onCalculateSudokuPressed);
    on<SudokuImageHidden>(_onSudokuImageHidden);
    on<SudokuImageSelected>(_onSudokuImageSelected);
    on<SudokuImageSelectionDone>(_onSudokuImageSelectionDone);
    on<SudokuImagePickerStarted>(_onSudokuImagePickerStarted);
  }

  void _onStarted(SudokuStarted event, Emitter<SudokuState> emit) {
    logger.info('Received event: $event');
    stopProcessing = true;
    emit(SudokuInitial());
    logger.info('Emitted state: $state');
  }

  void _onSelectImagePressed(
      SudokuSelectImagePressed event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');

    emit(SudokuImageSelectionStarted(
        imagePathProvider: _imagePathProvider, state: state));

    logger.info('Emitted state: $state');
  }

  void _onSudokuImagePickerStarted(
      SudokuImagePickerStarted event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');
    logger.info('Current state: $state');

    emit(SudokuImageSelectionInProgress(sudokuModel: state.sudokuModel));

    logger.info('Emitted state: $state');
  }

  void _onReplaceCellValueRequested(
      SudokuReplaceCellValueRequested event, Emitter<SudokuState> emit) {
    logger.info('Received event: $event');

    emit(SudokuCellReplaced.replaceCellAtIndexWith(
        state: state, index: event.index, value: event.value));
    logger.info('Emitted state: $state');
  }

  void _onSudokuImageRenderingDone(
      SudokuImageRenderingDone event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');
    logger.info('Current state: $state');

    if (state is! SudokuImageSelectionSucceed) {
      logger.shout('Error! Current state is not SudokuImageSelectionSucceed');
      return;
    }

    emit(SudokuCellsWithImages(
      state: state, //SudokuInitial(sudokuModel: newSudoku),
    ));
    logger.info('Emitted state: $state');
  }

  ///---------------------------------------------------------------------------
  void _onSudokuCellsRepositioningDone(
      SudokuCellsRepositioningDone event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');

    emit(SudokuCellValuesRecognitionInProgress(state: state));
    stopProcessing = false;

    if (state is! SudokuCellValuesRecognitionInProgress) {
      logger.shout(
          'Error! Current state is not SudokuCellValuesRecognitionInProgress');
      return;
    }

    var index = 0;
    final sudokuCellImages = state.sudokuImage!.sudokuCellImages;
    await for (final cellValue
        in ImageProcessService.convert(sudokuCellImages)) {
      if (state is SudokuInitial && stopProcessing) return;
      emit(SudokuCellReplaced.replaceCellAtIndexWith(
        state: state,
        index: index,
        value: cellValue,
      ));

      logger.info('Emitted state: $state');
      index++;
    }
  }

  ///---------------------------------------------------------------------------
  void _onCalculateSudokuPressed(
    SudokuCalculatePressed event,
    Emitter<SudokuState> emit,
  ) async {
    emit(SudokuSolvingInProgress(previousState: state));

    await for (final cell
        in SudokuSolverService.process(sudoku: state.sudokuModel)) {
      final restartButtonPressed = state is SudokuInitial && stopProcessing;
      if (restartButtonPressed) return;
      emit(
        SudokuCellReplaced.replaceCellAt(
          state: state,
          index: cell.index,
          cell: cell,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  void _onSudokuImageHidden(
      SudokuEvent event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');
    emit(SudokuCellRepositioning(previousState: state));
    logger.info('Emitted state: $state');
  }

  void _onSudokuImageSelected(
      SudokuImageSelected event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');

    state.sudokuImage = await SudokuImage.create(event.image);
    if (null == state.sudokuImage) {
      emit(SudokuInitial(sudokuModel: state.sudokuModel));
      return;
    }

    emit(SudokuImageSelectionSucceed(state: state));

    logger.info('Emitted state: $state');
  }

  void _onSudokuImageSelectionDone(
      SudokuImageSelectionDone event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');

    final imageFile = event.imageFile;
    if (null == imageFile) {
      emit(SudokuInitial(sudokuModel: state.sudokuModel));
      return;
    }

    final image = await ImageProcessService.read(imageFile);
    if (null == image) {
      emit(SudokuInitial(sudokuModel: state.sudokuModel));
      return;
    }

    state.sudokuImage = await SudokuImage.create(image);
    if (null == state.sudokuImage) {
      emit(SudokuInitial(sudokuModel: state.sudokuModel));
      return;
    }

    emit(SudokuImageSelectionSucceed(state: state));

    logger.info('Emitted state: $state');
  }
}
