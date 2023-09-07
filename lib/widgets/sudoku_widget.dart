import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

import './sudoku_cell_widget.dart';
import '../blocs/presentation/presentation_bloc.dart';
import '../blocs/presentation/presentation_states.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/sudoku_bloc.dart';
import '../blocs/sudoku_events.dart';
import '../blocs/sudoku_states.dart';
import '../models/sudoku_model.dart';
import 'settings_dialog.dart';

class SudokuWidget extends StatelessWidget {
  final logger = Logger('SudokuWidget');

  SudokuWidget({super.key});

  SizedBox verticalDivider(
      {required int index,
      required SudokuModel sudoku,
      double cellDividerSize = 2.0,
      double subgridDividerSize = 4.0}) {
    final isSubgridBorder = (index + 1) % sqrt(sudoku.size.columns) == 0;
    final isLastInRow = (index + 1) % sudoku.size.columns == 0;

    final cellDivider =
        SizedBox(width: cellDividerSize, height: cellDividerSize);

    final subgridDivider =
        SizedBox(width: subgridDividerSize, height: subgridDividerSize);

    const lastInRowDivider = SizedBox(width: 0.0, height: 0.0);

    if (isSubgridBorder && isLastInRow) {
      return lastInRowDivider;
    }

    if (isSubgridBorder) {
      return subgridDivider;
    }

    return cellDivider;
  }

  Row horizontalDivider(
      {required int index,
      required SudokuModel sudoku,
      required double cellSize,
      double cellDividerSize = 2.0,
      double subgridDividerSize = 4.0}) {
    final isSubgridBorder =
        (index + 1) % (sudoku.size.columns * sqrt(sudoku.size.columns)) == 0;

    final isSubgridLast =
        (index + 1) ~/ (sudoku.size.columns * sqrt(sudoku.size.columns)) ==
            sqrt(sudoku.size.columns);

    const lastSubgridDivider =
        Row(children: [SizedBox(width: 0.0, height: 0.0)]);

    final ordinarySubgridDivider = Row(children: [
      SizedBox(
          width: cellSize * sudoku.size.columns, height: subgridDividerSize)
    ]);

    final cellDivider = Row(children: [
      SizedBox(width: cellSize * sudoku.size.columns, height: cellDividerSize)
    ]);

    if (isSubgridBorder && isSubgridLast) {
      return lastSubgridDivider;
    }

    if (isSubgridBorder) {
      return ordinarySubgridDivider;
    }

    return cellDivider;
  }

