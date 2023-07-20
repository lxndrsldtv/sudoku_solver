import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import './sudoku_cell_widget.dart';
import '../blocs/presentation/presentation_bloc.dart';
import '../blocs/presentation/presentation_states.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/sudoku_bloc.dart';
import '../blocs/sudoku_events.dart';
import '../blocs/sudoku_states.dart';
import '../models/sudoku_model.dart';
import '../widgets/settings_dialog.dart';

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

    final lastSubgridDivider =
        Row(children: const [SizedBox(width: 0.0, height: 0.0)]);

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
      if ((index + 1) % sudoku.size.columns == 0) {
        rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.center, children: prevValue));
        // add horizontal divider (empty row of some height)
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

  Column sudokuWidget(SudokuModel sudoku, double cellSideLength,
          double cellDividerSize, double subgridDividerSize) =>
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildSudokuGrid(
              sudoku: sudoku,
              cellSize: cellSideLength,
              cellDividerSize: cellDividerSize,
              subgridDividerSize: subgridDividerSize));

  Opacity imageWidget(SudokuBloc bloc, double opacity, String path,
          double cellSideLength) =>
      Opacity(
          opacity: opacity,
          child: SizedBox(
              width: cellSideLength * bloc.state.sudoku.size.columns,
              height: cellSideLength * bloc.state.sudoku.size.rows,
              child: Image.file(File(path))));

  Widget buildSizedBoxChild(SudokuBloc sudokuBloc, SettingsBloc settingsBloc,
      SudokuState state, double minScreenSideLength) {
    if (state is SudokuImageSelectionSucceed) {
      Future.delayed(const Duration(seconds: 1),
          () => sudokuBloc.add(SudokuImageProcessRequested()));

      return Stack(alignment: Alignment.center, children: [
        sudokuWidget(sudokuBloc.state.sudoku,
            cellSideLength(minScreenSideLength, settingsBloc), 0.0, 0.0),
        imageWidget(sudokuBloc, 1.0, state.sudoku.imageFile!.path,
            cellSideLength(minScreenSideLength, settingsBloc)),
      ]);
    }

    if (state is SudokuImageDividingSucceed) {
      return Stack(alignment: Alignment.center, children: [
        sudokuWidget(sudokuBloc.state.sudoku,
            cellSideLength(minScreenSideLength, settingsBloc), 0.0, 0.0),
        TweenAnimationBuilder(
          duration: const Duration(seconds: 1),
          tween: Tween<double>(begin: 1.0, end: 0.0),
          onEnd: () {
            Future.delayed(const Duration(seconds: 1),
                () => sudokuBloc.add(SudokuCellRepositioningRequested()));
          },
          builder: (BuildContext context, Object? value, Widget? child) {
            return imageWidget(
                sudokuBloc,
                value as double,
                state.sudoku.imageFile!.path,
                cellSideLength(minScreenSideLength, settingsBloc));
          },
        )
      ]);
    }

    if (state is SudokuCellRepositioning) {
      return TweenAnimationBuilder(
        duration: const Duration(seconds: 1),
        tween: Tween<double>(
            begin: 0.0,
            end: settingsBloc.state.settings.gridSettings.subgridDividerSize),
        onEnd: () {
          Future.delayed(const Duration(seconds: 1),
              () => sudokuBloc.add(SudokuCellValueRecognitionRequested()));
        },
        builder: (BuildContext context, Object? value, Widget? child) {
          return sudokuWidget(
              sudokuBloc.state.sudoku,
              cellSideLength(minScreenSideLength, settingsBloc),
              min((value as double),
                  settingsBloc.state.settings.gridSettings.cellDividerSize),
              value);
        },
      );
    }

    return sudokuWidget(
        sudokuBloc.state.sudoku,
        cellSideLength(minScreenSideLength, settingsBloc),
        settingsBloc.state.settings.gridSettings.cellDividerSize,
        settingsBloc.state.settings.gridSettings.subgridDividerSize);
  }

  double cellSideLength(double minOfScreenSides, SettingsBloc bloc) {
    logger.finest('cellSideLength');
    final cellDividerSize = bloc.state.settings.gridSettings.cellDividerSize;
    final subgridDividerSize =
        bloc.state.settings.gridSettings.subgridDividerSize;
    // final sudokuSize = bloc.state.sudoku.size.columns; // sudoku is square
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
            currState is SudokuImageSelectionSucceed ||
            currState is SudokuImageDividingSucceed ||
            currState is SudokuCellRepositioning; // ||
      },
      builder: (context, sudokuState) {
        logger.info('BlockBuilder');
        final sudokuBloc = BlocProvider.of<SudokuBloc>(context);

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
            ));
      },
    );
  }
}
