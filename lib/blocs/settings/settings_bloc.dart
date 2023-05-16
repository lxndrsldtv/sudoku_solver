import 'package:logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './settings_events.dart';
import './settings_states.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final logger = Logger('SettingsBloc');

  SettingsBloc() : super(SettingsInitial()) {
    // on<SettingsButtonPressed>(_onSettingsButtonPressed);
    on<ShowImageInCellFlagValueToggled>(_onShowImageInCellFlagValueToggled);
    // on<SettingsDialogCloseButtonPressed>(_onSettingsDialogCloseButtonPressed);
  }

  // void _onSettingsButtonPressed(
  //     SettingsEvent event, Emitter<SettingsState> emit) async {
  //   logger.info('Received event: $event');
  //   logger.info('Current state: $state');
  //   state is SettingsDialogIsOpened
  //       ? emit(SettingsDialogIsClosed(settings: state.settings))
  //       : emit(SettingsDialogIsOpened(settings: state.settings));
  //   logger.info('Emitted state: $state');
  // }

  void _onShowImageInCellFlagValueToggled(
      SettingsEvent event, Emitter<SettingsState> emit) async {
    logger.info('Received event: $event');
    final settingsModel = state.settings;
    settingsModel.cellSettings.displayCellImage = !settingsModel.cellSettings.displayCellImage;
    emit(SettingsValueUpdated(settings: settingsModel));
    logger.info('Emitted state: $state');
  }

  // void _onSettingsDialogCloseButtonPressed(
  //     SettingsEvent event, Emitter<SettingsState> emit) async {
  //   logger.info('Received event: $event');
  //   emit(SettingsDialogIsClosed(settings: state.settings));
  //   logger.info('Emitted state: $state');
  // }
}
