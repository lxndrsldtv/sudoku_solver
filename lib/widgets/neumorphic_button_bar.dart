import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../blocs/sudoku_bloc.dart';
import '../blocs/sudoku_events.dart';

class NeumorphicButtonBar extends StatelessWidget {
  NeumorphicButtonBar({
    super.key,
  });

  final buttonStyle =
      const NeumorphicStyle(color: Colors.white, depth: 1.0, intensity: 1.0);
  final textStyle =
      const NeumorphicStyle(color: Colors.black, depth: 1.0, intensity: 1.0);

  double _buttonWidth = 0.0;
  double _buttonHeight = 0.0;

  Widget buildButton(String label, void Function() onPressed) => Flexible(
      child: SizedBox(
          width: _buttonWidth,
          height: _buttonHeight,
          child: NeumorphicButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: Center(child: NeumorphicText(label, style: textStyle)))));

  List<Widget> buttons(BuildContext context, SudokuBloc bloc) => [
        buildButton(AppLocalizations.of(context)!.btnLabelImage, () => bloc.add(SudokuSelectImagePressed())),
        const SizedBox(width: 2.0, height: 8.0),
        buildButton(AppLocalizations.of(context)!.btnLabelSolve, () => bloc.add(SudokuCalculatePressed())),
        const SizedBox(width: 2.0, height: 8.0),
        buildButton(AppLocalizations.of(context)!.btnLabelRestart, () => bloc.add(SudokuStarted())),
        const SizedBox(width: 2.0, height: 8.0),
        buildButton(AppLocalizations.of(context)!.btnLabelSettings, () => bloc.add(SudokuSettingsPressed())),
      ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenOrientation = mediaQuery.orientation;
    final sudokuBloc = BlocProvider.of<SudokuBloc>(context);

    _buttonWidth = screenSize.width / 4;
    if (screenOrientation == Orientation.portrait) {
      _buttonHeight = _buttonWidth / 2;
    } else {
      _buttonHeight = _buttonWidth / 3;
    }

    return screenOrientation == Orientation.portrait
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons(context, sudokuBloc))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons(context, sudokuBloc));
  }
}
