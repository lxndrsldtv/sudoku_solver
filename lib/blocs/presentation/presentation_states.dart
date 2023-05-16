import '../../models/app_presentation_model.dart';

abstract class PresentationState {
  PresentationState({required this.presentationModel});

  final AppPresentationModel presentationModel;
}

class PresentationInitial extends PresentationState {
  PresentationInitial() : super(presentationModel: AppPresentationModel());
}

class SettingsDialogIsOpened extends PresentationState {
  SettingsDialogIsOpened({required AppPresentationModel presentationModel})
      : super(presentationModel: presentationModel);
}

class SettingsDialogIsClosed extends PresentationState {
  SettingsDialogIsClosed({required AppPresentationModel presentationModel})
      : super(presentationModel: presentationModel);
}
