import 'package:sudoku_solver/models/app_settings_model.dart';

abstract class SettingsState {
  SettingsState({required this.settings});

  final AppSettingsModel settings;
}

class SettingsInitial extends SettingsState {
  SettingsInitial() : super(settings: AppSettingsModel());
}

class SettingsValueUpdated extends SettingsState {
  SettingsValueUpdated({required AppSettingsModel settings})
      : super(settings: settings);
}
