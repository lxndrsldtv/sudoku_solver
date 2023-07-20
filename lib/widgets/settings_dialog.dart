import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'package:sudoku_solver/blocs/presentation/presentation_bloc.dart';

import './dialog_frame.dart';
import '../blocs/presentation/presentation_events.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/settings/settings_events.dart';
import '../blocs/settings/settings_states.dart';

class SettingsDialog extends StatelessWidget {
  final logger = Logger('SettingsDialog');

  SettingsDialog({Key? key}) : super(key: key);

  Widget buildLabel(String text) => Text(
        text,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      );

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final presentationBloc = BlocProvider.of<PresentationBloc>(context);

    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      logger.info('BlocBuilder');
      return DialogFrame(
          titleText: 'Settings',
          children: [
            Column(children: [
              Container(
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Row(children: [
                    buildLabel('Show image in cell corner:'),
                    const Spacer(),
                    Checkbox(
                      activeColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      value: settingsBloc
                          .state.settings.cellSettings.displayCellImage,
                      onChanged: (value) =>
                          settingsBloc.add(ShowImageInCellFlagValueToggled()),
                    ),
                  ]))
            ])
          ],
          onClose: () =>
              presentationBloc.add(SettingsDialogCloseButtonPressed()));
    });
  }
}
