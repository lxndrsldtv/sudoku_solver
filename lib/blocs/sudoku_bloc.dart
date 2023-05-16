import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as image_tools;
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku_solver/services/sudoku_solver_service.dart';

import '../services/sudoku_utils_service.dart';
import './sudoku_events.dart';
import './sudoku_states.dart';

class SudokuBloc extends Bloc<SudokuEvent, SudokuState> {
  final logger = Logger('SudokuBloc');

  SudokuBloc() : super(SudokuInitial()) {
    on<SudokuStarted>(_onStarted);
    on<SudokuSelectImagePressed>(_onSelectImagePressed);
    on<SudokuCellValueSelected>(_onCellValueSelected);
    on<SudokuImageProcessRequested>(_onImageProcessRequested);
    on<SudokuCellValueRecognitionRequested>(_onCellValueRecognitionRequested);
    on<SudokuCalculatePressed>(_onCalculateSudokuPressed);
    on<SudokuCellRepositioningRequested>(_onCellRepositioningRequested);
  }

  void _onStarted(SudokuStarted event, Emitter<SudokuState> emit) {
    logger.info('Received event: SudokuStarted');

    emit(SudokuInitial());
    logger.info('Emitted state: SudokuInitial');
  }

  void _onSelectImagePressed(
      SudokuSelectImagePressed event, Emitter<SudokuState> emit) async {
    logger.info('Received event: SudokuSelectImagePressed');
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    emit(null == imageFile
        ? state
        : SudokuImageSelectionSucceed(
            state: SudokuInitial(
              sudokuModel: state.sudoku.copyWith(image: imageFile),
            ),
            imageFile: imageFile));
    logger.info('Emitted state: SudokuImageSelectionSucceed');
  }

  void _onCellValueSelected(
      SudokuCellValueSelected event, Emitter<SudokuState> emit) {
    logger.info('Received event: SudokuCellValueSelected');

    emit(SudokuCellReplaced.replaceAtWithCopyWith(
        state: state, index: event.index, value: event.value));
    logger.info('Emitted state: SudokuCellReplaced');
  }

  void _onImageProcessRequested(
      SudokuImageProcessRequested event, Emitter<SudokuState> emit) async {
    logger.info('Received event: SudokuImageProcessRequested');

    if (state is! SudokuImageSelectionSucceed) {
      logger.shout('Error! Current state is not SudokuImageSelectionSucceed');
      return;
    }

    final cellImages = await SudokuUtilsService.divideImage(
        path: (state as SudokuImageSelectionSucceed).imageFile.path);

    final cellsWithImages = state.sudoku.cells
        .mapIndexed((index, cell) => cell.copyWith(image: cellImages[index]))
        .toList();

    final newSudoku = state.sudoku.copyWith(cells: cellsWithImages);

    emit(SudokuImageDividingSucceed(
        state: SudokuInitial(sudokuModel: newSudoku),
        cellImages: cellImages));
    logger.info('Emitted state: SudokuImageDividingSucceed');
  }

  void _onCellValueRecognitionRequested(
      SudokuCellValueRecognitionRequested event,
      Emitter<SudokuState> emit) async {
    logger.info('Received event: SudokuCellValueRecognitionRequested');

    emit(SudokuCellValuesRecognitionInProgress(state: state));

    if (state is! SudokuCellValuesRecognitionInProgress) {
      logger.shout(
          'Error! Current state is not SudokuCellValuesRecognitionInProgress');
      return;
    }

    final cellImages = state.sudoku.cells.map((c) => c.image);

    var index = 0;
    const imageFileName = 'tmp.bmp';
    final imageFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/$imageFileName';

    final recognizer = TextRecognizer();

    for (final cellImage in cellImages) {
      if (null == cellImage) continue;

      final img = image_tools.decodeBmp(cellImage);
      if (null == img) {
        logger.shout('Error decoding BMP image. Index = $index');
        emit(SudokuCellReplaced.replaceAtWithCopyWith(
            state: state, index: index, value: 0, image: cellImage));
        logger.info('Emitted state: SudokuCellReplaced');
        continue;
      }

      final successEncoding =
          await image_tools.encodeBmpFile(imageFilePath, img);
      if (!successEncoding) {
        logger.shout('Error encoding BMP file. Index = $index');
        emit(SudokuCellReplaced.replaceAtWithCopyWith(
            state: state, index: index, value: 0, image: cellImage));
        logger.info('Emitted state: SudokuCellReplaced');
        continue;
      }

      final inputImage = InputImage.fromFilePath(imageFilePath);
      final recognizedText = await recognizer.processImage(inputImage);
      final value = int.tryParse(recognizedText.text) ?? 0;
      emit(SudokuCellReplaced.replaceAtWithCopyWith(
          state: state, index: index, value: value, image: cellImage));

      logger.info('Emitted state: SudokuCellReplaced');

      index++;

      try {
        File(imageFilePath).deleteSync();
      } catch (e) {
        logger.shout('Error deleting BMP file. Index = $index', e);
      }
    }
  }

