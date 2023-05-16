import 'package:logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './settings_events.dart';
import './settings_states.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final logger = Logger('SettingsBloc');

  SettingsBloc() : super(SettingsInitial()) {
    on<ShowImageInCellFlagValueToggled>(_onShowImageInCellFlagValueToggled);
  }

  void _onShowImageInCellFlagValueToggled(
      SettingsEvent event, Emitter<SettingsState> emit) async {
    logger.info('Received event: $event');
    final settingsModel = state.settings;
    settingsModel.cellSettings.displayCellImage = !settingsModel.cellSettings.displayCellImage;
    emit(SettingsValueUpdated(settings: settingsModel));
    logger.info('Emitted state: $state');
  }
}
