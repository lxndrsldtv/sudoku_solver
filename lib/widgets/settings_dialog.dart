import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:logging/logging.dart';

import '../blocs/sudoku_bloc.dart';
import '../blocs/sudoku_events.dart';
import '../blocs/sudoku_states.dart';
import './dialog_frame.dart';

class SettingsDialog extends StatelessWidget {
  final logger = Logger('SettingsDialog');

  SettingsDialog({Key? key}) : super(key: key);

  Widget buildLabel(String text) => NeumorphicText(
        text,
        style: const NeumorphicStyle(
            color: Colors.black87, depth: 1.0, intensity: 1.0),
        textStyle: NeumorphicTextStyle(fontSize: 16),
      );

  @override
  Widget build(BuildContext context) {
    final sudokuBloc = BlocProvider.of<SudokuBloc>(context);

    return BlocBuilder<SudokuBloc, SudokuState>(builder: (context, state) {
      logger.info('BlocBuilder');
      return DialogFrame(
          titleText: 'Settings',
          children: [
            Column(children: [
              Neumorphic(
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  style: const NeumorphicStyle(depth: 4.0, color: Colors.white),
                  child: Row(children: [
                    buildLabel('Show image in cell corner:'),
                    const Spacer(),
                    NeumorphicCheckbox(
                        style: const NeumorphicCheckboxStyle(
                            selectedDepth: -1.0,
                            unselectedDepth: 1.0,
                            unselectedIntensity: 1.0,
                            lightSource: LightSource.topLeft,
                            selectedColor: Colors.white),
                        value: sudokuBloc
                            .state.settings.cellSettings.displayCellImage,
                        onChanged: (value) =>
                            sudokuBloc.add(SudokuImageInCellSwitched()))
                  ]))
            ])
          ],
          onClose: () => sudokuBloc.add(SudokuSettingsPressed()));
    });
  }
}
