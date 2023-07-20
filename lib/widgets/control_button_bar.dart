import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';

import '../blocs/presentation/presentation_bloc.dart';
import '../blocs/presentation/presentation_events.dart';
import '../blocs/sudoku_bloc.dart';
import '../blocs/sudoku_events.dart';

class ControlButtonBar extends StatelessWidget {
  ControlButtonBar({
    super.key,
  });

  final textStyle = const TextStyle(color: Colors.black);

  double _buttonWidth = 0.0;
  double _buttonHeight = 0.0;

  Widget buildButton(Key? key, String label, void Function() onPressed) =>
      Flexible(
        child: SizedBox(
          width: _buttonWidth,
          height: _buttonHeight,
          child: ElevatedButton(
            key: key,
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: Center(
              child: Text(
                label,
                style: textStyle,
              ),
            ),
          ),
        ),
      );

  List<Widget> buttons(BuildContext context, SudokuBloc sudokuBloc,
          PresentationBloc presentationBloc) =>
      [
        buildButton(
            const Key('select_image_btn'),
            AppLocalizations.of(context)!.btnLabelImage,
            () => sudokuBloc.add(SudokuSelectImagePressed())),
        const SizedBox(width: 2.0, height: 8.0),
        buildButton(
            const Key('solve_btn'),
            AppLocalizations.of(context)!.btnLabelSolve,
            () => sudokuBloc.add(SudokuCalculatePressed())),
        const SizedBox(width: 2.0, height: 8.0),
        buildButton(
            const Key('reset_btn'),
            AppLocalizations.of(context)!.btnLabelRestart,
            () => sudokuBloc.add(SudokuStarted())),
        const SizedBox(width: 2.0, height: 8.0),
        buildButton(
            const Key('settings_btn'),
            AppLocalizations.of(context)!.btnLabelSettings,
            () => presentationBloc.add(SettingsButtonPressed())),
      ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenOrientation = mediaQuery.orientation;
    final sudokuBloc = BlocProvider.of<SudokuBloc>(context);
    final presentationBloc = BlocProvider.of<PresentationBloc>(context);

    _buttonWidth = screenSize.width / 4;
    if (screenOrientation == Orientation.portrait) {
      _buttonHeight = _buttonWidth / 2;
    } else {
      _buttonHeight = _buttonWidth / 3;
    }

    return screenOrientation == Orientation.portrait
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons(context, sudokuBloc, presentationBloc))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons(context, sudokuBloc, presentationBloc));
  }
}
