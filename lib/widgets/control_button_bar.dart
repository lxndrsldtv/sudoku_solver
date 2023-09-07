import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';

import './camera_widget.dart';
import '../blocs/presentation/presentation_bloc.dart';
import '../blocs/presentation/presentation_events.dart';
import '../blocs/sudoku_bloc.dart';
import '../blocs/sudoku_events.dart';

class ControlButtonBar extends StatelessWidget {
  const ControlButtonBar({
    super.key,
  });

  final textStyle = const TextStyle(color: Colors.black);

  Widget buildIconButton(Key? key, Widget icon, double? iconSize,
          String tooltip, void Function() onPressed) =>
      Flexible(
        child: IconButton(
          key: key,
          icon: icon,
          iconSize: iconSize,
          tooltip: tooltip,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
      );

  List<Widget> buttons(BuildContext context, SudokuBloc sudokuBloc,
      PresentationBloc presentationBloc) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final screenOrientation = mediaQuery.orientation;
    final appLocalizations = AppLocalizations.of(context);

    final buttonDescriptions = [
      {
        'key': const Key('select_image_btn'),
        'icon': const Icon(Icons.image_search_rounded),
        'tooltip': appLocalizations?.btnLabelImage ?? 'Select image',
        'handler': () => sudokuBloc.add(SudokuSelectImagePressed()),
      },
      {
        'key': const Key('camera_btn'),
        'icon': const Icon(Icons.camera),
        'tooltip': appLocalizations?.btnLabelCamera ?? 'Take picture',
        'handler': () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const CameraWidget())),
      },
      {
        'key': const Key('solve_btn'),
        'icon': const Icon(Icons.play_circle),
        'tooltip': appLocalizations?.btnLabelSolve ?? 'Solve',
        'handler': () => sudokuBloc.add(SudokuCalculatePressed()),
      },
      {
        'key': const Key('reset_btn'),
        'icon': const Icon(Icons.restart_alt),
        'tooltip': appLocalizations?.btnLabelRestart ?? 'Restart',
        'handler': () => sudokuBloc.add(SudokuStarted()),
      },
      {
        'key': const Key('settings_btn'),
        'icon': const Icon(Icons.settings),
        'tooltip': appLocalizations?.btnLabelSettings ?? 'Settings',
        'handler': () => presentationBloc.add(SettingsButtonPressed()),
      }
    ];

    // calculate size of icons depending on number of buttons and spaces
    // between them
    double? iconSize;
    final numberOfButtonsAndSpaces = buttonDescriptions.length * 2;
    if (screenOrientation == Orientation.portrait) {
      iconSize = screenSize.width / numberOfButtonsAndSpaces;
    } else {
      iconSize = screenSize.height / numberOfButtonsAndSpaces;
    }

    // map button "descriptions" to widgets
    return buttonDescriptions.map((e) =>
      buildIconButton(
          e['key'] as Key,
          e['icon']as Icon,
          iconSize,
          e['tooltip'] as String,
          e['handler'] as void Function())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenOrientation = mediaQuery.orientation;
    final sudokuBloc = BlocProvider.of<SudokuBloc>(context);
    final presentationBloc = BlocProvider.of<PresentationBloc>(context);

    return screenOrientation == Orientation.portrait
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons(context, sudokuBloc, presentationBloc))
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buttons(context, sudokuBloc, presentationBloc));
  }
}
