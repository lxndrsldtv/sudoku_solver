import 'package:logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './presentation_events.dart';
import './presentation_states.dart';

class PresentationBloc extends Bloc<PresentationEvent, PresentationState> {
  final logger = Logger('PresentationBloc');

  PresentationBloc() : super(PresentationInitial()) {
    on<SettingsButtonPressed>(_onSettingsButtonPressed);
    on<SettingsDialogCloseButtonPressed>(_onSettingsDialogCloseButtonPressed);
  }

  void _onSettingsButtonPressed(
      PresentationEvent event, Emitter<PresentationState> emit) async {
    logger.info('Received event: $event');
    logger.info('Current state: $state');
    final presentationModel = state.presentationModel;
    presentationModel.settingsDialogPresentationModel.isDialogOpened =
        !presentationModel.settingsDialogPresentationModel.isDialogOpened;

    presentationModel.settingsDialogPresentationModel.isDialogOpened == true
        ? emit(SettingsDialogIsOpened(presentationModel: presentationModel))
        : emit(SettingsDialogIsClosed(presentationModel: presentationModel));
    logger.info('Emitted state: $state');
  }

  void _onSettingsDialogCloseButtonPressed(
      PresentationEvent event, Emitter<PresentationState> emit) async {
    logger.info('Received event: $event');
    final presentationModel = state.presentationModel;
    presentationModel.settingsDialogPresentationModel.isDialogOpened = false;
    emit(SettingsDialogIsClosed(presentationModel: presentationModel));
    logger.info('Emitted state: $state');
  }
}
