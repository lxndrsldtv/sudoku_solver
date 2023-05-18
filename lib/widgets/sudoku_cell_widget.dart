import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../blocs/settings/settings_bloc.dart';
import '../blocs/settings/settings_states.dart';
import '../blocs/sudoku_bloc.dart';
import '../blocs/sudoku_events.dart';
import '../blocs/sudoku_states.dart';
import '../models/sudoku_cell_model.dart';
import '../widgets/set_cell_value_dialog.dart';

class SudokuCellWidget extends StatelessWidget {
  SudokuCellWidget({
    super.key,
    required this.cellSize,
    required this.cellIndex,
  });

  final logger = Logger('SudokuCellWidget');

  // final key;
  final double cellSize;
  final int cellIndex;

  @override
  Widget build(BuildContext context) {
    final sudokuBloc = BlocProvider.of<SudokuBloc>(context);
    logger.info('state: ${sudokuBloc.state}');

    return BlocBuilder<SudokuBloc, SudokuState>(
      key: Key('bbc$cellIndex'),
      buildWhen: (prevState, currState) {
        logger.info('prevState is $prevState,  currState is $currState');
        final doRebuild = (currState is SudokuCellReplaced &&
                currState.changedCell.index == cellIndex) ||
            currState is SudokuImageDividingSucceed ||
            currState is SudokuCellRepositioning ||
            currState is SudokuInitial;
        logger.info('doRebuild = $doRebuild');
        return doRebuild;
      },
      builder: (context, state) {
        logger.info('BlockBuilder');

        late final SudokuCellModel cell;
        if (state is SudokuCellReplaced) {
          cell = state.changedCell;
        } else {
          cell = state.sudoku.cells[cellIndex];
        }

        return SizedBox(
            width: cellSize,
            height: cellSize,
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(1.0),
                    backgroundColor: Colors.white,
                    elevation: 4.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                child: state is SudokuImageDividingSucceed ||
                        state is SudokuCellRepositioning
                    ? null != cell.image
                        ? Image.memory(cell.image!)
                        : SizedBox(width: cellSize, height: cellSize)
                    : SizedBox(
                        width: cellSize,
                        height: cellSize,
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: BlocBuilder<SettingsBloc, SettingsState>(
                                  builder: (context, settingsState) {
                                return null != cell.image &&
                                        settingsState.settings.cellSettings
                                            .displayCellImage
                                    ? SizedBox(
                                        width: cellSize / 3, // 12.0,
                                        height: cellSize / 3, // 12.0,
                                        child: Image.memory(cell.image!))
                                    : const SizedBox(width: 0.0, height: 0.0);
                              })),
                          Text(
                              key: Key('cell_text_$cellIndex'),
                              cell.value == 0 ? '' : cell.value.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: cell.testedValues.isEmpty
                                      ? Colors.black
                                      : Colors.red))
                        ])),
                onPressed: () async {
                  int? res = await showDialog(
                      context: context,
                      builder: (context) =>
                          SetCellValueDialog(cellModel: cell));
                  logger.info('Dialog result = $res');
                  res != null
                      ? sudokuBloc.add(SudokuCellValueSelected(
                          index: cell.index, value: res))
                      : {};
                }));
      },
    );
  }
}
