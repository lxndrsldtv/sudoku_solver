import 'package:sudoku_solver/models/app_settings_model.dart';

abstract class SettingsState {
  SettingsState({required this.settings});

  final AppSettingsModel settings;
}

class SettingsInitial extends SettingsState {
  SettingsInitial() : super(settings: AppSettingsModel());
}

// class SettingsDialogIsOpened extends SettingsState {
//   SettingsDialogIsOpened({required settings}) : super(settings: settings);
// }

// class SettingsDialogIsClosed extends SettingsState {
//   SettingsDialogIsClosed({required settings}) : super(settings: settings);
// }

class SettingsValueUpdated extends SettingsState {
  SettingsValueUpdated({required AppSettingsModel settings})
      : super(settings: settings);
}

// class SettingsValueUpdated extends SettingsDialogIsOpened {
//   SettingsValueUpdated({required settings}) : super(settings: settings);
// }