  List<Row> buildSudokuGrid(
      {required SudokuModel sudoku,
      required double cellSize,
      double cellDividerSize = 2.0,
      double subgridDividerSize = 4.0}) {
    final rows = <Row>[];

    // fill row with cells
    sudoku.cells.foldIndexed(<Widget>[], (index, prevValue, cell) {
      prevValue.add(Flexible(
          child: SudokuCellWidget(
              key: Key('ci${cell.index.toString()}'),
              cellSize: cellSize,
              cellIndex: cell.index)));
      // add vertical divider (SizedBox of some width between cells)
      prevValue.add(verticalDivider(
          index: index,
          sudoku: sudoku,
          cellDividerSize: cellDividerSize,
          subgridDividerSize: subgridDividerSize));

      // when row completely filled, add completed row to list
      final rowFilledCompletely = (index + 1) % sudoku.size.columns == 0;
      if (rowFilledCompletely) {
        rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.center, children: prevValue));
        // add horizontal divider of rows (empty row of some height)
        rows.add(horizontalDivider(
            index: index,
            sudoku: sudoku,
            cellSize: cellSize,
            cellDividerSize: cellDividerSize,
            subgridDividerSize: subgridDividerSize));
        // reset cell accumulator (row children)
        prevValue = <Widget>[];
      }

      return prevValue;
    });

    return rows;
  }

  Column sudokuWidget(
          {required SudokuModel sudoku,
          required double cellSideLength,
          required double cellDividerSize,
          required double subgridDividerSize}) =>
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildSudokuGrid(
              sudoku: sudoku,
              cellSize: cellSideLength,
              cellDividerSize: cellDividerSize,
              subgridDividerSize: subgridDividerSize));

  Opacity imageWidget(
          {required SudokuBloc bloc,
          required double opacity,
          String? path,
          Uint8List? image,
          required double cellSideLength}) =>
      Opacity(
        opacity: opacity,
        child: SizedBox(
            width: cellSideLength * bloc.state.sudokuModel.size.columns,
            height: cellSideLength * bloc.state.sudokuModel.size.rows,
            child: path != null
                ? Image.file(File(path))
                : image != null
                    ? Image.memory(image)
                    : Container()),
      );

  Widget buildSizedBoxChild(SudokuBloc sudokuBloc, SettingsBloc settingsBloc,
      SudokuState state, double minScreenSideLength) {
    //--------------------------------------------------------------------------
    if (state is SudokuImageSelectionSucceed) {
      Future.delayed(const Duration(seconds: 1),
          () => sudokuBloc.add(SudokuImageRenderingDone()));

      return imageWidget(
          bloc: sudokuBloc,
          opacity: 1.0,
          image: state.sudokuImage!.encodedBmpImage,
          cellSideLength:
              cellSideLength(minScreenSideLength, settingsBloc)); //,
    }

    //--------------------------------------------------------------------------
    if (state is SudokuCellsWithImages) {
      return Stack(
        alignment: Alignment.center,
        children: [
          sudokuWidget(
            sudoku: sudokuBloc.state.sudokuModel,
            cellSideLength: cellSideLength(minScreenSideLength, settingsBloc),
            cellDividerSize: 0.0,
            subgridDividerSize: 0.0,
          ),
          TweenAnimationBuilder(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInExpo,
            tween: Tween<double>(begin: 1.0, end: 0.0),
            onEnd: () {
              sudokuBloc.add(SudokuImageHidden());
            },
            builder: (BuildContext context, Object? value, Widget? child) {
              return imageWidget(
                  bloc: sudokuBloc,
                  opacity: value as double,
                  image: state.sudokuImage!.encodedBmpImage,
                  cellSideLength:
                      cellSideLength(minScreenSideLength, settingsBloc));
            },
          )
        ],
      );
    }

    //--------------------------------------------------------------------------
    if (state is SudokuCellRepositioning) {
      return TweenAnimationBuilder(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInExpo,
        tween: Tween<double>(
            begin: 0.0,
            end: settingsBloc.state.settings.gridSettings.subgridDividerSize),
        onEnd: () {
          sudokuBloc.add(SudokuCellsRepositioningDone());
        },
        builder: (BuildContext context, Object? value, Widget? child) {
          return sudokuWidget(
            sudoku: sudokuBloc.state.sudokuModel,
            cellSideLength: cellSideLength(minScreenSideLength, settingsBloc),
            cellDividerSize: min((value as double),
                settingsBloc.state.settings.gridSettings.cellDividerSize),
            subgridDividerSize: value,
          );
        },
      );
    }

    //--------------------------------------------------------------------------
    return sudokuWidget(
      sudoku: sudokuBloc.state.sudokuModel,
      cellSideLength: cellSideLength(minScreenSideLength, settingsBloc),
      cellDividerSize: settingsBloc.state.settings.gridSettings.cellDividerSize,
      subgridDividerSize:
          settingsBloc.state.settings.gridSettings.subgridDividerSize,
    );
  }

  double cellSideLength(double minOfScreenSides, SettingsBloc bloc) {
    logger.finest('cellSideLength');
    final cellDividerSize = bloc.state.settings.gridSettings.cellDividerSize;
    final subgridDividerSize =
        bloc.state.settings.gridSettings.subgridDividerSize;
    final sudokuSize =
        bloc.state.settings.sudokuSettings.sudokuSize; // sudoku is square
    final sudokuSubgridSize = sqrt(sudokuSize); // subgrids are squares

    return (minOfScreenSides -
            (sudokuSize - 1 - (sudokuSubgridSize - 1)) *
                cellDividerSize.truncate() -
            (sudokuSubgridSize - 1) * subgridDividerSize) /
        sudokuSize;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final wh = min(w, h) * 0.96;
    logger.info('SizedBox side length: $wh');

    return BlocBuilder<SudokuBloc, SudokuState>(
      buildWhen: (prevState, currState) {
        logger.info('prevState is $prevState,  currState is $currState');
        return currState is SudokuInitial ||
            currState is SudokuImageSelectionStarted ||
            currState is SudokuImageSelectionSucceed ||
            currState is SudokuCellsWithImages ||
            currState is SudokuCellRepositioning ||
            currState is SudokuImageSelectionInProgress; // ||
      },
      builder: (context, sudokuState) {
        logger.info('BlockBuilder');
        logger.info('state: $sudokuState');

        final sudokuBloc = BlocProvider.of<SudokuBloc>(context);

        // if (sudokuBloc.state is SudokuImageSelectionStarted) {
        if (sudokuState is SudokuImageSelectionStarted) {
          final imagePathProvider = sudokuState.imagePathProvider;
          Future<void>.delayed(const Duration(milliseconds: 1), () async {
            // final imageFile =
            //     await ImagePicker().pickImage(source: ImageSource.gallery);
            final imageFile = await imagePathProvider.getFilePath();
            logger.info('imageFile: ${imageFile?.path}');
            sudokuBloc.add(SudokuImageSelectionDone(imageFile: imageFile));
          });
          sudokuBloc.add(SudokuImagePickerStarted());
          return const CircularProgressIndicator();
        }

        if (sudokuBloc.state is SudokuImageSelectionInProgress) {
          return const CircularProgressIndicator();
        }

        return SizedBox(
          width: wh,
          height: wh,
          child: BlocBuilder<PresentationBloc, PresentationState>(
            builder: (context, presentationState) {
              final settingsBloc = BlocProvider.of<SettingsBloc>(context);
              return Stack(alignment: Alignment.center, children: [
                Center(
                    child: buildSizedBoxChild(
                        sudokuBloc, settingsBloc, sudokuState, wh)),
                Visibility(
                  visible: presentationState is SettingsDialogIsOpened,
                  child: SettingsDialog(),
                )
              ]);
            },
          ),
        );
      },
    );
  }
}