  void _onCalculateSudokuPressed(
    SudokuCalculatePressed event,
    Emitter<SudokuState> emit,
  ) async {
    emit(SudokuSolvingInProgress(previousState: state));

    await _fillSingletonCells(emit);

    var solvedSudoku = state.sudoku;
    var processedCells = Queue<int>();

    var sudokuContainsEmptyCells =
        solvedSudoku.cells.firstWhereOrNull((c) => c.value == 0) != null;

    while (sudokuContainsEmptyCells) {
      var stillInCalculatingState = state is SudokuSolvingInProgress ||
          state is SudokuCellReplaced ||
          state is SudokuSolvingInProgressSettingsOpened;
      if (!stillInCalculatingState) break;

      var index = processedCells.isNotEmpty ? processedCells.first + 1 : 0;

      final allCellsAreProcessed = index > solvedSudoku.cells.length;
      if (allCellsAreProcessed) {
        break;
      }

      var cell = solvedSudoku.cells // get next empty cell
          .firstWhereOrNull((cell) => cell.value == 0 && cell.index >= index);

      final nextEmptyCellNotFound = null == cell;
      if (nextEmptyCellNotFound) {
        break;
      }

      final cellPossibleValues = SudokuSolverService.getPossibleValuesForCell(
          sudoku: solvedSudoku, cell: cell);

      final untestedValues = cellPossibleValues.difference(cell.testedValues);

      final notAllPossibleValuesAreTested = untestedValues.isNotEmpty;
      if (notAllPossibleValuesAreTested) {
        final cellValue = untestedValues.min; // test next min untested value
        emit(
          SudokuCellReplaced.replaceAtWithCopyWith(
            state: state,
            index: cell.index,
            value: cellValue,
            possibleValues: {},
            testedValues: cell.testedValues.union({cellValue}),
          ),
        );
        processedCells.addFirst(cell.index);
      } else {
        emit(
          SudokuCellReplaced.replaceAtWithCopyWith(
            state: state,
            index: cell.index,
            value: 0,
            possibleValues: {},
            testedValues: {},
          ),
        );
        if (processedCells.isNotEmpty) {
          // get last processed cell by index from stack, i.e. do step back
          cell = solvedSudoku.cells[processedCells.removeFirst()];
          emit(
            SudokuCellReplaced.replaceAtWithCopyWith(
              state: state,
              index: cell.index,
              value: 0,
              possibleValues: {},
            ),
          );
        }
      }
      solvedSudoku = state.sudoku;
      sudokuContainsEmptyCells =
          solvedSudoku.cells.firstWhereOrNull((c) => c.value == 0) != null;
      await Future.delayed(const Duration(milliseconds: 1), () {});
    }
    return;
  }

  Future<void> _fillSingletonCells(Emitter<SudokuState> emit) async {
    while (true) {
      var partSolvedSudoku = state.sudoku;

      partSolvedSudoku =
          SudokuSolverService.fillCellsWithPossibleValues(partSolvedSudoku);

      final sudokuSingletonCells = partSolvedSudoku.cells
          .groupListsBy((cell) => cell.subgrid)
          .values
          .map((e) => SudokuSolverService.findSingletonCells(e))
          .flattened;

      final singletonCellsNotFound = sudokuSingletonCells.isEmpty;
      if (singletonCellsNotFound) {
        break;
      }

      for (final cell in sudokuSingletonCells) {
        // partSolvedSudoku.cells.replaceRange(cell.index, cell.index + 1, [cell]);
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
  }

  void _onCellRepositioningRequested(
      SudokuEvent event, Emitter<SudokuState> emit) async {
    logger.info('Received event: $event');
    emit(SudokuCellRepositioning(previousState: state));
    logger.info('Emitted state: $state');
  }
}
